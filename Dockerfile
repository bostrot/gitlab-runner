FROM arm32v7/ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
ARG DOCKER_MACHINE_VERSION=0.16.2

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y ca-certificates wget apt-transport-https vim nano tzdata curl dumb-init gnupg2 git && \
    dumb-init --version

RUN wget -q https://github.com/docker/machine/releases/download/v${DOCKER_MACHINE_VERSION}/docker-machine-Linux-armhf -O /usr/bin/docker-machine && \
    chmod +x /usr/bin/docker-machine && \
    docker-machine --version

RUN curl -s https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | bash && \ 
    apt-get install gitlab-runner -y && \
    rm -rf /var/lib/apt/lists/* && \
    gitlab-runner --version && \
    mkdir -p /etc/gitlab-runner/certs && \
    chmod -R 700 /etc/gitlab-runner

COPY entrypoint /
RUN chmod +x /entrypoint

VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]
ENTRYPOINT ["/usr/bin/dumb-init", "/entrypoint"]
CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]
