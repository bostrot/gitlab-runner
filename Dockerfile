FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
#ENV registrationToken TOKEN
#ENV url https://gitlab.com/
#ENV executor docker
#ENV description "GitLab Runner on ARM"
#ENV dockerImage "docker:17.12"
#ENV tagList "docker,arm"

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y ca-certificates wget apt-transport-https vim nano tzdata curl dumb-init gnupg2 && \
    rm -rf /var/lib/apt/lists/* && \
    curl -s https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | bash && \
    apt-get install gitlab-runner -y && \
    gitlab-runner --version

COPY entrypoint /
RUN chmod +x /entrypoint

STOPSIGNAL SIGQUIT
VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]
ENTRYPOINT ["/usr/bin/dumb-init", "/entrypoint"]
CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]
