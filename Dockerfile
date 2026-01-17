ARG JENKINS_IMAGE=docker.io/jenkins/jenkins:2.528.3-jdk21
ARG PLUGINS='kubernetes:4416.v2ea_b_5372da_a_e workflow-aggregator:608.v67378e9d3db_1 git:5.8.1 configuration-as-code:2031.veb_a_fdda_b_3ffd'

FROM $JENKINS_IMAGE
ARG PLUGINS
# Install plugins, then delete plugin cache (20MB+, that need to be updated at runtime anyway) and temp files
RUN jenkins-plugin-cli --verbose --plugins "$PLUGINS" \
    && rm -r /var/jenkins_home/.cache && rm -r /tmp/*
