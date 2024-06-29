ARG JENKINS_IMAGE=docker.io/jenkins/jenkins:2.452.2-jdk17
ARG PLUGINS='kubernetes:4248.vfa_9517757b_b_a_ workflow-aggregator:596.v8c21c963d92d git:5.2.2 configuration-as-code:1810.v9b_c30a_249a_4c'

FROM $JENKINS_IMAGE
ARG PLUGINS
# Install plugins, then delete plugin cache (20MB+, that need to be updated at runtime anyway) and temp files
RUN jenkins-plugin-cli --verbose --plugins "$PLUGINS" \
    && rm -r /var/jenkins_home/.cache && rm -r /tmp/*
