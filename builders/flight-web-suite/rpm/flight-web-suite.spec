#==============================================================================
# Copyright (C) 2020-present Alces Flight Ltd.
#
# This file is part of OpenFlight Omnibus Builder.
#
# This program and the accompanying materials are made available under
# the terms of the Eclipse Public License 2.0 which is available at
# <https://www.eclipse.org/legal/epl-2.0>, or alternative license
# terms made available by Alces Flight Ltd - please direct inquiries
# about licensing to licensing@alces-flight.com.
#
# This project is distributed in the hope that it will be useful, but
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR
# IMPLIED INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OR CONDITIONS
# OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A
# PARTICULAR PURPOSE. See the Eclipse Public License 2.0 for more
# details.
#
# You should have received a copy of the Eclipse Public License 2.0
# along with this project. If not, see:
#
#  https://opensource.org/licenses/EPL-2.0
#
# For more information on OpenFlight Omnibus Builder, please visit:
# https://github.com/openflighthpc/openflight-omnibus-builder
#===============================================================================

Name:           flight-web-suite
Version:        %{_flight_pkg_version}
Release:        %{_flight_pkg_rel}%{?dist}
Summary:        The Flight Web Suite collection of HPC environment web applications

Group:          OpenFlight/Environment
License:        EPL-2.0

URL:            https://openflighthpc.org

BuildArch:      noarch
Requires:       flight-console-api => 1.0.0, flight-console-api < 1.1.0~
Requires:       flight-console-webapp => 1.0.0, flight-console-webapp < 1.1.0~
Requires:       flight-desktop-restapi => 1.0.2, flight-desktop-restapi < 1.1.0~
Requires:       flight-desktop-webapp => 1.2.0, flight-desktop-webapp < 1.3.0~

%description
The Flight Web Suite collection of web applications for accessing a HPC environment.

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
* Tue Oct 20 2020 William McCumstie <william.mccumstie@alces-flight.com> - 2020.3-2
- Renamed the package to flight-web-suite
- Set the upper version number bounds to the next minor release
* Mon Oct 19 2020 William McCumstie <william.mccumstie@alces-flight.com> - 2020.3-1
- Bump flight-console-* versions to 1.0.0 and flight-desktop-restapi to 1.0.2
* Fri May 22 2020 Ben Armston <ben.armston@alces-flight.com> - 2020.2-1
- Added post installation and uninstallation scripts.
* Mon May 18 2020 Ben Armston <ben.armston@alces-flight.com> - 2020.2-0
- Initial Package


