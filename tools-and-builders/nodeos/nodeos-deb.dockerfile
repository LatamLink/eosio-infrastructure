FROM ubuntu:18.04

ARG eosio_version
ARG deb_file

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get -y install vim wget libcurl3-gnutls libusb-1.0-0 libicu60\
                && rm -rf /var/lib/apt/lists/*

RUN wget --quiet https://github.com/EOSIO/eos/releases/download/${eosio_version}/${deb_file}
RUN apt-get install ./${deb_file}

