FROM node:22

RUN apt-get update && \
    apt-get install -y git
    
WORKDIR /workspace  

RUN git clone https://github.com/eth-infinitism/account-abstraction.git ./
RUN git checkout tags/v0.7.0

RUN yarn install

ENTRYPOINT ["yarn"]