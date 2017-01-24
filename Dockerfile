FROM heroku/cedar:14
MAINTAINER Jason Cox <jason.cox@panoply.fm>

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev python python-pip
RUN pip install awscli

RUN mkdir /app
RUN addgroup --quiet --gid 2000 slug && \
    useradd slug --uid=2000 --gid=2000 --home-dir /app --no-create-home \
        --shell /bin/bash

WORKDIR /app

ADD ./runner /runner
RUN chmod +x /runner/init
RUN chown slug:slug /app /runner/init

USER slug
ENV HOME /app
ENTRYPOINT ["/runner/init"]

ONBUILD RUN mkdir -p /app
ONBUILD WORKDIR /app
ONBUILD ADD slug.tgz /app