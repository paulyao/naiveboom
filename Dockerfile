from node:20.1-alpine
MAINTAINER paulyao

RUN apk update && \
	apk add --no-cache --update git redis && \
	git clone https://github.com/paulyao/naiveboom.git && \
	cd naiveboom/ && \
	apk del git && \
	rm /naiveboom/.git* -rf && \
	sed -i "s@# ./redis-server /path/to/redis.conf@daemonize yes@g" /etc/redis.conf && \
	npm install 

WORKDIR /naiveboom

EXPOSE 3000
CMD redis-server /etc/redis.conf && node /naiveboom/run.js
