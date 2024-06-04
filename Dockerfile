FROM node:20.13.1-bookworm as build

ENV FOUNDRY_DIR /usr/local
RUN curl -L https://foundry.paradigm.xyz | bash && \
  /usr/local/bin/foundryup

WORKDIR /

COPY . /usecase

WORKDIR /usecase

USER root

RUN npm install
RUN forge build
RUN npx hardhat compile

FROM cgr.dev/chainguard/busybox:latest

COPY --from=build /usecase /usecase
COPY --from=build /root/.svm /usecase-svm
COPY --from=build /root/.cache /usecase-cache