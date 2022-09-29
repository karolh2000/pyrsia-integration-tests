# syntax=docker/dockerfile:1.4.1

FROM rust:1.62-buster AS node_with_build_service
WORKDIR /src
ENV RUST_BACKTRACE=1
ENV DEV_MODE=onapt
RUN apt-get update && apt-get install -y
RUN apt-get install build-essential libssl-dev cmake pkg-config jq openjdk-11-jdk maven -y
RUN git clone https://github.com/tiainen/pyrsia_build_pipeline_prototype.git
WORKDIR /src/pyrsia_build_pipeline_prototype
RUN PATH="$HOME/.cargo/bin:$PATH" RUST_LOG=debug cargo build
WORKDIR /src
COPY entrypoint_bootstrap.sh entrypoint_node.sh entrypoint_auth_node.sh ./
RUN chmod +x ./*.sh
#RUN git clone https://github.com/pyrsia/pyrsia.git
RUN git clone -b 1083-add-authorized-node https://github.com/erwin1/pyrsia.git
WORKDIR /src/pyrsia
RUN PATH="$HOME/.cargo/bin:$PATH" RUST_LOG=debug cargo build --package=pyrsia_node
