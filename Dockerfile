ARG JENKINS_IMAGE=docker.io/jenkins/jenkins:2.452.3-jdk17
ARG PLUGINS='kubernetes:4253.v7700d91739e5 workflow-aggregator:600.vb_57cdd26fdd7 git:5.2.2 configuration-as-code:1836.vccda_4a_122a_a_e'

FROM $JENKINS_IMAGE
ARG PLUGINS
# Install plugins, then delete plugin cache (20MB+, that need to be updated at runtime anyway) and temp files
RUN jenkins-plugin-cli --verbose --plugins "$PLUGINS" \
    && rm -r /var/jenkins_home/.cache && rm -r /tmp/*
