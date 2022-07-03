#!/bin/bash
# Copyright (c) 2017 ~ 2025, the original author wangl.sir individual Inc,
# All rights reserved. Contact us wanglsir<wangl@gmail.com, 983708408@qq.com>
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
[ -n "$debug" ] && set -ex

base_dir=$(cd "`dirname $0`";pwd)

# Build of github.com/containers/skopeo original release.
function build_containers_skopeo() {
    cd ${base_dir}/containers_skopeo
    docker build -t skopeo:1.8.0 .
}

# Cloning project from github.com/wl4g-k8s/skopeo enhanced release.
function clone_wl4g_k8s_skopeo() {
    cd ${base_dir}/wl4g-k8s_skopeo
    rm -rf skopeo # Clean older build

    echo "Cloning for git@github.com:wl4g-k8s/skopeo.git ..."
    git clone git@github.com:wl4g-k8s/skopeo.git && cd skopeo && git checkout ref-1.8.0
}

# Build of github.com/wl4g-k8s/skopeo enhanced release.
function build_wl4g_k8s_skopeo() {
    cd ${base_dir}/wl4g-k8s_skopeo/skopeo
    rm -rf bin # Clean older build

    echo "Building for wl4g-k8s/skopeo of image golang ..."
    ## build static binary. see:https://github.com/containers/skopeo/blob/v1.8.0/install.md#building-a-static-binary
    docker run --rm -v $PWD:/src -w /src -e CGO_ENABLED=0 golang make BUILDTAGS=containers_image_openpgp GO_DYN_FLAGS=

    ## build to mini image.
    cd ..
    docker build -t skopeo:1.8.0 .
}

# Clean for build assets.
function clean_wl4g_k8s_skopeo() {
    rm -rf ${base_dir}/wl4g-k8s_skopeo/skopeo/bin # Clean older build
}

function help(){
    echo "Usage: ./$(basename $0) [OPTIONS] [arg1] [arg2] ...

        containers_skopeo             
                            {--build|build|b}    Build of github.com/containers/skopeo original release.
        wl4g_k8s_skopeo
                            {--init|init|i}      Cloning project from github.com/wl4g-k8s/skopeo.
                            {--build|build|b}    Build of github.com/wl4g-k8s/skopeo enhanced release.
                            {--clean|clean|c}    Clean build for wl4g-k8s/skopeo.

        Global Environments:

            debug=true                           Debugging for scripts.
    "
}

# --- Main. ---
ARG1=$1
ARG2=$2
case $ARG1 in
  containers_skopeo)
    case $ARG2 in
        --build|build|b)
            build_containers_skopeo
        ;;
        *)
            help
            exit 2
        ;;
    esac
    ;;
  wl4g_k8s_skopeo)
    case $ARG2 in
        --init|init|i)
            clone_wl4g_k8s_skopeo
        ;;
        --build|build|b)
            build_wl4g_k8s_skopeo
        ;;
        --clean|clean|c)
            clean_wl4g_k8s_skopeo
        ;;
        *)
            help
            exit 2
        ;;
    esac
    ;;
  *)
  help
  exit 2
  ;;
esac