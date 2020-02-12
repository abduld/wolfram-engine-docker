FROM ubuntu:20.04
LABEL maintainer="dakkak@illinois.edu"
ENV DEBIAN_FRONTEND noninteractive

LABEL "com.wolfram.vendor" = "Wolfram Research"
LABEL version = "1.0"
LABEL maintainer = "arnoudb@wolfram.com"
LABEL description = "Docker image for the Wolfram Engine"


RUN apt-get update -q && apt-get install -qy --no-install-recommends --no-install-suggests \
    curl \
    avahi-daemon \
    wget \
    sshpass \
    sudo \
    locales \
    locales-all \
    ssh \
    vim \
    expect \
    libfontconfig1 \
    libgl1-mesa-glx \
    libasound2 \
    openssh-server \
    && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen


RUN mkdir /var/run/sshd
RUN echo 'root:admin' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22

RUN wget https://account.wolfram.com/download/public/wolfram-engine/desktop/LINUX && sudo bash LINUX -- -auto -verbose && rm LINUX

# CMD ["/usr/bin/wolframscript"]

CMD ["/usr/sbin/sshd", "-D"]

