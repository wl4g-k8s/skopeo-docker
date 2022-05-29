# A Docker image for [containers/skopeo](https://github.com/containers/skopeo) and [wl4g-k8s/skopeo](https://github.com/wl4g-k8s/skopeo) based on alpine

> [skopeo] is a command line utility that performs various operations on container images and image repositories.

## 1. Building

- 1.1 build from [containers/skopeo](https://github.com/containers/skopeo)  (Only official standard features)

```bash
cd containers_skopeo
docker build -t skopeo:1.8.0 .
```

- 1.2 (Recommends) build from [wl4g-k8s/skopeo](https://github.com/wl4g-k8s/skopeo)  (a fork, contains various enhancements such as support for `--scope-level`)

```bash
cd wl4g-k8s_skopeo
git clone git@github.com:wl4g-k8s/skopeo.git
cd skopeo
git checkout ref-1.8.0

## build static binary. see:https://github.com/containers/skopeo/blob/v1.8.0/install.md#building-a-static-binary
docker run -v $PWD:/src -w /src -e CGO_ENABLED=0 golang make BUILDTAGS=containers_image_openpgp GO_DYN_FLAGS=

## build to mini image.
cd ..
docker build -t skopeo:1.8.0 .
```

- 1.3 Push to public registries

```bash
## for example push to docker registries:
docker tag skopeo:1.8.0 docker.io/wl4g/skopeo:1.8.0
docker login
docker push docker.io/wl4g/skopeo:1.8.0
```

## 2. Usages

- 2.1 Docker

```bash
docker run --rm \
--name skopeo1 \
-v $PWD/example/sync.yml:/sync.yml \
docker.io/wl4g/skopeo:1.8.0 \
/usr/bin/skopeo --debug sync --src yaml --dest docker /sync.yml --dest-creds=myuser1:123456 --scoped=true mirror.registry.privaterepo.com/public

## Or inside a wall use:
docker run --rm \
--name skopeo1
-v $PWD/example/sync.yml:/sync.yml \
registry.cn-shenzhen.aliyuncs.com/wl4g-k8s/skopeo:1.8.0 \
/usr/bin/skopeo --debug sync --src yaml --dest docker /sync.yml --dest-creds=myuser1:123456 --scoped=true mirror.registry.privaterepo.com/public
```

- 2.2 Containerd

```bash
ctr i pull docker.io/wl4g/skopeo:1.8.0

ctr run --rm \
--mount=type=bind,src=$PWD/example/sync.yml,dst=/sync.yml,options=rbind:ro \
docker.io/wl4g/skopeo:1.8.0 skopeo1 \
/usr/bin/skopeo --debug sync --src yaml --dest docker /sync.yml --dest-creds=myuser1:123456 --scoped=true mirror.registry.privaterepo.com/public

## Or inside a wall use:
ctr i pull registry.cn-shenzhen.aliyuncs.com/wl4g-k8s/skopeo:1.8.0

ctr run --rm \
--mount=type=bind,src=$PWD/example/sync.yml,dst=/sync.yml,options=rbind:ro \
registry.cn-shenzhen.aliyuncs.com/wl4g-k8s/skopeo:1.8.0 skopeo1 \
/usr/bin/skopeo --debug sync --src yaml --dest docker /sync.yml --dest-creds=myuser1:123456 --scoped=true mirror.registry.privaterepo.com/public
```

- **Notice1:** If the source or destination repository requires authentication, add the credentials parameter: `--src-creds/--dest-creds`, or login before that, e.g. `docker login mirror.registry.privaterepo.com`, No need to set when public repositories allow anonymous access.

- **Notice2:** By default, if `--src-tls-verify / --dest-tls-verify` is not specified, certificate checking will be enabled. It is recommended to use real tls deployment. the scope of this paper).

- **Notice3:** It is recommended to set `--scoped=true`, the default is false, otherwise the mirror path in the source repository will be lost after synchronization to the target. source see: [github.com/containers/skopeo/blob/v1.8.0/cmd/skopeo/sync.go#L623](https://github.com/containers/skopeo/blob/v1.8.0/cmd/skopeo/sync.go#L623)

- **Tip1:** Usually the skopeo process may be running on the privaterepo server, you can resolve `mirror.registry.privaterepo.com` to `127.0.0.1` to speed up writing.

## 3. FAQ

- If an error occurs: `Requesting bearer token: invalid status code from registry 403 (Forbidden)`, the previous authentication information may be invalid or expired, and you need to log in again. 
