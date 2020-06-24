Name:           flight-webapp-suite
Version:        2020.2
Release:        1
Summary:        The Flight Webapp Suite collection of HPC environment webapps

Group:          OpenFlight/Environment
License:        EPL-2.0

URL:            https://openflighthpc.org

BuildArch:     noarch
Requires:      flight-console-api => 0.0.2, flight-console-webapp => 0.0.5, flight-desktop-restapi => 1.0.1, flight-desktop-restapi < 1.1.0~, flight-desktop-webapp => 1.2.0, flight-desktop-restapi < 1.3.0~

%description
The Flight Webapp Suite collection of webapps for accessing a HPC environment.

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

%post
/opt/flight/bin/flight service enable console-api
/opt/flight/bin/flight service enable desktop-restapi
/opt/flight/bin/flight service enable www
/opt/flight/bin/flight service start console-api
/opt/flight/bin/flight service start desktop-restapi
/opt/flight/bin/flight service start www
cat <<EOF 1>&2
================================================
HTTPs support needs to be enabled for flight-www
================================================
To enable HTTPs support run '/opt/flight/bin/flight www enable-https'.
EOF

%postun
/opt/flight/bin/flight service stop console-api
/opt/flight/bin/flight service stop desktop-restapi
/opt/flight/bin/flight service stop www
/opt/flight/bin/flight service disable console-api
/opt/flight/bin/flight service disable desktop-restapi
/opt/flight/bin/flight service disable www

%changelog
* Fri May 22 2020 Ben Armston <ben.armston@alces-flight.com> - 2020.2-1
- Added post installation and uninstallation scripts.
* Mon May 18 2020 Ben Armston <ben.armston@alces-flight.com> - 2020.2-0
- Initial Package


