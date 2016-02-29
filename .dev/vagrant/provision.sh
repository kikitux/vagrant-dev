#!/bin/bash

[ -f /usr/local/go/bin/go ] || {
  export DEBIAN_FRONTEND=noninteractive
  unset PACKAGES

  PACKAGES="curl git bzr"
  sudo -E -H apt-get update
  sudo -E -H apt-get install -y -q --no-install-recommends ${PACKAGES}

  unset gover
  gover=1.6

  curl -o go${gover}.linux-amd64.tar.gz https://storage.googleapis.com/golang/go${gover}.linux-amd64.tar.gz
  sudo tar -C /usr/local -xzf go${gover}.linux-amd64.tar.gz
  [ -f go${gover}.linux-amd64.tar.gz ] && rm go${gover}.linux-amd64.tar.gz

  grep 'export GOROOT=' .bash_profile || ( echo export GOROOT=/usr/local/go | tee -a .bash_profile )
  grep 'export GOPATH=' .bash_profile || ( echo export GOPATH=/vagrant/go | tee -a .bash_profile )
  source .bash_profile
  grep 'export PATH=' .bash_profile || ( echo export PATH=$PATH:$GOROOT/bin:$GOPATH/bin | tee -a .bash_profile)
}

echo "Setting up dev environment"
source .bash_profile
mkdir -p $GOPATH

[ -d $GOPATH/src/github.com/Masterminds/glide ] || {
  go get github.com/Masterminds/glide
  cd $GOPATH/src/github.com/Masterminds/glide && make bootstrap && make build && make install
}

echo "everything should be ready to dev"
