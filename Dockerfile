ARG JENKINS_IMAGE=jenkins/jenkins:2.426.2-jdk17
ARG PLUGINS='kubernetes:4174.v4230d0ccd951 workflow-aggregator:596.v8c21c963d92d git:5.1.0 configuration-as-code:1670.v564dc8b_982d0'

FROM $JENKINS_IMAGE
ARG PLUGINS
# Install plugins, then delete plugin cache (20MB+, that need to be updated at runtime anyway) and temp files
RUN jenkins-plugin-cli --verbose --latest=false --plugins "$PLUGINS" \
    && rm -r /var/jenkins_home/.cache && rm -r /tmp/*
