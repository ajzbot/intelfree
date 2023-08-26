# 使用官方的ubuntu作为基础镜像
FROM ubuntu:latest

# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai
ENV DISPLAY=:1

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
    xfce4 \
    xfce4-terminal \
    dbus-x11 \
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
CMD ["sh", "-c", "Xvfb :1 -screen 0 1280x720x24 & x11vnc -forever -usepw -display :1 & /root/noVNC/utils/launch.sh --vnc localhost:5900 & startxfce4"]
