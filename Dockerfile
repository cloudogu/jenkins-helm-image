ARG JENKINS_IMAGE=docker.io/jenkins/jenkins:2.568.2-jdk21
ARG PLUGINS='kubernetes:4540.v612369217f87 workflow-aggregator:608.v67378e9d3db_1 git:5.10.1 configuration-as-code:2115.vf6de120eef70'

FROM $JENKINS_IMAGE
ARG PLUGINS
# Install plugins, then delete plugin cache (20MB+, that need to be updated at runtime anyway) and temp files
RUN jenkins-plugin-cli --verbose --plugins "$PLUGINS" \
    && rm -r /var/jenkins_home/.cache && rm -r /tmp/*
