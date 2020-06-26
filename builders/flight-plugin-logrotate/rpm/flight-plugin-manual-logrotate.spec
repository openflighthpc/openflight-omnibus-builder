Name:           flight-plugin-manual-logrotate
Version:        %{_flight_pkg_version}
Release:        %{_flight_pkg_rel}
Summary:        Provides manually managed logrotate integration for OpenFlight tools

Group:          OpenFlight/Environment
License:        EPL-2.0

URL:            https://openflighthpc.org
%undefine _disable_source_fetch
Source0:        https://raw.githubusercontent.com/openflighthpc/openflight-omnibus-builder/master/LICENSE.txt
Source1:        https://raw.githubusercontent.com/openflighthpc/openflight-omnibus-builder/master/builders/flight-plugin-logrotate/dist/openflight-logrotate

BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildArch:      noarch
Provides:       flight-logrotate-system-1.0
Provides:       flight-plugin-logrotate
Conflicts:      flight-plugin-system-logrotate

%description
Provides manually managed logrotate integration for OpenFlight tools

%prep
%setup -q -c -T
install -pm 644 %{SOURCE0} .
install -pm 644 %{SOURCE1} .

%build

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/opt/flight/etc/plugin/logrotate.d
mkdir -p $RPM_BUILD_ROOT/opt/flight/etc/logrotate.d
install -p -m 644 %{SOURCE1} $RPM_BUILD_ROOT/opt/flight/etc/plugin/logrotate.d/openflight
install -p -m 644 %{SOURCE0} LICENSE.txt

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%license LICENSE.txt
/opt/flight/etc/plugin/logrotate.d/openflight
%dir /opt/flight/etc/logrotate.d

%changelog
* Tue Jun 23 2020 Mark J. Titorenko <mark.titorenko@alces-flight.com> - 1.0.0
- Initial Package
