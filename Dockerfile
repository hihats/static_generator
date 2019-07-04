FROM hihats/awscli:alpine

RUN apk --update add  --no-cache --update-cache wget libxml2-utils && \
    rm -rf /var/cache/apk/*

COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
