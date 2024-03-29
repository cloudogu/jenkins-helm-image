#!/bin/bash

main() {

    checkForCommands curl
    checkForCommands jq

    if [[ -z "$1" ]]; then
        helmRelease=$(getLatestHelmRelease)
    else
        helmRelease=$1
    fi
    
    plugins=$(getPlugins ${helmRelease})
    
    imageVersion=$(getImageVersion ${helmRelease})

    if [[ -z "$2" ]]; then
        cloudoguRelease=$(getLatestCloudoguHelmRelease)
    else
        cloudoguRelease=$2
    fi

    echo "triggerNewRelease=$(updateDockerfileOnNewRelease); helmRelease=${helmRelease}"
}

# get image version from helm chart
function getImageVersion() {
    local helmRelease="$1"
    
    curl -s \
      "https://raw.githubusercontent.com/jenkinsci/helm-charts/jenkins-${helmRelease}/charts/jenkins/Chart.yaml" \
      | grep 'image: docker.io/jenkins/jenkins' | awk {'print $2'}
}

function getPlugins() {
    local helmRelease="$1"
    local valuesYaml=$(mktemp --suffix values.yaml)
    
    curl -s "https://raw.githubusercontent.com/jenkinsci/helm-charts/jenkins-${helmRelease}/charts/jenkins/values.yaml" \
      -o ${valuesYaml}
    parseYaml $(echo ${valuesYaml})
}

# function to parse the values.yaml and get a list of "controller install plugins"
function parseYaml {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|,$s\]$s\$|]|" \
        -e ":1;s|^\($s\)\($w\)$s:$s\[$s\(.*\)$s,$s\(.*\)$s\]|\1\2: [\3]\n\1  - \4|;t1" \
        -e "s|^\($s\)\($w\)$s:$s\[$s\(.*\)$s\]|\1\2:\n\1  - \3|;p" $1 | \
   sed -ne "s|,$s}$s\$|}|" \
        -e ":1;s|^\($s\)-$s{$s\(.*\)$s,$s\($w\)$s:$s\(.*\)$s}|\1- {\2}\n\1  \3: \4|;t1" \
        -e    "s|^\($s\)-$s{$s\(.*\)$s}|\1-\n\1  \2|;p" | \
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)-$s[\"']\(.*\)[\"']$s\$|\1$fs$fs\2|p" \
        -e "s|^\($s\)-$s\(.*\)$s\$|\1$fs$fs\2|p" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p" | \
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]; idx[i]=0}}
      if(length($2)== 0){  vname[indent]= ++idx[indent] };
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) { vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, vname[indent], $3);
      }
   }' | \
   grep "controller_installPlugins_" | \
   grep -oP '="\K[^"]+'
}

# get our latest build version
function getLatestCloudoguHelmRelease() {
    latestCloudoguRelease=$(curl -s https://api.github.com/repos/cloudogu/jenkins-helm-image/releases/latest | jq -r '.tag_name')
    echo "$latestCloudoguRelease"
}

# get latest helm release version
function getLatestHelmRelease() {
    latestHelmRelease=$(curl -s https://raw.githubusercontent.com/jenkinsci/helm-charts/main/charts/jenkins/Chart.yaml | grep 'version:' | awk {'print $2'})
    echo "$latestHelmRelease"
}

# compare both versions if remote is greater, then trigger newRelease
function checkForNewRelease() {
    newRelease=false

    helmMajorVersion=${helmRelease:0:1}
    cloudoguMajorVersion=${cloudoguRelease:0:1}

    # check if the fetched helm major version corresponds to our major version (greater or equal)
    if [[ $helmMajorVersion -ge $cloudoguMajorVersion ]]; then
        # check if the fetched helm version is newer than our version (3.3.4-1 not contains 3.3.4)
        if [[ ${cloudoguRelease} != *${helmRelease}* ]]; then
            newRelease=true
        fi
    fi
    echo "${newRelease}"
}

# change image file name in Dockerfile
function updateDockerfileOnNewRelease() {
    triggerNewRelease=false
    if [[ $(checkForNewRelease) == 'true' ]]; then
        # changing the helm version in the dockerfile
        sed -i "/ARG JENKINS_IMAGE=/c\ARG JENKINS_IMAGE=${imageVersion}" ./Dockerfile
        # change plugins in Dockerfile
        sed -i "/ARG PLUGINS=/c\ARG PLUGINS='$(echo $plugins)'" ./Dockerfile
        triggerNewRelease=true
    fi
    echo "$triggerNewRelease"
}

checkForCommands() {
  if ! command -v $1 &> /dev/null; then
      apt install -y "$1"
  fi
}

echo $(main $1 $2)
