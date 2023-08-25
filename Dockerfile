# 使用官方的ubuntu作为基础镜像
FROM ubuntu:latest

# 维护者信息
MAINTAINER junquan <wxin924@gmail.com>

# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

# 更新并安装必要的工具、时区设置以及wine
RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get install -y \
    net-tools \
    git \
    wget \
    unzip \
    python3 \
    python3-numpy \
    python3-pip \
    supervisor \
    x11vnc \
    xvfb \
    gnome-session \
    gnome-panel \
    gnome-settings-daemon \
    metacity \
    nautilus \
    gnome-terminal \
    wmctrl \
    tzdata \
    wine64 \
    wine32 && \
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

# 克隆noVNC仓库并安装websockify
RUN git clone --branch v1.2.0 https://github.com/novnc/noVNC.git /root/noVNC
RUN git clone https://github.com/novnc/websockify.git /root/noVNC/utils/websockify
RUN chmod +x -v /root/noVNC/utils/*.sh


# 设置VNC密码
RUN mkdir ~/.vnc && x11vnc -storepasswd 1128 ~/.vnc/passwd

# 启动VNC、noVNC和fluxbox
CMD ["sh", "-c", "x11vnc -forever -usepw -create & /root/noVNC/utils/launch.sh --vnc localhost:5900 & gnome-session"]
