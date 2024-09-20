ARG JENKINS_IMAGE=docker.io/jenkins/jenkins:2.462.2-jdk17
ARG PLUGINS='kubernetes:4288.v1719f9d0c854 workflow-aggregator:600.vb_57cdd26fdd7 git:5.5.0 configuration-as-code:1850.va_a_8c31d3158b_'

FROM $JENKINS_IMAGE
ARG PLUGINS
# Install plugins, then delete plugin cache (20MB+, that need to be updated at runtime anyway) and temp files
RUN jenkins-plugin-cli --verbose --plugins "$PLUGINS" \
    && rm -r /var/jenkins_home/.cache && rm -r /tmp/*
