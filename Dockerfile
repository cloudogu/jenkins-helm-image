ARG JENKINS_IMAGE=docker.io/jenkins/jenkins:2.504.1-jdk21
ARG PLUGINS='kubernetes:4334.v32b_f157682d6 workflow-aggregator:608.v67378e9d3db_1 git:5.7.0 configuration-as-code:1963.v24e046127a_3f'

FROM $JENKINS_IMAGE
ARG PLUGINS
# Install plugins, then delete plugin cache (20MB+, that need to be updated at runtime anyway) and temp files
RUN jenkins-plugin-cli --verbose --plugins "$PLUGINS" \
    && rm -r /var/jenkins_home/.cache && rm -r /tmp/*
