ARG JENKINS_IMAGE=
ARG PLUGINS='kubernetes:4186.v1d804571d5d4 workflow-aggregator:596.v8c21c963d92d git:5.2.1 configuration-as-code:1775.v810dc950b_514'

FROM $JENKINS_IMAGE
ARG PLUGINS
# Install plugins, then delete plugin cache (20MB+, that need to be updated at runtime anyway) and temp files
RUN jenkins-plugin-cli --verbose --latest=false --plugins "$PLUGINS" \
    && rm -r /var/jenkins_home/.cache && rm -r /tmp/*
