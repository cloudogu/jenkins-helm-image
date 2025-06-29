ARG JENKINS_IMAGE=docker.io/jenkins/jenkins:2.504.3-jdk21
ARG PLUGINS='kubernetes:4356.vfa_556c21f086 workflow-aggregator:608.v67378e9d3db_1 git:5.7.0 configuration-as-code:1971.vf9280461ea_89'

FROM $JENKINS_IMAGE
ARG PLUGINS
# Install plugins, then delete plugin cache (20MB+, that need to be updated at runtime anyway) and temp files
RUN jenkins-plugin-cli --verbose --plugins "$PLUGINS" \
    && rm -r /var/jenkins_home/.cache && rm -r /tmp/*
