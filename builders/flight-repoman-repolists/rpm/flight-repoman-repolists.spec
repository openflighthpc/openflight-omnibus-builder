Name:           flight-repoman-repolists
Version:        %{_flight_pkg_version}
Release:        %{_flight_pkg_rel}
Summary:        A collection of repository lists for use with Flight Repository Manager

Group:          OpenFlight/Environment
License:        CC-BY-SA

URL:            https://openflighthpc.org
%undefine _disable_source_fetch
Source0:        https://raw.githubusercontent.com/openflighthpc/openflight-omnibus-builder/master/builders/flight-repoman-repolists/dist/flight-repoman-repolists-1.0.0.tar.gz
Source1:        https://raw.githubusercontent.com/openflighthpc/openflight-omnibus-builder/master/LICENSE.txt

BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildArch:     noarch
Requires:      flight-repoman-system >= 1.0, flight-repoman-system < 2

%description
A collection of repository lists for use with Flight Repository Manager.

%prep
%setup -q
install -pm 644 %{SOURCE1} .

%build

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/opt/flight/usr/lib/repoman/repolists
cp -R * $RPM_BUILD_ROOT/opt/flight/usr/lib/repoman/repolists
rm -f $RPM_BUILD_ROOT/opt/flight/usr/lib/repoman/repolists/LICENSE.txt

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%license LICENSE.txt
%dir /opt/flight/usr/lib/repoman/repolists/
/opt/flight/usr/lib/repoman/repolists/*

%changelog
* Tue Jul 28 2020 Mark J. Titorenko <mark.titorenko@alces-flight.com> - 1.0.0
- Initial Package
