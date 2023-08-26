FROM ubuntu:latest

MAINTAINER YourName <youremail@example.com>

# Prepare the main environment and install git
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y debootstrap x11vnc xvfb git

# Create a new directory for the chroot environment
RUN mkdir /chroot

# Use debootstrap to install a basic Ubuntu system in the /chroot directory
RUN debootstrap jammy /chroot http://archive.ubuntu.com/ubuntu/

# Chroot into the new environment, set it up, and install git
RUN echo "deb http://archive.ubuntu.com/ubuntu/ jammy main restricted universe multiverse" > /chroot/etc/apt/sources.list && \
    chroot /chroot /bin/bash -c "DEBIAN_FRONTEND=noninteractive apt-get update" && \
    chroot /chroot /bin/bash -c "DEBIAN_FRONTEND=noninteractive apt-get install -y xfce4 xfce4-terminal dbus-x11 wget python3 python3-pip git" && \
    chroot /chroot apt-get clean

# Clone noVNC into the chroot environment
RUN chroot /chroot git clone --branch v1.2.0 https://github.com/novnc/noVNC.git /root/noVNC && \
    chroot /chroot git clone https://github.com/novnc/websockify.git /root/noVNC/utils/websockify

# Setup a password for x11vnc
RUN x11vnc -storepasswd 1128 /chroot/root/.vncpasswd

# Start command
CMD ["sh", "-c", "chroot /chroot /bin/bash -c 'Xvfb :1 -screen 0 1280x720x24 & x11vnc -forever -usepw -display :1 & /root/noVNC/utils/launch.sh --vnc localhost:5900 & startxfce4'"]

