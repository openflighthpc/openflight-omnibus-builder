Name:           flight-plugin-system-cron
Version:        %{_flight_pkg_version}
Release:        %{_flight_pkg_rel}
Summary:        Provides cron integration for OpenFlight tools

Group:          OpenFlight/Environment
License:        EPL-2.0

URL:            https://openflighthpc.org
%undefine _disable_source_fetch
Source0:        https://raw.githubusercontent.com/openflighthpc/openflight-omnibus-builder/master/LICENSE.txt
Source1:        https://raw.githubusercontent.com/openflighthpc/openflight-omnibus-builder/master/builders/flight-plugin-cron/dist/crontab-generator
Source2:        https://raw.githubusercontent.com/openflighthpc/openflight-omnibus-builder/master/builders/flight-plugin-cron/dist/crontab.reboot
Source3:        https://raw.githubusercontent.com/openflighthpc/openflight-omnibus-builder/master/builders/flight-plugin-cron/dist/crontab-generator.cron.hourly.tpl
Source4:        https://raw.githubusercontent.com/openflighthpc/openflight-omnibus-builder/master/builders/flight-plugin-cron/dist/crontab.schedule.tpl

BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildArch:      noarch
Provides:       flight-cron-system-1.0
Provides:       flight-plugin-cron
Requires:       cronie
Conflicts:      flight-plugin-manual-cron

%description
Provides cron integration for OpenFlight tools

%prep
%setup -q -c -T
install -pm 644 %{SOURCE0} .
install -pm 644 %{SOURCE1} .
install -pm 644 %{SOURCE2} .
install -pm 644 %{SOURCE3} .
install -pm 644 %{SOURCE4} .

%build

%install
rm -rf $RPM_BUILD_ROOT
install -p -m 644 %{SOURCE0} LICENSE.txt
mkdir -p $RPM_BUILD_ROOT/opt/flight/libexec/cron
install -p -m 750 %{SOURCE1} $RPM_BUILD_ROOT/opt/flight/libexec/cron/crontab-generator
mkdir -p $RPM_BUILD_ROOT/opt/flight/etc/cron.d
install -p -m 644 %{SOURCE2} $RPM_BUILD_ROOT/opt/flight/etc/cron.d/openflight-reboot
mkdir -p $RPM_BUILD_ROOT/opt/flight/etc/cron/reboot
for a in hourly daily weekly monthly; do
  mkdir -p $RPM_BUILD_ROOT/opt/flight/etc/cron/$a
  mkdir -p $RPM_BUILD_ROOT/etc/cron.$a
  sed -e "s/%SCHEDULE%/$a/g" %{SOURCE4} > $RPM_BUILD_ROOT/etc/cron.$a/openflight-$a
done
sed -e 's,%TARGET%,/etc/cron.d/openflight,g' %{SOURCE3} > $RPM_BUILD_ROOT/opt/flight/etc/cron/hourly/crontab-generator
chmod 750 $RPM_BUILD_ROOT/opt/flight/etc/cron/hourly/crontab-generator

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%license LICENSE.txt
/opt/flight/libexec/cron/crontab-generator
/opt/flight/etc/cron.d/openflight-reboot

/etc/cron.hourly/openflight-hourly
/etc/cron.daily/openflight-daily
/etc/cron.weekly/openflight-weekly
/etc/cron.monthly/openflight-monthly

/opt/flight/etc/cron/hourly/crontab-generator
/opt/flight/etc/cron/daily
/opt/flight/etc/cron/weekly
/opt/flight/etc/cron/monthly
/opt/flight/etc/cron/reboot

%post
/opt/flight/libexec/cron/crontab-generator /etc/cron.d/openflight

%postun
if [ "$1" == 0 ]; then
  rm -f /etc/cron.d/openflight
fi

%changelog
* Fri Jun 26 2020 Mark J. Titorenko <mark.titorenko@alces-flight.com> - 1.0.0
- Initial Package
