FROM node:22

RUN apt-get update && \
    apt-get install -y git curl coreutils
    
WORKDIR /workspace  

RUN git clone https://github.com/imelon2/simple-paymaster-server.git ./

RUN yarn install

ENTRYPOINT ["yarn"]