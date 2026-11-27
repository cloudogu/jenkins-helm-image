ARG JENKINS_IMAGE=docker.io/jenkins/jenkins:2.580.3-jdk25
ARG PLUGINS='kubernetes:4560.vc25b_83890c34 workflow-aggregator:608.v67378e9d3db_1 git:5.11.0 configuration-as-code:2151.va_012b_08f3cc4'

FROM $JENKINS_IMAGE
ARG PLUGINS
# Install plugins, then delete plugin cache (20MB+, that need to be updated at runtime anyway) and temp files
RUN jenkins-plugin-cli --verbose --plugins "$PLUGINS" \
    && rm -r /var/jenkins_home/.cache && rm -r /tmp/*
