# 使用官方的Ubuntu作为基础镜像
FROM ubuntu:latest

# 设置非交互式环境
ENV DEBIAN_FRONTEND=noninteractive

# 安装必要的软件
RUN apt update && \
    apt install -y xfce4 xfce4-goodies xfonts-base xfonts-100dpi novnc websockify x11vnc && \
    apt clean

# 配置noVNC和Websockify
RUN mkdir -p ~/.vnc && \
    echo 'startxfce4 &' > ~/.vnc/xstartup && \
    chmod +x ~/.vnc/xstartup

# 设置VNC密码
RUN x11vnc -storepasswd YOUR_PASSWORD_HERE ~/.vnc/passwd

# 设置时区（示例为Asia/Shanghai）
ENV TZ=Asia/Shanghai

# 启动noVNC和Websockify
CMD websockify --web=/usr/share/novnc/ --target-config=/root/.vnc/config --target-address=127.0.0.1 6080
