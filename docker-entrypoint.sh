#!/usr/bin/env sh

DRY_RUN=${DRY_RUN:-}
command_exists() {
	command -v "$@" > /dev/null 2>&1
}

error_msg () {
    local RED='\033[0;31m'
    local NC='\033[0m' # No Color
    printf "${RED}${@}${NC}"
    echo; echo;
}

is_dry_run() {
	if [ -z "$DRY_RUN" ]; then
		return 1
	else
		return 0
	fi
}

sh_c='sh -c'

if is_dry_run; then
    sh_c="echo"
fi

if [ ! -e /var/run/docker.sock ]; then
    error_msg 'Docker socket not found.'
    exit 1
fi

if ! command_exists docker || [ ! -e /var/run/docker.sock ]; then
    error_msg 'No docker found.'
    exit 1

else
    (
        set -x
        $sh_c 'docker version'
    ) || true
fi

echo; echo;

if ! command_exists docker-credential-ecr-login; then
    (
        set -x
        $sh_c 'go get -u github.com/awslabs/amazon-ecr-credential-helper/ecr-login/cli/docker-credential-ecr-login'
    )
fi

echo; echo;
python3 setup.py

sh
