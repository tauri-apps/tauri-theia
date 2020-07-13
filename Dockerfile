FROM ubuntu:20.04

ARG BRANCH=dev
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -qy git npm cargo squashfs-tools wget libfuse2 pkg-config libssl-dev libcairo2-dev libwebkit2gtk-4.0-dev
ADD tauri-appimage-bundle-under-docker.patch /tauri-appimage-bundle-under-docker.patch
RUN git clone https://github.com/tauri-apps/tauri -b dev && (cd tauri && patch -p1 < /tauri-appimage-bundle-under-docker.patch) && CARGO_INSTALL_ROOT=/usr/local cargo install tauri-bundler --path tauri/cli/tauri-bundler
WORKDIR /build
RUN git clone -b $BRANCH https://github.com/tauri-apps/tauri-theia
WORKDIR /build/tauri-theia
RUN npm install -g yarn
RUN yarn install
RUN yarn theia:package
RUN yarn tauri build
