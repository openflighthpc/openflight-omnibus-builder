Name:           flight-starter
Version:        2020.2.0
Release:        2
Summary:        Profile scripts and infrastructure for activating an OpenFlight HPC environment

Group:          OpenFlight/Environment
License:        EPL-2.0

URL:            https://openflighthpc.org
%undefine _disable_source_fetch
Source0:        https://github.com/openflighthpc/%{name}/archive/%{version}.tar.gz
%define SHA256SUM0 6e4d83e2890b3be9b212a2bbd10e32a02860b9690a231a4993d2660f1f0d473e

BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildArch:     noarch
Requires:      flight-runway, flight-starter-banner => 2020.2.0, flight-starter-banner < 2020.3.0~

%description
Profile scripts and infrastructure for activating an OpenFlight HPC environment

%prep
echo "%SHA256SUM0 %SOURCE0" | sha256sum -c -
%setup -q

%build


%install
cp -R dist/* $RPM_BUILD_ROOT

%clean
#rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%license LICENSE.txt
%config(noreplace) %{_sysconfdir}/xdg/*
%{_sysconfdir}/profile.d/*
/opt/flight/etc/banner/banner.d/*
/opt/flight/etc/banner/tips.d/*
%config(noreplace) /opt/flight/etc/setup-sshkey.rc
%config(noreplace) /opt/flight/etc/flight-config-map.yml
/opt/flight/etc/profile.d/*
/opt/flight/etc/setup.sh
/opt/flight/etc/setup.csh
/opt/flight/libexec/commands/*
%dir /opt/flight/libexec/flight-starter/
/opt/flight/libexec/flight-starter/*
%exclude /opt/flight/libexec/flight-starter/banner

%changelog
* Wed Apr  8 2020 Stu Franks <stu.franks@openflighthpc.org> - 2020.2.0
- Updated to 2020.2.0
* Thu Apr  2 2020 Mark J. Titorenko <mark.titorenko@alces-flight.com> - 2020.1.3
- Updated to 2020.1.3
- Support /etc/lsb-release if /etc/redhat-release not present
* Thu Mar 12 2020 Mark J. Titorenko <mark.titorenko@alces-flight.com> - 2020.1.2
- Updated to 2020.1.2
- Added sourceable setup scripts for use in job scripts
* Mon Dec 16 2019 Stu Franks <stu.franks@openflighthpc.org> - 2020.1.1
- Updated to 2020.1.1
* Wed Dec 11 2019 Mark J. Titorenko <mark.titorenko@alces-flight.com> - 2020.1.0
- Updated numbering scheme
- Updated to 2020.1.0
* Mon Nov  4 2019 Mark J. Titorenko <mark.titorenko@alces-flight.com> - 1.2.1
- Updated to v1.2.1
* Mon Oct 28 2019 Mark J. Titorenko <mark.titorenko@alces-flight.com> - 1.2.0
- Updated to v1.2.0
* Tue Oct  8 2019 Mark J. Titorenko <mark.titorenko@alces-flight.com> - 1.1.1
- Updated to v1.1.1
* Fri Oct  4 2019 Mark J. Titorenko <mark.titorenko@alces-flight.com> - 1.1.0
- Initial Package

%package banner
Summary: OpenFlightHPC branded banner for Flight Starter
Requires: flight-starter
%description banner
OpenFlightHPC branded banner for Flight Starter
%files banner
%defattr(-,root,root,-)
%license LICENSE.txt
%config(noreplace) /opt/flight/etc/flight-starter.rc
%config(noreplace) /opt/flight/etc/flight-starter.cshrc
/opt/flight/etc/banner/banner.erb
/opt/flight/etc/banner/banner.txt
/opt/flight/etc/banner/banner.yml
/opt/flight/libexec/flight-starter/banner
