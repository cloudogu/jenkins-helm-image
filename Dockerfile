ARG JENKINS_IMAGE=docker.io/jenkins/jenkins:2.568.1-jdk21
ARG PLUGINS='kubernetes:4538.v5b_ce7f35b_257 workflow-aggregator:608.v67378e9d3db_1 git:5.10.1 configuration-as-code:2103.vd6f93c3e714a_'

FROM $JENKINS_IMAGE
ARG PLUGINS
# Install plugins, then delete plugin cache (20MB+, that need to be updated at runtime anyway) and temp files
RUN jenkins-plugin-cli --verbose --plugins "$PLUGINS" \
    && rm -r /var/jenkins_home/.cache && rm -r /tmp/*
