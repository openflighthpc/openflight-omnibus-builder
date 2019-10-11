Name:           flight-starter
Version:        1.1.1
Release:        1
Summary:        Profile scripts and infrastructure for activating an OpenFlight HPC environment

Group:          OpenFlight/Environment
License:        EPL-2.0

URL:            https://openflighthpc.org
%undefine _disable_source_fetch
Source0:        https://github.com/openflighthpc/%{name}/archive/%{version}.tar.gz
%define SHA256SUM0 6f30fc157cf1f1febd4c10bf241842cfbfba13b48646602517449e4df57be56d

BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildArch:     noarch
Requires:      flight-runway flight-starter-banner

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
/opt/flight/libexec/commands/*
%dir /opt/flight/libexec/flight-starter/
/opt/flight/libexec/flight-starter/*
%exclude /opt/flight/libexec/flight-starter/banner

%changelog
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
