#!/usr/bin/env bash

set -euo pipefail

die()
{
  echo "$@" 1>&2
  exit 1
}

[ $# -eq 3 ] || die "usage: jenkins_port java_web_start_port jenkins_home"

jenkins_port=$1
shift
java_web_start_port=$1
shift
jenkins_home=$1
shift

mkdir -p $jenkins_home
jenkins_home=$(readlink -f $jenkins_home)

script_dir=$(dirname $(readlink -f $0))

# get id of user groups
all_id=$(id -G | tr ' ' '\n' | sed -e 's/^/--group-add /g' | tr '\n' ' ')

docker build -t jenkins - < $script_dir/jenkins.Dockerfile
docker run \
  --rm=true \
  -p $java_web_start_port:8081 \
  -p $jenkins_port:8080 \
  -v $jenkins_home:/jenkins_home \
  -e 'TZ=Europe/Paris' \
  -e USER=$USER \
  -e HOME=$HOME \
  -v $HOME:$HOME \
  -v /tmp:/tmp \
  -v /mnt/:/mnt/ \
  -v /var/lib/docker:/var/lib/docker \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /etc/passwd:/etc/passwd:ro \
  -v /etc/group:/etc/group:ro \
  -v /etc/shadow:/etc/shadow:ro \
  -u $UID:"$(id -g)" \
  $all_id \
  jenkins
