ARG JENKINS_IMAGE=docker.io/jenkins/jenkins:2.541.1-jdk21
ARG PLUGINS='kubernetes:4423.vb_59f230b_ce53 workflow-aggregator:608.v67378e9d3db_1 git:5.10.0 configuration-as-code:2037.v8e5349845172'

FROM $JENKINS_IMAGE
ARG PLUGINS
# Install plugins, then delete plugin cache (20MB+, that need to be updated at runtime anyway) and temp files
RUN jenkins-plugin-cli --verbose --plugins "$PLUGINS" \
    && rm -r /var/jenkins_home/.cache && rm -r /tmp/*
