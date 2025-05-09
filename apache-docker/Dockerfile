FROM ubuntu:latest

LABEL maintainer="gentoober@gmail.com"

ENV DEBIAN_FRONTEND=noninteractive

COPY script-iac2.sh /root/script-iac2.sh

RUN apt update && apt install -y bash && \
    chmod +x /root/script-iac2.sh && \
    /root/script-iac2.sh

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

