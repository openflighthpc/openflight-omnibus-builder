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
      cd /tmp
      wget https://github.com/openssl/openssl/releases/download/OpenSSL_1_1_1t/openssl-1.1.1t.tar.gz
      tar -xvxf /tmp/openssl-1.1.1t.tar.gz
      cd /tmp/openssl-1.1.1t/
      ./config --prefix=/opt/openssl-1.1.1t --openssldir=/opt/openssl-1.1.1t shared zlib
      make install
      rm -rf /opt/openssl-1.1.1t/certs
      ln -s /etc/ssl/certs /opt/openssl-1.1.1t
      wget http://curl.haxx.se/ca/cacert.pem -O /tmp/cacert.pem
      mv /tmp/cacert.pem /home/rocky/cacert.pem
      export SSL_CERT_FILE=/home/rocky/cacert.pem
      echo 'export SSL_CERT_FILE=/home/vagrant/cacert.pem' >>/home/rocky/.bash_profile
      rvm install 2.7 --with-openssl-dir=/opt/openssl-1.1.1t/
      gem install bundler:1.17.3  
      gem install bundler:2.1.4
      usermod -a -G rvm rocky
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
  echo 'export PATH=$PATH:/usr/local/go/bin' >>/home/rocky/.bash_profile
}

dnf install -y -e0 vim emacs-nox
dnf install -y -e0 git rpm-build cmake wget perl
install_rvm
source /etc/profile.d/rvm.sh
install_ruby_and_bundler

# required for building genders as part of flight-pdsh
dnf install -y -e0 flex

dnf install -y -e0 createrepo

# required for building flight-desktop-restapi
dnf install -y -e0 pam-devel

# required for building flight-certbot
dnf install -y -e0 python3-pip
su rocky -c 'pip3 install pipenv --user'

dnf install -y python3-devel

su rocky -c 'pip3 install awscli --upgrade --user'

mkdir /opt/flight
chown rocky /opt/flight

install_go

cd /opt
git clone https://github.com/openflighthpc/openflight-repo
git clone https://github.com/openflighthpc/openflight-omnibus-builder
chown -R rocky openflight-omnibus-builder/
cd openflight-repo
bundle install --path=vendor
cat <<'EOF' >> /etc/profile.d/openflight-repo.sh
  repo() {
    /opt/openflight-omnibus-builder/scripts/repo "$@"
  }
EOF

# Required due to hard-coded paths in builder bundle configs
ln -s /home/rocky /home/vagrant

cp -a /etc/os-release /etc/os-release.orig
sed -i -e 's/^ID=.*/ID="rhel"/g' /etc/os-release
sed -i -e 's/^\(.*\)/Red Hat \1/g' /etc/redhat-release
