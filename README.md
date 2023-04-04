# jenkins-helm-image

Build a Jenkins Image bundled with only neccessary needed plugins.

This repository has gitactions


##### Background
Jenkins comes in the default installation with a few plugins. This plugings have dependencies, later in a large deployment we focused some inconsistencies and problems with versions that are installed. Therefor we build the image with preinstalled plugins from the helm chart. 
