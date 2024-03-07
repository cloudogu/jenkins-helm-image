# jenkins-helm-image

An OCI image containing Jenkins bundled with the basic plugins needed during startup of 
[Jenkins Helm Chart](https://artifacthub.io/packages/helm/jenkinsci/jenkins). This avoids non-deterministic failures due
to (transitive) plugin dependency mismatches and speeds up startup.

## Usage

In your `values.yaml`:  Use the helm chart version as `tag`, e.g. 

```yaml
controller:
  image:
    registry: ghcr.io
    repository: cloudogu/jenkins-helm
    tag: "5.0.17"
  installPlugins: false
```

Note that there are also immutable version with a suffix such aus `-1`, corresponding to the [releases](https://github.com/cloudogu/jenkins-helm-image/releases/) in this repo.  
These reflect the rare occasion when we change the build logic while the upstream helm chart version remains the same.  
For easier maintenance we recommend using the image tag without suffix.  
This way the helm chart's version and the image's version are exactly the same.  
This makes it easier to install and maintain, e.g. like so:

```bash
VERSION=5.0.18
helm upgrade -i jenkins --version $VERSION \
    --set controller.image.registry=ghcr.io \
    --set controller.image.repository=cloudogu/jenkins-helm \
    --set controller.image.tag="$VERSION" \
    --set controller.installPlugins=false \
  jenkins/jenkins
```

Of course, you can also try this image without Kubernetes.

```bash
docker run --rm -p 8080:8080 ghcr.io/cloudogu/jenkins-helm:5.0.18
```

## Background
The helm chart requires a number of plugins
[that are usually installed at runtime, on startup](https://github.com/jenkinsci/helm-charts/blob/jenkins-4.3.20/charts/jenkins/values.yaml#L243-L247).
While the versions of the plugins itself are pinned, their dependencies are not. 
This regularly leads to constellations, where the transitive plugins might not work with the Jenkins version or
incompatibilities between plugins.
As these installation are done at startup this might lead to Jenkins failing to start. From one day to another. 
Very non-deterministic.

That is why the Chart docs recommend [using a custom image](https://github.com/jenkinsci/helm-charts/blob/main/charts/jenkins/README.md#consider-using-a-custom-image).
This is still true, but if you just want to try out Jenkins Helm Chart or run it locally or have some of other form of 
plugin installation this image is for you.

We built it for our [GitOps Playground](https://github.com/cloudogu/gitops-playground).
There, we support different modes of operation, where Jenkins is not necessarily deployed via the Helm Chart. 
To support external Jenkins instances, we install plugins at runtime via HTTP. 
So for Jenkins in Helm we just want Jenkins to start with basic plugins. Reliably.
