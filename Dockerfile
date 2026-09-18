ARG JENKINS_IMAGE=docker.io/jenkins/jenkins:2.568.3-jdk21
ARG PLUGINS='kubernetes:4557.ve746270f672f workflow-aggregator:608.v67378e9d3db_1 git:5.10.1 configuration-as-code:2121.v86fe99d4b_b_a_b_'

FROM $JENKINS_IMAGE
ARG PLUGINS
# Install plugins, then delete plugin cache (20MB+, that need to be updated at runtime anyway) and temp files
RUN jenkins-plugin-cli --verbose --plugins "$PLUGINS" \
    && rm -r /var/jenkins_home/.cache && rm -r /tmp/*
