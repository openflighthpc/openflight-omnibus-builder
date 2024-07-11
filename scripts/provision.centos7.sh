#!/bin/bash

install_rvm() {
    if ! gpg2 --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB; then
      command curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
      command curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
    fi
    if ! curl -sSL https://get.rvm.io | bash -s stable; then
      if ! gpg2 --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB; then
        command curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
        command curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
      fi
      curl -sSL https://get.rvm.io | bash -s stable
      if [ $? -gt 0 ]; then
        cat <<EOF 1>&2

!!!!!!!!!!!!!!!!!!!!!!!
   RVM NOT INSTALLED
!!!!!!!!!!!!!!!!!!!!!!!

FSR, unable to install RVM. :-(

EOF
        exit 1
      fi
    fi
}

install_ruby_and_bundler() {
      rvm install 2.7
      gem install bundler:1.17.3
      gem install bundler:2.1.4
      usermod -a -G rvm centos
}

install_go() {
  # Flight File Manager API has a reverse proxy written in Go. It requires Go
  # 1.22 to be installed.

  # Remove any previous Go installation
  rm -rf /usr/local/go

  # Fetch Go 1.22 release
  cd /tmp
  wget https://go.dev/dl/go1.22.2.linux-amd64.tar.gz

  # Extract Go 1.22 to /usr/local
  tar -C /usr/local -xzf /tmp/go1.22.2.linux-amd64.tar.gz

  # Include Go binary in PATH
  echo 'export PATH=$PATH:/usr/local/go/bin' >>/home/centos/.bash_profile
}

mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.orig
cat <<'EOF' > /etc/yum.repos.d/CentOS-Base.repo
[base]
name=CentOS-$releasever - Base
baseurl=http://vault.centos.org/7.9.2009/os/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[updates]
name=CentOS-$releasever - Updates
baseurl=http://vault.centos.org/7.9.2009/updates/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[extras]
name=CentOS-$releasever - Extras
baseurl=http://vault.centos.org/7.9.2009/extras/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[centosplus]
name=CentOS-$releasever - Plus
baseurl=http://vault.centos.org/7.9.2009/centosplus/$basearch/
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
EOF

yum install -y -e0 vim emacs-nox
yum install -y -e0 git rpm-build cmake wget perl
install_rvm
source /etc/profile.d/rvm.sh
install_ruby_and_bundler

# required for building genders as part of flight-pdsh
yum install -y -e0 flex

yum install -y -e0 createrepo

# required for building flight-desktop-restapi
yum install -y -e0 pam-devel

# required for building flight-certbot
yum install -y -e0 python3-pip
su centos -c 'pip3 install pipenv --user'

yum install -y -e0 awscli

mkdir /opt/flight
chown centos /opt/flight

install_go

cd /opt
git clone https://github.com/openflighthpc/openflight-repo
git clone https://github.com/openflighthpc/openflight-omnibus-builder
chown -R centos openflight-omnibus-builder/
cd openflight-repo
bundle install --path=vendor
cat <<'EOF' >> /etc/profile.d/openflight-repo.sh
  repo() {
    /opt/openflight-omnibus-builder/scripts/repo "$@"
  }
EOF

# Required due to hard-coded paths in builder bundle configs
ln -s /home/centos /home/vagrant
