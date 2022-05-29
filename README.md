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
/usr/bin/skopeo --debug sync --src yaml --dest docker /sync.yml --dest-creds=myuser1:123456 mirror.registry.privaterepo.com/public

## Or inside a wall use:
docker run --rm \
-v $PWD/example/sync.yml:/sync.yml \
registry.cn-shenzhen.aliyuncs.com/wl4g-k8s/skopeo:1.8.0 \
/usr/bin/skopeo --debug sync --src yaml --dest docker /sync.yml --dest-creds=myuser1:123456 mirror.registry.privaterepo.com/public
```

- Containerd

```bash
ctr i pull docker.io/wl4g/skopeo:1.8.0

ctr run --rm \
--mount=type=bind,src=$PWD/example/sync.yml,dst=/sync.yml,options=rbind:ro \
docker.io/wl4g/skopeo:1.8.0 skopeo1 \
/usr/bin/skopeo --debug sync --src yaml --dest docker /sync.yml --dest-creds=myuser1:123456 mirror.registry.privaterepo.com/public

## Or inside a wall use:
ctr i pull registry.cn-shenzhen.aliyuncs.com/wl4g-k8s/skopeo:1.8.0

ctr run --rm \
--mount=type=bind,src=$PWD/example/sync.yml,dst=/sync.yml,options=rbind:ro \
registry.cn-shenzhen.aliyuncs.com/wl4g-k8s/skopeo:1.8.0 skopeo1 \
/usr/bin/skopeo --debug sync --src yaml --dest docker /sync.yml --dest-creds=myuser1:123456 mirror.registry.privaterepo.com/public
```

- **Note1:** If the source or destination repository requires authentication, add the credentials parameter: `--src-creds/--dest-creds`, or login before that, e.g. `docker login mirror.registry.privaterepo.com`, No need to set when public repositories allow anonymous access.

## FAQ

- If an error occurs: `Requesting bearer token: invalid status code from registry 403 (Forbidden)`, the previous authentication information may be invalid or expired, and you need to log in again. 


