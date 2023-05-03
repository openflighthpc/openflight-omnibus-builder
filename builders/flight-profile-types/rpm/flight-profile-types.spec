Name: flight-profile-types
Version: %{_flight_pkg_version}
Release: %{_flight_pkg_rel}
Summary: A collection of cluster types for use with Flight Profile

Group: OpenFlight/Environment
License: CC-BY-SA
URL: https://openflighthpc.org
%undefine _disable_source_fetch
Source0: https://github.com/openflighthpc/%{name}/archive/%{_flight_pkg_tag}.tar.gz

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildArch: noarch
Requires: flight-profile-system-1.0
Requires: flight-profile >= 0.2.0~rc2

%description
A collection of cluster types for use with Flight Profile

%prep
%setup -q -n %{name}-%{_flight_pkg_tag}

%build

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/opt/flight/usr/lib/profile/types
cp -R * $RPM_BUILD_ROOT/opt/flight/usr/lib/profile/types
rm -rf $RPM_BUILD_ROOT/opt/flight/usr/lib/profile/types/*.md
rm -rf $RPM_BUILD_ROOT/opt/flight/usr/lib/profile/types/*.txt

%clean
rm -rf $RPM_BUILD_ROOT


%files
%defattr(-,root,root,-)
%license LICENSE.txt
%files
/opt/flight/usr/lib/profile/types

%changelog
