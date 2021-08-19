Name:           flight-desktop-types
Version:        %{_flight_pkg_version}
Release:        %{_flight_pkg_rel}
Summary:        A collection of desktop session types for use with Flight Desktop

Group:          OpenFlight/Environment
License:        CC-BY-SA

URL:            https://openflighthpc.org
%undefine _disable_source_fetch
Source0:        https://github.com/openflighthpc/%{name}/archive/%{_flight_pkg_tag}.tar.gz
Source1:        https://raw.githubusercontent.com/openflighthpc/openflight-omnibus-builder/master/builders/flight-desktop-types/dist/flight-desktop-type-1.0.0.tar.gz

BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildArch:     noarch
Requires:      flight-desktop-system-1.0

%description
A collection of desktop session types for use with Flight Desktop.

%prep
%setup -q -n %{name}-%{_flight_pkg_tag}

%build

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/opt/flight/usr/lib/desktop/types
cp -R * $RPM_BUILD_ROOT/opt/flight/usr/lib/desktop/types
rm -f $RPM_BUILD_ROOT/opt/flight/usr/lib/desktop/types/*.md
rm -f $RPM_BUILD_ROOT/opt/flight/usr/lib/desktop/types/*.txt
mkdir $RPM_BUILD_ROOT/opt/flight/usr/lib/desktop/types/.doom
tar -C $RPM_BUILD_ROOT/opt/flight/usr/lib/desktop/types/.doom -xzf %{SOURCE1}

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%license LICENSE.txt
%dir /opt/flight/usr/lib/desktop/types/
%dir /opt/flight/usr/lib/desktop/types/chrome/
/opt/flight/usr/lib/desktop/types/chrome/*
%dir /opt/flight/usr/lib/desktop/types/gnome/
/opt/flight/usr/lib/desktop/types/gnome/*
%dir /opt/flight/usr/lib/desktop/types/kde/
/opt/flight/usr/lib/desktop/types/kde/*
%dir /opt/flight/usr/lib/desktop/types/terminal/
/opt/flight/usr/lib/desktop/types/terminal/*
%dir /opt/flight/usr/lib/desktop/types/xfce/
/opt/flight/usr/lib/desktop/types/xfce/*
%dir /opt/flight/usr/lib/desktop/types/xterm/
/opt/flight/usr/lib/desktop/types/xterm/*
%dir /opt/flight/usr/lib/desktop/types/.doom/
/opt/flight/usr/lib/desktop/types/.doom/*

%changelog
* Tue May 19 2020 Mark J. Titorenko <mark.titorenko@alces-flight.com> - 1.0.0
- Initial Package
