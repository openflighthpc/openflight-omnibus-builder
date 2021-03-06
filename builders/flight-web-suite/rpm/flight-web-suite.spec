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
Requires:       flight-console-api => 2.1.0, flight-console-api < 2.2.0~
Requires:       flight-console-webapp => 1.3.0, flight-console-webapp < 1.4.0~
Requires:       flight-desktop-restapi => 2.3.0, flight-desktop-restapi < 2.4.0~
Requires:       flight-desktop-webapp => 1.4.0, flight-desktop-webapp < 1.5.0~
Requires:       flight-file-manager-api => 1.2.0, flight-file-manager-api < 1.3.0~
Requires:       flight-file-manager-webapp => 1.2.0, flight-file-manager-webapp < 1.3.0~
Requires:       flight-login-api => 1.1.0, flight-login-api < 1.2.0~
Requires:       flight-job-script-api => 1.3.0, flight-job-script-api < 1.4.0~
Requires:       flight-job-script-webapp => 1.3.0, flight-job-script-webapp < 1.4.0~
Requires:       flight-www => 1.6.0, flight-www < 1.7.0~
Requires:       flight-headnode-landing-page < 1.4.0~
Requires:       flight-web-suite-utils => 1.0.0 flight-web-suite-utils < 1.1.0~

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
/opt/flight/bin/flight service enable file-manager-api
/opt/flight/bin/flight service enable job-script-api
/opt/flight/bin/flight service enable login-api
/opt/flight/bin/flight service enable www
/opt/flight/bin/flight service restart console-api
/opt/flight/bin/flight service restart desktop-restapi
/opt/flight/bin/flight service restart job-script-api
/opt/flight/bin/flight service restart www

/opt/flight/bin/flight config get web-suite.domain 1>/dev/null 2>&1
if [ "$?" -eq "0" ] ; then
/opt/flight/bin/flight service restart login-api
/opt/flight/bin/flight service restart file-manager-api
else
cat <<EOF 1>&2
================================================
Configure and start Login API
================================================
The login-api needs configuring and starting.
This can be done by running the following:
  /opt/flight/bin/flight config set web-suite.domain <DOMAIN>
  /opt/flight/bin/flight service start login-api

================================================
Configure and start File Manager API
================================================
The file-manager-api needs configuring and starting.
This can be done by running the following:
  /opt/flight/bin/flight config set web-suite.domain <DOMAIN>
  /opt/flight/bin/flight service start file-manager-api

EOF
fi
if [ ! -f "/opt/flight/etc/www/ssl/key.pem" ]; then
cat <<EOF 1>&2
================================================
HTTPS support needs to be enabled for flight-www
================================================
To enable HTTPS support run:
  /opt/flight/bin/flight www enable-https
  /opt/flight/bin/flight service restart www

EOF
fi

%changelog
* Fri Jun 25 2021 Ben Armston <ben.armston@alces-flight.com> - 2021.5-1
- Bump flight-file-manager-*, flight-login-api, flight-www and
  flight-job-script-*
- Update post installation script.
* Fri Jun 11 2021 Ben Armston <ben.armston@alces-flight.com> - 2021.4-1
- Bump flight-desktop-restapi, flight-file-manager-* and flight-job-script-*
* Thu Apr 29 2021 Ben Armston <ben.armston@alces-flight.com> - 2021.3-1
- Bump flight-console-*, flight-desktop-restapi, and flight-job-script-*
- Fix issue with the post installation script and service configuration.
* Wed Mar 24 2021 Ben Armston <ben.armston@alces-flight.com> - -
- Add flight-job-script-*
* Wed Mar 03 2021 Ben Armston <ben.armston@alces-flight.com> - 2021.1-1
- Bump flight-console-* and flight-desktop-* versions
- Add flight-file-manager-* and flight-login-api
* Tue Oct 20 2020 William McCumstie <william.mccumstie@alces-flight.com> - 2020.3-2
- Renamed the package to flight-web-suite
- Set the upper version number bounds to the next minor release
* Mon Oct 19 2020 William McCumstie <william.mccumstie@alces-flight.com> - 2020.3-1
- Bump flight-console-* versions to 1.0.0 and flight-desktop-restapi to 1.0.2
* Fri May 22 2020 Ben Armston <ben.armston@alces-flight.com> - 2020.2-1
- Added post installation and uninstallation scripts.
* Mon May 18 2020 Ben Armston <ben.armston@alces-flight.com> - 2020.2-0
- Initial Package
