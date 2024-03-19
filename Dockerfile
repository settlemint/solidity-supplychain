FROM node:20.11.1-bookworm as build

ENV FOUNDRY_DIR /usr/local
RUN curl -L https://foundry.paradigm.xyz | bash && \
  /usr/local/bin/foundryup

WORKDIR /

RUN git config --global user.email "hello@settlemint.com" && \
  git config --global user.name "SettleMint" && \
  forge init usecase --template settlemint/solidity-supplychain && \
  cd usecase && \
  forge build

RUN cd usecase/subgraph && \
  npm install

USER root

FROM busybox

COPY --from=build /usecase /usecase
COPY --from=build /root/.svm /usecase-svm
