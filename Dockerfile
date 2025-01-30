ARG JENKINS_IMAGE=docker.io/jenkins/jenkins:2.479.3-jdk17
ARG PLUGINS='kubernetes:4306.vc91e951ea_eb_d workflow-aggregator:600.vb_57cdd26fdd7 git:5.7.0 configuration-as-code:1929.v036b_5a_e1f123'

FROM $JENKINS_IMAGE
ARG PLUGINS
# Install plugins, then delete plugin cache (20MB+, that need to be updated at runtime anyway) and temp files
RUN jenkins-plugin-cli --verbose --plugins "$PLUGINS" \
    && rm -r /var/jenkins_home/.cache && rm -r /tmp/*
