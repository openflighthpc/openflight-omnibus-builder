Name:           openflighthpc-release
Version:        3
Release:        1
Summary:        OpenFlightHPC repository configuration

Group:          System Environment/Base
License:        EPL-2.0

URL:            https://openflighthpc.org
%undefine _disable_source_fetch
Source0:        https://raw.githubusercontent.com/openflighthpc/openflight-omnibus-builder/master/LICENSE.txt
%define SHA256SUM0 8c349f80764d0648e645f41ef23772a70c995a0924b5235f735f4a3d09df127c
Source1:        https://repo.openflighthpc.org/openflight.repo
%define SHA256SUM1 01820e3e7d5dc2a2484bf2276d2b6cff4ba58698c6f288aa877c61b40405f111
#Source4:        https://openflighthpc.org/RPM-GPG-KEY-OPENFLIGHT

BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildArch:     noarch
Requires:      redhat-release >= 7

%description
This package contains the OpenFlightHPC repository configuration for yum.

%prep
echo "%SHA256SUM0 %SOURCE0" | sha256sum -c -
echo "%SHA256SUM1 %SOURCE1" | sha256sum -c -

%setup -q  -c -T
install -pm 644 %{SOURCE0} .
install -pm 644 %{SOURCE1} .

%build


%install
rm -rf $RPM_BUILD_ROOT

#GPG Key
#install -Dpm 644 %{SOURCE4} \
#    $RPM_BUILD_ROOT%{_sysconfdir}/pki/rpm-gpg/RPM-GPG-KEY-OPENFLIGHT

# yum
install -dm 755 $RPM_BUILD_ROOT%{_sysconfdir}/yum.repos.d
install -pm 644 %{SOURCE1} $RPM_BUILD_ROOT%{_sysconfdir}/yum.repos.d

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%doc LICENSE.txt
%config(noreplace) /etc/yum.repos.d/*
#/etc/pki/rpm-gpg/*


%changelog
* Wed Mar 25 2020 Stu Franks <stu.franks@openflighthpc.org> - 3.0
- Merged all repo files into one master file
- Added el8 support through use of $releasever repo variable
* Mon Dec 16 2019 Stu Franks <stu.franks@openflighthpc.org> - 2.0
- Point to new openflight upstream S3 repo
- Add vault repo
* Thu Oct  3 2019 Rob Brown <rob.brown@alces-flight.com> - 1.0
- Initial Package
