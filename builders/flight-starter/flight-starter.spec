Name:           flight-starter
Version:        1.1.0
Release:        1
Summary:        Profile scripts and infrastructure for activating an OpenFlight HPC environment

Group:          OpenFlight/Environment
License:        EPL-2.0

URL:            https://openflighthpc.org
%undefine _disable_source_fetch
Source0:        https://github.com/openflighthpc/%{name}/archive/%{version}.tar.gz
%define SHA256SUM0 a444d9634b07837e346cfc30e8f0af7a9dcbd8e62263738e01f48e23a3a40f1f

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
