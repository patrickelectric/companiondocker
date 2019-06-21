
FROM raspbian/stretch
ENV JOBS=14 
RUN apt update && apt upgrade -y && apt install -y git python-dev python-pip python-libxml2 python-lxml libcurl4-openssl-dev libxml2-dev libxslt1-dev screen curl rpi-update gstreamer1.0-libav gstreamer1.0-plugins-base gstreamer1.0-plugins-bad gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly python3 python3-pip zlib1g-dev libv4l-dev npm && rm -rf /var/lib/apt/lists/*
RUN pip3 install --upgrade pip
RUN pip install future mavproxy dronekit dronekit-sitl


RUN wget -nc https://nodejs.org/download/release/v5.6.0/node-v5.6.0-linux-armv6l.tar.gz && tar -xf node-v5.6.0-linux-armv6l.tar.gz && rm node-v5.6.0-linux-armv6l.tar.gz
ENV PATH=/node-v5.6.0-linux-armv6l/bin:$PATH
#RUN curl https://www.npmjs.org/install.sh | sh
RUN echo $PWD
RUN mkdir /home/pi/
RUN mkdir /home/pi/companion/
WORKDIR /home/pi/
ENV HOME=/home/pi 

#ENV PATH=/home/pi/companion/node_modules/.bin:$PATH

RUN git clone --branch dockerizing https://github.com/williangalvani/companion/
RUN node -v
RUN npm -v
RUN cd /home/pi/companion && npm install risacher/ttyx


RUN chmod 775 /run/screen
RUN pip3 install bluerobotics-ping==0.0.7

RUN echo /home/pi/companion/.companion.rc >> /etc/rc.local

RUN mkdir /home/pi/.npm-global
ENV PATH=/home/pi/.npm-global/bin:$PATH
ENV NPM_CONFIG_PREFIX=/home/pi/.npm-global


RUN cd /home/pi/companion/br-webui && npm install

RUN pip3 install mavproxy[server] pyserial

RUN pip3 install git+https://github.com/williangalvani/MAVProxy.git@fixjson --upgrade
RUN pip2 install bluerobotics-ping==0.0.7 --upgrade --force-reinstall


RUN cd /home/pi/companion && git pull --rebase origin dockerizing
RUN cd /home/pi/companion/br-webui && npm install
RUN apt update && apt install -y wpasupplicant net-tools gstreamer1.0-tools gstreamer1.0-plugins-good libraspberrypi-bin

COPY companion/ /home/pi/companion/


#CMD ["/bin/bash"]
ENTRYPOINT ["/bin/bash", "/home/pi/companion/.companion.rc"]
