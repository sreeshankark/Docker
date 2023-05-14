# Base Image: Ubuntu
FROM ubuntu:latest

CMD ["--cpus", "32"]
CMD ["--memory", "40g"]

# Working Directory
WORKDIR /root

# Maintainer
MAINTAINER Sanju0910 <sreeshankar0910@gmail.com>

# Delete the profile files (we'll copy our own in the next step)
RUN \
rm -f \
    /etc/profile \
    ~/.profile \
    ~/.bashrc

# Copy the Proprietary Files
COPY ./proprietary /

# Clear cache and buffer

RUN rm -rf /var/cache/apk/* && \

    rm -rf /var/lib/apt/lists/* && \

    apt-get clean && \

    apt-get autoclean && \

    apt-get autoremove && \

    rm -rf /var/lib/{apt,dpkg,cache,log}/ && \

    sync 
    
# apt update
RUN apt update

# Install sudo
RUN apt install apt-utils sudo -y

# tzdata
ENV TZ Asia/Kolkata


RUN \
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata \
&& ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
&& apt-get install -y tzdata \
&& dpkg-reconfigure --frontend noninteractive tzdata

# Install git and ssh
RUN sudo apt install git ssh -y
RUN sudo apt install repo -y

# Configure git
ENV GIT_USERNAME Sanju0910
ENV GIT_EMAIL sreeshankar0910@gmail.com
RUN \
    git config --global user.name $GIT_USERNAME \
&&  git config --global user.email $GIT_EMAIL

# Update Packages
RUN \
sudo apt update

# Upgrade Packages
RUN \
sudo apt upgrade -y

# Autoremove Unwanted Packages
RUN \
sudo apt autoremove -y

# Install Packages
RUN \
sudo apt install \
    curl wget aria2 tmate python2 python3 silversearch* \
    iputils-ping iproute2 \
    nano rsync rclone tmux screen openssh-server \
    python3-pip adb fastboot jq npm neofetch mlocate \
    zip unzip tar ccache \
    cpio lzma \
    -y

# Filesystems
RUN \
sudo apt install \
    erofs-utils \
    -y

RUN \
sudo pip install \
    twrpdtgen

# Install schedtool and Java
RUN \
    sudo apt install \
        schedtool openjdk-8-jdk \
    -y

# Setup Android Build Environment
RUN \
git clone https://github.com/akhilnarang/scripts.git /tmp/scripts \
&& sudo bash /tmp/scripts/setup/android_build_env.sh \
&& rm -rf /tmp/scripts

# Use python2 as the Default python
RUN \
sudo ln -sf /usr/bin/python2 /usr/bin/python

RUN \
sudo pip install ninja

# Run bash
CMD ["bash"]
