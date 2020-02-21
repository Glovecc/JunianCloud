FROM alpine:3.9
MAINTAINER FAN VINGA<fanalcest@gmail.com>

ADD . /app
WORKDIR /app
EXPOSE 80

ENV NAME=橘年图床  \
    DRIVER=json   \
    MYSQL_HOST=   \
    MYSQL_USER=   \
    MYSQL_PASSWD= \
    MYSQL_PORT=   \
    MAXSIZE=100

RUN sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories
    
RUN apk add --no-cache py3-pip py3-gevent libmagic   \
                                          gettext    \
                                          libintl && \
    cp  /usr/bin/envsubst  /usr/local/bin/        && \
    pip3 install --upgrade --no-cache-dir pip -i https://pypi.douban.com/simple  && \
    pip3 install --no-cache-dir -r requirements.* -i https://pypi.douban.com/simple && \
    apk del --purge gettext && mkdir -p uploads

CMD envsubst < configuration.sample > configuration.yaml && \
    python3 init.py && gunicorn  --reload -c gunicorn.conf index:app;