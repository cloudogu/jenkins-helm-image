ARG JENKINS_IMAGE=docker.io/jenkins/jenkins:2.528.3-jdk21
ARG PLUGINS='kubernetes:4398.vb_b_33d9e7fe23 workflow-aggregator:608.v67378e9d3db_1 git:5.8.1 configuration-as-code:2006.v001a_2ca_6b_574'

FROM $JENKINS_IMAGE
ARG PLUGINS
# Install plugins, then delete plugin cache (20MB+, that need to be updated at runtime anyway) and temp files
RUN jenkins-plugin-cli --verbose --plugins "$PLUGINS" \
    && rm -r /var/jenkins_home/.cache && rm -r /tmp/*
