FROM hihats/awscli:alpine

RUN apk --update add --no-cache --update-cache wget ca-certificates openssl libxml2-utils \
    && update-ca-certificates \
    && rm -rf /var/cache/apk/*

COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
