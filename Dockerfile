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
# File version : 2.0
# Modified by  : Mr. Mrunal M. Nachankar
# Modified on  : Fri Oct  5 02:05:28 IST 2018
# v2.0 changes : 1. changed lein repo becuase of error (Ref - https://github.com/pandeiro/docker-lein/blob/master/Dockerfile)
#                1.1 on terminal "WARNING: Ignoring https://apkproxy.herokuapp.com/sgerrand/alpine-pkg-leiningen/x86_64/APKINDEX.tar.gz: IO ERROR"
#                1.2 on web url "https://apkproxy.herokuapp.com/sgerrand/alpine-pkg-leiningen/x86_64/APKINDEX.tar.gz:" - "GET https://api.github.com/repos/sgerrand/alpine-pkg-leiningen/releases/latest: 403 API rate limit exceeded for 54.161.227.147. (But here's the good news: Authenticated requests get a higher rate limit. Check out the documentation for more details.); rate reset in 9m11.102348936s"
# File version : 3.0
# Modified by  : Mr. Mrunal M. Nachankar
# Modified on  : Fri Oct  5 23:56:57 IST 2018
# v3.0 changes : 1. Removed unwanted blank line
#                2. Removed unnecessary cd command
#                3. As we just need to download the dependenices, I am usng "lein deps" instead of "lein repl"
#                3. For using custom config(gconf.clj), Trying to mount it via volume (in docker-compose.yml). If file is present in required directory, just replace it with actual file (in Dockerfile). Once the changes are done, restart the container to make it effective."
#--------------------------------------------------------------------#

FROM clojure:tools-deps-1.9.0.394-alpine

MAINTAINER mrunal4888@gmail.com

ENV LEIN_REPO=https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
ENV LEIN_ROOT=true
ENV GNOWDB_REPO=https://github.com/mrunal4/gnowdb

RUN mkdir -p /usr/src/app   \
    &&   cd /usr/src/app   \
    &&   wget -q -O /usr/bin/lein ${LEIN_REPO}   \
    &&   chmod +x /usr/bin/lein   \
    &&   apk add --no-cache  git   \
    &&   git clone ${GNOWDB_REPO}   \
    &&   ls -ltr gnowdb   \
    &&   cd gnowdb   \
    &&   lein deps

EXPOSE 3000

WORKDIR /usr/src/app/gnowdb

ENTRYPOINT if [ -f /root/gnowdb_settings/gconf.clj ]; then cp -av /root/gnowdb_settings/gconf.clj /usr/src/app/gnowdb/src/gnowdb/neo4j else echo "File not found" fi   \
    &&   cd /usr/src/app/gnowdb   \
    &&   lein ring server