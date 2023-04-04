#!/bin/bash

function getLatestCloudoguHelmRelease() {
    latestCloudoguRelease=$(curl -s https://api.github.com/repos/cloudogu/jenkins-base/releases/latest | jq -r '.tag_name')
    echo "$latestCloudoguRelease"
}

function getlatestHelmRelease() {
    latestHelmRelease=$(curl -s https://raw.githubusercontent.com/jenkinsci/helm-charts/main/charts/jenkins/Chart.yaml | grep 'version:' | awk {'print $2'})
    echo "$latestHelmRelease"
}

imageVersion=$(curl -s https://raw.githubusercontent.com/jenkinsci/helm-charts/main/charts/jenkins/Chart.yaml | grep 'image: jenkins/jenkins' | awk {'print $2'})

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

function updateDockerfileOnNewRelease() {
    triggerNewRelease=false
    if [[ $(checkForNewRelease) == 'true' ]]; then
        # changing the helm version in the dockerfile
        sed -i "/FROM/c\FROM ${imageVersion}" ./Dockerfile
        triggerNewRelease=true
    fi
    echo "$triggerNewRelease"
}

checkForCommands() {
    if ! command -v $1 &> /dev/null
then
    apt install -y "$1"
fi
}

run_main() {

    checkForCommands curl
    checkForCommands jq

    if [[ -z "$1" ]]; then
        helmRelease=$(getlatestHelmRelease)
    else
        helmRelease=$1
    fi

    if [[ -z "$2" ]]; then
        cloudoguRelease=$(getLatestCloudoguHelmRelease)
    else
        cloudoguRelease=$2
    fi

    echo "triggerNewRelease=$(updateDockerfileOnNewRelease); helmRelease=${helmRelease}"
}

echo $(run_main $1 $2)
