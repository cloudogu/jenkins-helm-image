ARG JENKINS_IMAGE=jenkins/jenkins:22
ARG PLUGINS=kubernetes:3900.va_dce992317b_4 workflow-aggregator:596.v8c21c963d92d git:5.0.0 configuration-as-code:1625.v27444588cc3d
FROM $JENKINS_IMAGE
RUN jenkins-plugin-cli --plugins $PLUGINS
