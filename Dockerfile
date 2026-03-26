# Base Image: Ubuntu
FROM ubuntu:latest

CMD ["--cpus", "16"]
CMD ["--memory", "32g"]
CMD ["--oom-kill-disable"]

# Working Directory
WORKDIR /root

# Maintainer
MAINTAINER sreeshankark <sreeshankar0910@gmail.com>

# Delete the profile files (we'll copy our own in the next step)
RUN \
rm -f \
    /etc/profile \
    ~/.profile \
    ~/.bashrc

# Copy the Proprietary Files
COPY ./proprietary / 

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
ENV GIT_USERNAME sreeshankark
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
sudo apt install -y bc build-essential bison flex zip gcc clang libc6 \
            curl libstdc++6 git wget libssl-dev zstd lld openjdk-11-jdk llvm \
            openjdk-11-jre python3 python3-pip ccache gcc-arm-linux-gnueabi \
            gcc-aarch64-linux-gnu libyaml-dev cpio mkisofs wget device-tree-compiler
            
# Setup Android Build Environment
RUN \
git clone https://github.com/akhilnarang/scripts.git /tmp/scripts \
&& sudo bash /tmp/scripts/setup/android_build_env.sh \
&& rm -rf /tmp/scripts

RUN \
wget https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/main/clang-r547379.tar.gz -O clang.tar.gz
RUN \
mkdir clang-llvm 
RUN \
tar -xvf clang.tar.gz -C clang-llvm
RUN \
rm clang.tar.gz

# Run bash
CMD ["bash"]
