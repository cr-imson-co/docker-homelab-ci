#
# homelab CI image
#   used to QA the homelab repository
#

ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION}-stretch

ARG RUBOCOP_VERSION

RUN gem install rubocop -v ${RUBOCOP_VERSION}

# install docker CLI
ARG DOCKER_CLI_VERSION==5:19.03.8~3-0~debian-stretch
ARG DOCKER_COMPOSE_VERSION=1.25.4
ARG DOCKER_COMPOSE_CHECKSUM=542e93b1d5106d2769b325f60ba9a0ba087bb96e30dc2c1cb026f0cb642e9aed
RUN set -x \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    wget \
    gnupg2 \
    software-properties-common \
  && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
  && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    docker-ce-cli${DOCKER_CLI_VERSION} \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
  && (echo "${DOCKER_COMPOSE_CHECKSUM} /usr/local/bin/docker-compose" | sha256sum -c -) \
  && chmod +x /usr/local/bin/docker-compose
