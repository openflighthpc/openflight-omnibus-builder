Name:           flight-user-suite
Version:        %{_flight_pkg_version}
Release:        %{_flight_pkg_rel}%{?dist}
Summary:        The Flight User Suite collection of HPC environment tools

Group:          OpenFlight/Environment
License:        EPL-2.0

URL:            https://openflighthpc.org

BuildArch:     noarch
Requires:      flight-runway => 1.1.0, flight-runway < 1.2.0~
Requires:      flight-starter => 2021.8.0~, flight-starter < 2021.9.0~
%{?el8:Recommends:    flight-plugin-system-starter}
Requires:      flight-env => 1.4.0, flight-env < 1.5.0~
Requires:      flight-desktop => 1.8.0, flight-desktop < 1.9.0~
Requires:      flight-job => 2.6.0~, flight-job < 2.7.0~
Requires:      flight-howto => 1.0.2, flight-howto < 1.2.0~

%description
The Flight User Suite collection of tools and packages for running a HPC environment.

%prep
# Nothing to do

%build
# Nothing to do

%install
# Nothing to do

%clean
# Nothing to do

%files
# Nothing to do

%changelog
* Wed Oct 27 2021 Ben Armston <ben.armston@alces-flight.com> - 2021.8-1
- Bumped flight-job
* Tue Sep 14 2021 Ben Armston <ben.armston@alces-flight.com> - 2021.7-1
- Bumped flight-job and flight-desktop
* Thu Aug 19 2021 Ben Armston <ben.armston@alces-flight.com> - 2021.6-1
- Bumped flight-job and flight-desktop
* Fri Jun 25 2021 Ben Armston <ben.armston@alces-flight.com> - 2021.5-1
- Bumped flight-job and flight-desktop
* Fri Jun 11 2021 Ben Armston <ben.armston@alces-flight.com> - 2021.4-1
- Bumped flight-job and flight-desktop
* Thu Apr 29 2021 Ben Armston <ben.armston@alces-flight.com> - 2021.3-1
- Bumped flight-job and flight-desktop
* Wed Mar 24 2021 Ben Armston <ben.armston@alces-flight.com> - 2021.2-2
- Fixed flight-starter bounds
* Wed Mar 24 2021 Ben Armston <ben.armston@alces-flight.com> - 2021.2-1
- Bumped flight-job
* Mon Feb 22 2021 Ben Armston <ben.armston@alces-flight.com> - 2021.1-2
- Fixed flight-starter bounds
* Mon Feb 15 2021 Ben Armston <ben.armston@alces-flight.com> - 2021.1-1
- Bumped flight-howto upper bound
* Mon Oct 19 2020 ben.armston@alces-flight.com - 2020.3-1
- Added flight-job and flight-howto
* Mon Jun 29 2020 Mark J. Titorenko <mark.titorenko@openflighthpc.org> - 2020.2-4
- Cleaned up requires
* Wed Apr  8 2020 Stu Franks <stu.franks@openflighthpc.org> - 2020.2-1
- Bumped env & desktop version to support CentOS 8
* Fri Oct  4 2019 Stu Franks <stu.franks@alces-flight.com> - 2019.1-1
- Initial Package

