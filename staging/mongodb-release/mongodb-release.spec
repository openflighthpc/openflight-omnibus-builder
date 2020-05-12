Name:           mongodb-release
Version:        1
Release:        1
Summary:        MongoDB Community repository configuration

Group:          System Environment/Base
License:        EPL-2.0

URL:            https://mongodb.org
%undefine _disable_source_fetch

BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildArch:     noarch
Requires:      redhat-release >= 7

%description
This package contains the MongoDB Community repository configuration for yum.

%prep
# No prep to do

%build
cat <<'EOF' > mongodb-org-4.2.repo
[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc
EOF

%install
rm -rf $RPM_BUILD_ROOT
install -dm 755 mongodb-org-4.2.repo /etc/yum.repos.d/mongodb-org-4.2.repo

%clean
rm -rf $RPM_BUILD_ROOT

%files
/etc/yum.repos.d/mongodb-org-4.2.repo

%changelog
* Mon Jan 13 2020 Stu Franks <stu.franks@openflighthpc.org> - 1.0
- Initial Package
