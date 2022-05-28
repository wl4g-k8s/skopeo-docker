A Docker image for [containers/skopeo](https://github.com/containers/skopeo) based on alpine.

> [skopeo] is a command line utility that performs various operations on container images and image repositories.

- Building

```bash
docker build -t skopeo:1.8.0 .

## for example push to registries:
#docker tag skopeo:1.8.0 docker.io/wl4g/skopeo:1.8.0
#docker login
#docker push docker.io/wl4g/skopeo:1.8.0
```

- Usage

```bash
docker run --rm docker.io/wl4g/skopeo:1.8.0 skopeo --help

## Or, inside a wall use:
docker run --rm registry.cn-shenzhen.aliyuncs.com/wl4g-k8s/skopeo:1.8.0 skopeo --help
```

