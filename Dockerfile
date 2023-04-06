ARG PLUGINS=kubernetes:3734.v562b_b_a_627ea_c workflow-aggregator:590.v6a_d052e5a_a_b_5 git:4.13.0 configuration-as-code:1569.vb_72405b_80249
FROM jenkins/jenkins:2.387.2-jdk11
RUN jenkins-plugin-cli --plugins $PLUGINS
