FROM node:6.10-alpine

WORKDIR /opt/codesign-util

ADD package.json /opt/codesign-util/
RUN npm install
ADD index.js /opt/codesign-util/

VOLUME /mnt/certs
VOLUME /mnt/binaries

ENTRYPOINT ["node", "index.js"]
