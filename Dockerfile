FROM ubuntu:20.04

ARG BRANCH=dev
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -qy git npm cargo
RUN CARGO_INSTALL_ROOT=/usr/local cargo install tauri-bundler
WORKDIR /build
RUN git clone -b $BRANCH https://github.com/tauri-apps/tauri-theia
WORKDIR /build/tauri-theia
RUN npm install -g yarn
RUN yarn install
RUN yarn theia:package
RUN yarn tauri build
