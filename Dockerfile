FROM hihats/awscli:alpine

RUN apk --update add wget

COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
