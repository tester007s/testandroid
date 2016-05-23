FROM ubuntu:12.04

MAINTAINER Subho "subho.halder@gmail.com"

RUN     apt-get update -y
RUN     apt-get install -y --no-install-recommends x11vnc xvfb libncurses5:i386 libstdc++6:i386 openjdk-7-jdk ia32-libs ia32-libs-multiarch git ssh

# Main Android SDK
RUN apt-get install -y --no-install-recommends wget
RUN cd /opt && wget -q http://dl.google.com/android/android-sdk_r23.0.2-linux.tgz
RUN cd /opt && tar xzf android-sdk_r23.0.2-linux.tgz
RUN cd /opt && rm -f android-sdk_r23.0.2-linux.tgz

# Other tools and resources of Android SDK
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools
ENV HOME /root


RUN echo y | android update sdk -a -u -f -t tools
RUN echo y | android update sdk -a -u -f -t platform-tools
RUN echo y | android update sdk -a -u -f -t build-tools-20.0.0
RUN echo y | android update sdk -a -u -f -t android-19
RUN echo y | android update sdk -a -u -f -t android-18
RUN echo y | android update sdk -a -u -f -t android-17
RUN echo y | android update sdk -a -u -f -t addon-google_apis-google-19
RUN echo y | android update sdk -a -u -f -t addon-google_apis-google-18
RUN echo y | android update sdk -a -u -f -t addon-google_apis-google-17
RUN echo y | android update sdk -a -u -f -t extra-google-m2repository
RUN echo y | android update sdk -a -u -f -t extra-android-m2repository

# Set up and run emulator
RUN echo no | android create avd -t "Google Inc.:Google APIs:17" -c 512M -s 480x800 -n test
#Enabled hardware keyboard
RUN echo "hw.keyboard=yes" >> ~/.android/avd/test.avd/config.ini

# Install vnc, xvfb in order to create a 'fake' display and firefox
RUN     mkdir ~/.vnc
# Setup a password
RUN     x11vnc -storepasswd 1234 ~/.vnc/passwd
EXPOSE 5900
#Do a launch script

ADD launch.sh /usr/local/bin/launch
RUN chmod 755 /usr/local/bin/launch
