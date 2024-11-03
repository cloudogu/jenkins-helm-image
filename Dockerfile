ARG JENKINS_IMAGE=docker.io/jenkins/jenkins:2.479.1-jdk17
ARG PLUGINS='kubernetes:4295.v7fa_01b_309c95 workflow-aggregator:600.vb_57cdd26fdd7 git:5.6.0 configuration-as-code:1887.v9e47623cb_043'

FROM $JENKINS_IMAGE
ARG PLUGINS
# Install plugins, then delete plugin cache (20MB+, that need to be updated at runtime anyway) and temp files
RUN jenkins-plugin-cli --verbose --plugins "$PLUGINS" \
    && rm -r /var/jenkins_home/.cache && rm -r /tmp/*
