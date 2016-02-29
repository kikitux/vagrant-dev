#!/bin/bash
set -e
exec 2>&1

[ -f /usr/local/go/bin/go ] || {
  export DEBIAN_FRONTEND=noninteractive
  unset PACKAGES

  sudo rm /var/lib/apt/lists/* -vrf

  PACKAGES="curl git bzr cmake vim-nox python-dev ctags"
  sudo -E -H apt-get update
  sudo -E -H apt-get install -y -q --no-install-recommends ${PACKAGES}

  unset gover
  gover=1.6

  curl -s -o go${gover}.linux-amd64.tar.gz https://storage.googleapis.com/golang/go${gover}.linux-amd64.tar.gz
  sudo tar -C /usr/local -xzf go${gover}.linux-amd64.tar.gz
  [ -f go${gover}.linux-amd64.tar.gz ] && rm go${gover}.linux-amd64.tar.gz

  touch .bash_profile
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

[ -d /home/vagrant/dotfiles ] || {
  mkdir -p /home/vagrant/dotfiles && cd $_
  git clone https://github.com/benhinchley/vagrant-dotfiles.git .
  sh setup.sh
}

cd $GOPATH && sudo chown -R vagrant .

echo "everything should be ready to dev"
