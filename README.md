# A Docker image for [containers/skopeo](https://github.com/containers/skopeo) and [wl4g-k8s/skopeo](https://github.com/wl4g-k8s/skopeo) based on alpine

> [skopeo] is a command line utility that performs various operations on container images and image repositories.

## 1. Usages

- 1.1 Docker

```bash
export REPO_URL="docker.io/wl4g/skopeo:1.8.0"
#export REPO_URL="registry.cn-shenzhen.aliyuncs.com/wl4g-k8s/skopeo:1.8.0"

docker run --rm \
--name skopeo1 \
-v $PWD/example/sync.yml:/sync.yml \
$REPO_URL \
/bin/skopeo --debug sync --src yaml --dest docker /sync.yml --dest-creds='myuser1:123456' --scoped=true --scoped-level=2 registry.privaterepo.com/namespace
```

- 1.2 Containerd

```bash
export REPO_URL="docker.io/wl4g/skopeo:1.8.0"
#export REPO_URL="registry.cn-shenzhen.aliyuncs.com/wl4g-k8s/skopeo:1.8.0"

ctr i pull docker.io/wl4g/skopeo:1.8.0

ctr run --rm \
--mount=type=bind,src=$PWD/example/sync.yml,dst=/sync.yml,options=rbind:ro \
$REPO_URL \
/bin/skopeo --debug sync --src yaml --dest docker /sync.yml --dest-creds='myuser1:123456' --scoped=true --scoped-level=2 registry.privaterepo.com/namespace
```

- ***Tip:***

  - If the source or destination repository requires authentication, add the credentials parameter: `--src-creds/--dest-creds`, or login before that, e.g. `docker login mirror.registry.privaterepo.com`, No need to set when public repositories allow anonymous access.

  - By default, if `--src-tls-verify` and `--dest-tls-verify` is not specified, certificate checking will be enabled. It is recommended to use real tls deployment. the scope of this paper).

- ***Importants:*** If you need to synchronize multiple repositories in batches, and you need to change the path of the synchronization mirror for each group of repositories (source repository -> destination repository), for example: `docker.io/library/redis:v3.0-alpine` - > `mirror.privaterepo.com/public/db/redis:v3.0-alpine`, then 2 solutions can achieve this goal:

  - Method 1, add the synchronization parameter `--scoped=true --scoped-level=2`, the meaning of this group of parameters is: enable to keep the suffix path of the original warehouse image and write to the target warehouse, and specify that only the last two levels of the path are maintained ;

  - Method 2, add synchronization configuration such as `<registryName>.images-repo-mapping.redis: db/redis`, the meaning of this configuration is: specify the source repository `redis` (this is the default writing, the complete is `docker.io/library/redis`) mirror synchronization to the target warehouse write path is `db/redis`, For example configuration see: [example/sync.yml](example/sync.yml);

When both of the above two writing methods exist, only method 2 takes effect. For the source code, see: [github.com/containers/skopeo/blob/v1.8.0/cmd/skopeo/sync.go#L623](https://github.com/containers/skopeo/blob/v1.8.0/cmd/skopeo/sync.go#L623) and [github.com/wl4g-k8s/skopeo/blob/v1.8.0/cmd/skopeo/sync.go#L650](https://github.com/wl4g-k8s/skopeo/blob/v1.8.0/cmd/skopeo/sync.go#L650)

## 3. Developers Guide

- 3.1 build from [containers/skopeo](https://github.com/containers/skopeo)  (Only official standard features)

```bash
./build.sh containers_skopeo --build
```

- 3.2 (Recommends) build from [wl4g-k8s/skopeo features](https://github.com/wl4g-k8s/skopeo/blob/ref-1.8.0/cmd/skopeo/sync.go#L47)  (a fork, contains various enhancements such as support for `--scoped-level` and `images-repo-mapping`)

```bash
./build.sh wl4g_k8s_skopeo --init # Clone from github.com/wl4g-k8s/skopeo
./build.sh wl4g_k8s_skopeo --build
```

- 3.3 Push to registries

```bash
## for example push to docker registries:
docker tag skopeo:1.8.0 docker.io/wl4g/skopeo:1.8.0
docker login
docker push docker.io/wl4g/skopeo:1.8.0
```

## 3. FAQ

- If an error occurs: `Requesting bearer token: invalid status code from registry 403 (Forbidden)`, the previous authentication information may be invalid or expired, and you need to log in again. 

- ***Tip1:*** Usually the skopeo process may be running on the privaterepo server, you can resolve `mirror.registry.privaterepo.com` to `127.0.0.1` to speed up writing.

