# 使用官方的Ubuntu作为基础镜像
FROM ubuntu:latest

USER root

# 设置非交互式环境
ENV DEBIAN_FRONTEND=noninteractive

# 安装必要的软件
RUN apt update && \
    apt install -y --no-install-recommends xfce4 xfce4-goodies xfonts-base xfonts-100dpi novnc x11vnc && \
    apt clean

# 配置noVNC和Xvnc
RUN mkdir -p ~/.vnc && \
    echo 'startxfce4 &' > ~/.vnc/xstartup && \
    chmod +x ~/.vnc/xstartup

# 设置VNC密码
RUN x11vnc -storepasswd 1128 ~/.vnc/passwd

# 设置时区（示例为Asia/Shanghai）
ENV TZ=Asia/Shanghai

# 启动noVNC（注意：不需要websockify）
CMD vncserver :0 -localhost no && /usr/share/novnc/utils/launch.sh --vnc localhost:5900
