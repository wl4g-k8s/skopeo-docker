# A Docker image for [containers/skopeo](https://github.com/containers/skopeo) based on alpine.

> [skopeo] is a command line utility that performs various operations on container images and image repositories.

## Building

```bash
docker build -t skopeo:1.8.0 .

## for example push to docker registries:
#docker tag skopeo:1.8.0 docker.io/wl4g/skopeo:1.8.0
#docker login
#docker push docker.io/wl4g/skopeo:1.8.0
```

## Usages

- Docker

```bash
docker run --rm \
-v $PWD/example/sync.yml:/sync.yml \
docker.io/wl4g/skopeo:1.8.0 \
/usr/bin/skopeo sync --src yaml --dest docker /sync.yml mirror.registry.privaterepo.com/public

## Or inside a wall use:
docker run --rm \
-v $PWD/example/sync.yml:/sync.yml \
registry.cn-shenzhen.aliyuncs.com/wl4g-k8s/skopeo:1.8.0 \
/usr/bin/skopeo sync --src yaml --dest docker /sync.yml mirror.registry.privaterepo.com/public
```

- Containerd

```bash
ctr i pull docker.io/wl4g/skopeo:1.8.0

ctr run --rm \
--mount=type=bind,src=$PWD/example/sync.yml,dst=/sync.yml,options=rbind:ro \
docker.io/wl4g/skopeo:1.8.0 skopeo1 \
/usr/bin/skopeo sync --src yaml --dest docker /sync.yml mirror.registry.privaterepo.com/public

## Or inside a wall use:
ctr i pull registry.cn-shenzhen.aliyuncs.com/wl4g-k8s/skopeo:1.8.0

ctr run --rm \
--mount=type=bind,src=$PWD/example/sync.yml,dst=/sync.yml,options=rbind:ro \
registry.cn-shenzhen.aliyuncs.com/wl4g-k8s/skopeo:1.8.0 skopeo1 \
/usr/bin/skopeo sync --src yaml --dest docker /sync.yml mirror.registry.privaterepo.com/public
```

