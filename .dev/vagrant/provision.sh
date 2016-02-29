#!/bin/bash

echo "Setting up dev environment"
sleep 40

apt-get update --no-install-recommends
apt-get install -y curl vim git bzr mercurial

[ -f /vagrant/tmp/go1.6.linux-amd64.tar.gz ] || {
  mkdir -p /vagrant/tmp
  pushd /vagrant/tmp
  curl -o go1.6.linux-amd64.tar.gz https://storage.googleapis.com/golang/go1.6.linux-amd64.tar.gz
  popd
}

[ -d /usr/local/go ] || sudo tar -C /usr/local -xzf /vagrant/tmp/go1.6.linux-amd64.tar.gz

grep 'export GOROOT=' .bash_profile || ( echo export GOROOT=/usr/local/go | tee -a .bash_profile )
grep 'export GOPATH=' .bash_profile || ( echo export GOPATH=/vagrant/go | tee -a .bash_profile )
source .bash_profile
grep 'export PATH=' .bash_profile || ( echo export PATH=$PATH:$GOROOT/bin:$GOPATH/bin | tee -a .bash_profile)
source .bash_profile
mkdir -p $GOPATH

go get github.com/Masterminds/glide
cd $GOPATH/src/github.com/Masterminds/glide && make bootstrap && make build && make install

echo "everything should be ready to dev"
