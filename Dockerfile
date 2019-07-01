
FROM raspbian/stretch
ENV JOBS=14 

RUN useradd -ou 0 -g 0 -ms /bin/bash pi
USER pi
WORKDIR /home/pi

# avoid installing docs
COPY 01_nodoc /etc/dpkg/dpkg.cfg.d/01_nodoc

# Copy cleanup script
COPY cleanup.sh /cleanup.sh

RUN apt update && apt upgrade -y && apt-get install -y --no-install-recommends git python-dev python-pip python-libxml2 python-lxml libcurl4-openssl-dev libssl-dev libxml2-dev libxslt1-dev screen curl rpi-update gstreamer1.0-libav gstreamer1.0-tools gstreamer1.0-plugins-good gstreamer1.0-plugins-bad python3 python3-pip zlib1g-dev libv4l-dev libraspberrypi-bin autoconf pkg-config libtool v4l-utils && rm -rf /var/lib/apt/lists/* && /cleanup.sh
RUN pip3 install --upgrade pip

RUN wget  -nc https://nodejs.org/download/release/v5.6.0/node-v5.6.0-linux-armv6l.tar.gz && tar -xf node-v5.6.0-linux-armv6l.tar.gz && rm node-v5.6.0-linux-armv6l.tar.gz
ENV PATH=/home/pi/node-v5.6.0-linux-armv6l/bin:$PATH
RUN node -v && npm -v

#RUN curl https://www.npmjs.org/install.sh | sh
RUN echo $PWD
RUN mkdir /home/pi/companion/
WORKDIR /home/pi/
ENV HOME=/home/pi 

#ENV PATH=/home/pi/companion/node_modules/.bin:$PATH

RUN git clone --branch dockerizing https://github.com/williangalvani/companion/

#move up
RUN apt update && apt install -y make build-essential python3-setuptools python3-dev

RUN cd /home/pi/companion && npm install risacher/ttyx


RUN chmod 775 /run/screen
RUN pip3 install bluerobotics-ping==0.0.7

RUN echo /home/pi/companion/.companion.rc >> /etc/rc.local

RUN mkdir /home/pi/.npm-global
ENV PATH=/home/pi/.npm-global/bin:$PATH
ENV NPM_CONFIG_PREFIX=/home/pi/.npm-global

RUN pip3 install mavproxy[server] pyserial

RUN pip3 install git+https://github.com/williangalvani/MAVProxy.git@fixjson --upgrade

#RUN pip2 install future mavproxy dronekit dronekit-sitl
#RUN pip2 install bluerobotics-ping==0.0.7 --upgrade --force-reinstall

RUN cd /home/pi/companion/br-webui && npm install


RUN cd /home/pi/companion && git pull --rebase origin dockerizing
RUN cd /home/pi/companion/br-webui && npm install
#RUN apt update && apt install -y wpasupplicant net-tools gstreamer1.0-tools gstreamer1.0-plugins-good libraspberrypi-bin

COPY companion/ /home/pi/companion/

#RUN git clone https://github.com/intel/mavlink-router.git 
#RUN cd mavlink-router && ./autogen.sh && ./configure CFLAGS='-g -O2' \
#        --sysconfdir=/etc --localstatedir=/var --libdir=/usr/lib \
#    --prefix=/usr 
#RUN cd mavlink-router && git submodule update --init --recursive && make && make install
#RUN mkdir /etc/mavlink-router
#COPY main.conf /etc/mavlink-router/main.conf

ENV COMPANION_DIR=/home/pi/companion/

#CMD ["/bin/bash"]
ENTRYPOINT ["/bin/bash", "/home/pi/companion/.companion.rc"]
