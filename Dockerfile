ARG JENKINS_IMAGE=docker.io/jenkins/jenkins:2.492.1-jdk17
ARG PLUGINS='kubernetes:4313.va_9b_4fe2a_0e34 workflow-aggregator:600.vb_57cdd26fdd7 git:5.7.0 configuration-as-code:1932.v75cb_b_f1b_698d'

FROM $JENKINS_IMAGE
ARG PLUGINS
# Install plugins, then delete plugin cache (20MB+, that need to be updated at runtime anyway) and temp files
RUN jenkins-plugin-cli --verbose --plugins "$PLUGINS" \
    && rm -r /var/jenkins_home/.cache && rm -r /tmp/*
