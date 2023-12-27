FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /root/.dotfiles

RUN apt update && \
    apt update && \
    apt install -y curl git build-essential python3 pip

COPY . /root/.dotfiles

ENV PATH="$PATH:/root/.local/bin"

RUN { echo test; echo a; echo b; } | ./bin/bootstrap.sh core

CMD ["sh"]
