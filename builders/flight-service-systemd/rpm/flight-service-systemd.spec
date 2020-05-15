Name:           flight-service-systemd
Version:        %{_flight_pkg_version}
Release:        %{_flight_pkg_rel}
Summary:        Provides systemd integration for flight-service

Group:          OpenFlight/Environment
License:        EPL-2.0

URL:            https://openflighthpc.org
%undefine _disable_source_fetch
Source0:        https://raw.githubusercontent.com/openflighthpc/openflight-omnibus-builder/master/LICENSE.txt
Source1:        https://raw.githubusercontent.com/openflighthpc/openflight-omnibus-builder/master/builders/flight-service-systemd/dist/flight-service.service

BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildArch:     noarch
Requires:      flight-service
Requires:      flight-service-system-1.0

%description
Provides systemd integration for flight-service

%setup -q -c -T
install -pm 644 %{SOURCE0} .
install -pm 644 %{SOURCE1} .

%build

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/usr/lib/systemd/system
install -p -m 644 %{SOURCE1} $RPM_BUILD_ROOT/usr/lib/systemd/system
install -p -m 644 %{SOURCE0} LICENSE.txt

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%license LICENSE.txt
/usr/lib/systemd/system/flight-service.service

%changelog
* Wed Apr 29 2020 Mark J. Titorenko <mark.titorenko@alces-flight.com> - 1.0.0
- Initial Package
