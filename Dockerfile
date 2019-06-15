FROM raspbian/stretch
 
RUN apt update && apt upgrade -y && apt install -y git python-dev python-pip python-libxml2 python-lxml libcurl4-openssl-dev libxml2-dev libxslt1-dev screen curl rpi-update node yarn
RUN pip install future mavproxy dronekit dronekit-sitl
RUN apt install -y npm
#RUN n 5.6.0
#RUN export PATH="$PATH:$(yarn global bin)"
#RUN yarn global add tty.js
RUN git clone https://github.com/tj/n.git && cd n && make install
RUN n 5.6.0
RUN mkdir /home/pi/
RUN mkdir /home/pi/companion/
WORKDIR /home/pi/

#RUN /home/pi/companion/scripts/setup.sh
ENV PATH=/home/pi/companion/node_modules/.bin:$PATH
RUN cd /home/pi/companion && npm install risacher/ttyx

RUN echo /home/pi/companion/.companion.rc >> /etc/rc.local
RUN chmod 777 /run/screen
RUN pip install bluerobotics-ping==0.0.7
RUN apt install -y libv4l-dev
COPY companion/br-webui /home/pi/companion//br-webui
ENV JOBS=7
RUN cd /home/pi/companion/br-webui && npm install

RUN apt install -y gstreamer1.0-libav gstreamer1.0-plugins-base gstreamer1.0-plugins-bad gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly
ENV HOME=/home/pi

RUN apt install -y python3 python3-pip
RUN apt install -y zlib1g-dev
RUN pip3 install mavproxy[server] pyserial
RUN pip3 install --upgrade pip
RUN pip3 install git+https://github.com/williangalvani/MAVProxy.git@fixjson --upgrade
COPY companion /home/pi/companion/

# Copy udev rules
COPY companion/params/100.autopilot.rules /etc/udev/rules.d/
#CMD "/home/pi/companion/.companion.rc" >> /root/.bashrc
ENTRYPOINT ["/bin/bash", "/home/pi/companion/.companion.rc"]

#CMD ["/bin/bash"]