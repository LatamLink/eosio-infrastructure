FROM ubuntu:18.04
#TODO, proveer nosotros las imagenes

ARG eosio_version=v2.0.7
ARG deb_file=eosio_2.0.7-1-ubuntu-18.04_amd64.deb

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get -y install vim wget libcurl3-gnutls libusb-1.0-0 libicu60\
                && rm -rf /var/lib/apt/lists/*

RUN wget --quiet https://github.com/EOSIO/eos/releases/download/${eosio_version}/${deb_file}
RUN apt-get install ./${deb_file}

