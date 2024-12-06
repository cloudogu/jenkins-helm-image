ARG JENKINS_IMAGE=docker.io/jenkins/jenkins:2.479.2-jdk17
ARG PLUGINS='kubernetes:4302.va_756e4b_67715 workflow-aggregator:600.vb_57cdd26fdd7 git:5.6.0 configuration-as-code:1903.v004d55388f30'

FROM $JENKINS_IMAGE
ARG PLUGINS
# Install plugins, then delete plugin cache (20MB+, that need to be updated at runtime anyway) and temp files
RUN jenkins-plugin-cli --verbose --plugins "$PLUGINS" \
    && rm -r /var/jenkins_home/.cache && rm -r /tmp/*
