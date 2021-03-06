Name:           flight-env-types
Version:        %{_flight_pkg_version}
Release:        %{_flight_pkg_rel}
Summary:        A collection of software package environment types for use with Flight Environment

Group:          OpenFlight/Environment
License:        CC-BY-SA

URL:            https://openflighthpc.org
%undefine _disable_source_fetch
Source0:        https://github.com/openflighthpc/%{name}/archive/%{_flight_pkg_tag}.tar.gz

BuildRoot:      %{_tmppath}/%{name}-%{_flight_pkg_tag}-%{release}-root-%(%{__id_u} -n)

BuildArch:     noarch
Requires:      flight-env-system-1.0
Requires:      flight-python

%description
A collection of software package environment types for use with Flight Environment

%prep
%setup -q -n %{name}-%{_flight_pkg_tag}

%build

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/opt/flight/usr/lib/env/types
cp -R * $RPM_BUILD_ROOT/opt/flight/usr/lib/env/types
rm -f $RPM_BUILD_ROOT/opt/flight/usr/lib/env/types/*.md
rm -f $RPM_BUILD_ROOT/opt/flight/usr/lib/env/types/*.txt

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%license LICENSE.txt
%dir /opt/flight/usr/lib/env/types/
%dir /opt/flight/usr/lib/env/types/brew/
/opt/flight/usr/lib/env/types/brew/*
%dir /opt/flight/usr/lib/env/types/conda/
/opt/flight/usr/lib/env/types/conda/*
%dir /opt/flight/usr/lib/env/types/easybuild/
/opt/flight/usr/lib/env/types/easybuild/*
%dir /opt/flight/usr/lib/env/types/gridware/
/opt/flight/usr/lib/env/types/gridware/*
%dir /opt/flight/usr/lib/env/types/modules/
/opt/flight/usr/lib/env/types/modules/*
%dir /opt/flight/usr/lib/env/types/singularity/
/opt/flight/usr/lib/env/types/singularity/*
%dir /opt/flight/usr/lib/env/types/spack/
/opt/flight/usr/lib/env/types/spack/*

%changelog
* Wed Jun 09 2021 Ben Armston <ben.armston@alces-flight.com> - 1.0.3
- Fixed issue with easybuild environment creation.
* Thu Mar 11 2021 Ben Armston <ben.armston@alces-flight.com> - 1.0.2
- Fixed issue with non-standard build directories under singularity.
* Tue May 19 2020 Mark J. Titorenko <mark.titorenko@alces-flight.com> - 1.0.0
- Initial Package
