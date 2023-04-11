ARG PLUGINS=kubernetes:3900.va_dce992317b_4
FROM jenkins/jenkins:2.387.2-jdk8
RUN jenkins-plugin-cli --plugins $PLUGINS
