ARG JENKINS_IMAGE=docker.io/jenkins/jenkins:2.452.1-jdk17
ARG PLUGINS='kubernetes:4231.vb_a_6b_8936497d workflow-aggregator:596.v8c21c963d92d git:5.2.2 configuration-as-code:1807.v0175eda_00a_20'

FROM $JENKINS_IMAGE
ARG PLUGINS
# Install plugins, then delete plugin cache (20MB+, that need to be updated at runtime anyway) and temp files
RUN jenkins-plugin-cli --verbose --plugins "$PLUGINS" \
    && rm -r /var/jenkins_home/.cache && rm -r /tmp/*
