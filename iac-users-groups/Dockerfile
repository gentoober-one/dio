FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    passwd \
    openssl \
    sudo \
    unzip \
    wget \
    net-tools \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

COPY iacl.sh /usr/local/bin/iacl.sh

RUN chmod +x /usr/local/bin/iacl.sh

RUN /usr/local/bin/iacl.sh

CMD ["/bin/bash"]

