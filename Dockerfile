# 使用官方的Ubuntu作为基础镜像
FROM ubuntu:latest

# 安装必要的软件
RUN apt update && \
    apt install -y xfce4 xfce4-goodies xfonts-base xfonts-100dpi novnc websockify x11vnc && \
    apt clean

# 配置noVNC和Websockify
RUN mkdir -p ~/.vnc && \
    echo 'startxfce4 &' > ~/.vnc/xstartup && \
    chmod +x ~/.vnc/xstartup

# 设置VNC密码
RUN x11vnc -storepasswd 1128 ~/.vnc/passwd

# 启动noVNC和Websockify
CMD websockify --web=/usr/share/novnc/ --target-config=/root/.vnc/config --target-address=127.0.0.1 6080
