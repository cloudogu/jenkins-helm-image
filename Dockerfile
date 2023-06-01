ARG JENKINS_IMAGE=jenkins/jenkins:2.401.1-jdk11
ARG PLUGINS='kubernetes:3900.va_dce992317b_4 workflow-aggregator:596.v8c21c963d92d git:5.0.0 configuration-as-code:1625.v27444588cc3d'

FROM $JENKINS_IMAGE
ARG PLUGINS
# Install plugins, then delete plugin cache (20MB+, that need to be updated at runtime anyway) and temp files
RUN jenkins-plugin-cli --verbose --latest=false --plugins "$PLUGINS" \
    && rm -r /var/jenkins_home/.cache && rm -r /tmp/*
