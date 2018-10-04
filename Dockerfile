#--------------------------------------------------------------------#
# Dockerfile for creating gnowdb docker image  
# File name    : Dockerfile
# File version : 1.0
# Created by   : Mr. Mrunal M. Nachankar
# Created on   : Thu Oct  4 15:12:01 IST 2018
# Modified by  : None
# Modified on  : Not yet
# Description  : This file is used for creating gnowdb docker image.
# Important    : 1. It is based on clojure - 1.9.0.384 image (Exact base docker image- clojure:tools-deps-1.9.0.394-alpine). This image is based on alpine OS.
#                2. create "/usr/src/app" for using it as workplace
#                3. Install lein app /engine
#                4. Install git
#                5. git clone gnowdb directory
#                6. Check for existence of files after cloning
#                7. Trigger command : "lein repl". This will take time as it will download dependenices
#                8. Expose 3000 port to render api call outputs in web browser
#                9. Change the working directory as "/usr/src/app/gnowdb"
#                4. Start lein ring server
#--------------------------------------------------------------------#

FROM clojure:tools-deps-1.9.0.394-alpine

MAINTAINER mrunal4888@gmail.com

ENV LEIN_REPO=https://apkproxy.herokuapp.com/sgerrand/alpine-pkg-leiningen
ENV LEIN_VERSION=2.8.1-r0
ENV LEIN_ROOT=true
ENV GNOWDB_REPO=https://github.com/gnowledge/gnowdb


RUN mkdir -p /usr/src/app   \
    &&   cd /usr/src/app   \
    &&   wget -P /etc/apk/keys/ https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub   \
    &&   apk add --no-cache --repository=${LEIN_REPO} leiningen=${LEIN_VERSION}  git   \
    &&   cd /usr/src/app   \
    &&   git clone ${GNOWDB_REPO}   \
    &&   ls -ltr gnowdb   \
    &&   cd gnowdb   \
    &&   lein repl

EXPOSE 3000

WORKDIR /usr/src/app/gnowdb

ENTRYPOINT cd /usr/src/app/gnowdb   \
    &&   lein ring server