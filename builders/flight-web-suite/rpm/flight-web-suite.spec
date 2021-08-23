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
Requires:       flight-desktop-restapi => 2.4.0~, flight-desktop-restapi < 2.5.0~
Requires:       flight-desktop-webapp => 1.5.0~, flight-desktop-webapp < 1.5.0~
Requires:       flight-file-manager-api => 1.2.0, flight-file-manager-api < 1.3.0~
Requires:       flight-file-manager-webapp => 1.2.0, flight-file-manager-webapp < 1.3.0~
Requires:       flight-login-api => 1.1.0, flight-login-api < 1.2.0~
Requires:       flight-job-script-api => 1.4.0~, flight-job-script-api < 1.5.0~
Requires:       flight-job-script-webapp => 1.3.0, flight-job-script-webapp < 1.4.0~
Requires:       flight-www => 1.6.0, flight-www < 1.7.0~
Requires:       flight-headnode-landing-page < 1.4.0~
Requires:       flight-web-suite-utils => 1.1.0 flight-web-suite-utils < 1.2.0~

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
if [ "$1" == "2" ] ; then
  # An existing installation is being upgraded.  Each service should restart
  # itself.  We have nothing to do.
  :
else
  # The package is being installed not upgraded.  Let's detail what to do
  # next.
  cat <<EOF 1>&2

================================================
Configure and start Flight Web Suite
================================================

Flight Web Suite needs configuring and starting.  You will need to configure
the domain for the web suite to use; generate an SSL certificate; and then
start and enable the web suite services.  The commands below detail how to do
so.  By default they will generate a self-signed certificate.

  /opt/flight/bin/flight web-suite set-domain <DOMAIN>
  /opt/flight/bin/flight web-suite start
  /opt/flight/bin/flight web-suite enable

You can alternatively generate a Let's Encrypt certificate by running the
following:

  /opt/flight/bin/flight web-suite set-domain <DOMAIN> --cert-type letsencrypt --email <YOUR EMAIL ADDRESS>
  /opt/flight/bin/flight web-suite start
  /opt/flight/bin/flight web-suite enable

EOF
  fi

%changelog
* Mon Aug 23 2021 Ben Armston <ben.armston@alces-flight.com> - 2021.6-1
- Bump flight-console-webapp, flight-desktop-*, flight-file-manager-*,
  flight-job-script-* and flight-web-suite-utils.
- Update post installation script.
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
