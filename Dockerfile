ARG JENKINS_IMAGE=jenkins/jenkins:2.401.3-jdk11
ARG PLUGINS='kubernetes:3937.vd7b_82db_e347b_ workflow-aggregator:596.v8c21c963d92d git:5.1.0 configuration-as-code:1647.ve39ca_b_829b_42'

FROM $JENKINS_IMAGE
ARG PLUGINS
# Install plugins, then delete plugin cache (20MB+, that need to be updated at runtime anyway) and temp files
RUN jenkins-plugin-cli --verbose --latest=false --plugins "$PLUGINS" \
    && rm -r /var/jenkins_home/.cache && rm -r /tmp/*
