FROM node:22

RUN apt-get update && \
    apt-get install -y git curl
    
WORKDIR /workspace  

RUN git clone https://github.com/imelon2/simple-paymaster-contract ./

RUN curl -L https://foundry.paradigm.xyz | bash
ENV PATH="${PATH}:/root/.foundry/bin"
RUN foundryup

RUN npm install

ENTRYPOINT ["npm","run"]