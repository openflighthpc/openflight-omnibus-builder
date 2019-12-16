Name:           openflighthpc-release
Version:        1
Release:        1
Summary:        OpenFlightHPC repository configuration

Group:          System Environment/Base
License:        EPL-2.0

URL:            https://openflighthpc.org
%undefine _disable_source_fetch
Source0:        https://raw.githubusercontent.com/openflighthpc/openflight-omnibus-builder/master/LICENSE.txt
%define SHA256SUM0 8c349f80764d0648e645f41ef23772a70c995a0924b5235f735f4a3d09df127c
Source1:        https://repo.openflighthpc.org/openflight/centos/7/openflight.repo
%define SHA256SUM1 c00aa682164c2fadc411cac2ead70fdf5c9cc2030cc015053f5808225a31f7ba
Source2:        https://repo.openflighthpc.org/openflight-dev/centos/7/openflight-dev.repo
%define SHA256SUM2 5477460085d067cad038abbd6cbcbdc2c73a8a8f40758de1caf57d830ac82e85
#Source3:        https://openflighthpc.org/RPM-GPG-KEY-OPENFLIGHT

BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildArch:     noarch
Requires:      redhat-release >= 7

%description
This package contains the OpenFlightHPC repository configuration for yum.

%prep
echo "%SHA256SUM0 %SOURCE0" | sha256sum -c -
echo "%SHA256SUM1 %SOURCE1" | sha256sum -c -
echo "%SHA256SUM2 %SOURCE2" | sha256sum -c -

%setup -q  -c -T
install -pm 644 %{SOURCE0} .
install -pm 644 %{SOURCE1} .
install -pm 644 %{SOURCE2} .
sed -i 's/enabled=1/enabled=0/g' %{SOURCE2}

%build


%install
rm -rf $RPM_BUILD_ROOT

#GPG Key
#install -Dpm 644 %{SOURCE3} \
#    $RPM_BUILD_ROOT%{_sysconfdir}/pki/rpm-gpg/RPM-GPG-KEY-OPENFLIGHT

# yum
install -dm 755 $RPM_BUILD_ROOT%{_sysconfdir}/yum.repos.d
install -pm 644 %{SOURCE1} %{SOURCE2}  \
    $RPM_BUILD_ROOT%{_sysconfdir}/yum.repos.d

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%doc LICENSE.txt
%config(noreplace) /etc/yum.repos.d/*
#/etc/pki/rpm-gpg/*


%changelog
* Thu Oct  3 2019 Rob Brown <rob.brown@alces-flight.com> - 1.0
- Initial Package
