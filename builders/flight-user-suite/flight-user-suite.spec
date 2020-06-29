Name:           flight-user-suite
Version:        2020.2
Release:        4
Summary:        The Flight User Suite collection of HPC environment tools

Group:          OpenFlight/Environment
License:        EPL-2.0

URL:            https://openflighthpc.org

BuildArch:     noarch
Requires:      flight-runway => 1.1.0~, flight-runway < 1.2.0~
Requires:      flight-starter => 2020.2.0~, flight-starter < 2020.3.0~
Requires:      flight-env => 1.4.0~, flight-env < 1.5.0~
Requires:      flight-desktop => 1.3.0~, flight-desktop < 1.4.0~

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
* Mon Jun 29 2020 Mark J. Titorenko <mark.titorenko@openflighthpc.org> - 2020.2.-4
- Cleaned up requires
* Wed Apr  8 2020 Stu Franks <stu.franks@openflighthpc.org> - 2020.2-1
- Bumped env & desktop version to support CentOS 8
* Fri Oct  4 2019 Stu Franks <stu.franks@alces-flight.com> - 2019.1-1
- Initial Package

