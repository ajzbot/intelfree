FROM ubuntu:latest

LABEL maintainer="YourName <youremail@example.com>"

# Create a new directory for the chroot environment in the user's home directory
RUN mkdir -p $HOME/chroot

# Use debootstrap to install a basic Ubuntu system in the /chroot directory
RUN debootstrap jammy $HOME/chroot http://archive.ubuntu.com/ubuntu/

RUN echo "deb http://archive.ubuntu.com/ubuntu/ jammy main restricted universe multiverse" > $HOME/chroot/etc/apt/sources.list && \
    chroot $HOME/chroot /bin/bash -c "DEBIAN_FRONTEND=noninteractive apt-get update" && \
    chroot $HOME/chroot /bin/bash -c "DEBIAN_FRONTEND=noninteractive apt-get install -y xfce4 xfce4-terminal dbus-x11 wget python3 python3-pip git x11vnc xvfb" && \
    chroot $HOME/chroot apt-get clean

# Clone noVNC into the chroot environment
RUN chroot $HOME/chroot git clone --branch v1.2.0 https://github.com/novnc/noVNC.git $HOME/noVNC

# Clone websockify into the chroot environment
RUN chroot $HOME/chroot git clone https://github.com/novnc/websockify.git $HOME/noVNC/utils/websockify

RUN chroot $HOME/chroot x11vnc -storepasswd 1128 $HOME/.vncpasswd

CMD ["sh", "-c", "chroot $HOME/chroot /bin/bash -c 'Xvfb :1 -screen 0 1280x720x24 & x11vnc -forever -usepw -display :1 & $HOME/noVNC/utils/launch.sh --vnc localhost:5900 & startxfce4'"]
