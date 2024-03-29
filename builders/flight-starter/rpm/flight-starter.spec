Name:           flight-starter
Version:        %{_flight_pkg_version}
Release:        %{_flight_pkg_rel}%{?dist}
Summary:        Profile scripts and infrastructure for activating an OpenFlight HPC environment

Group:          OpenFlight/Environment
License:        EPL-2.0

URL:            https://openflighthpc.org
%undefine _disable_source_fetch
Source0:        https://github.com/openflighthpc/%{name}/archive/%{_flight_pkg_tag}.tar.gz

BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildArch:      noarch
Requires:       flight-runway, flight-starter-banner => %{_flight_pkg_now}.0~, flight-starter-banner < %{_flight_pkg_next}.0~, flight-starter-system-1.0
%{?el8:Recommends:    flight-plugin-system-starter}

# Required in the post install script
Requires:       diffutils

%description
Profile scripts and infrastructure for activating an OpenFlight HPC environment

%prep
%setup -q -n %{name}-%{_flight_pkg_tag}

%build


%install
cp -R dist/* $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/opt/flight/etc/plugin/xdg
mkdir -p $RPM_BUILD_ROOT/opt/flight/etc/plugin/profile.d
install -p -m 644 $RPM_BUILD_ROOT/etc/profile.d/zz-flight-starter.sh $RPM_BUILD_ROOT/opt/flight/etc/plugin/profile.d/flight-starter.sh
install -p -m 644 $RPM_BUILD_ROOT/etc/profile.d/zz-flight-starter.csh $RPM_BUILD_ROOT/opt/flight/etc/plugin/profile.d/flight-starter.csh
install -p -m 644 $RPM_BUILD_ROOT/etc/xdg/flight.rc $RPM_BUILD_ROOT/opt/flight/etc/plugin/xdg
install -p -m 644 $RPM_BUILD_ROOT/etc/xdg/flight.cshrc $RPM_BUILD_ROOT/opt/flight/etc/plugin/xdg

%clean
#rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%license LICENSE.txt
/opt/flight/etc/banner/banner.d/*
/opt/flight/etc/banner/tips.d/*
%config(noreplace) /opt/flight/etc/setup-sshkey.rc
/opt/flight/etc/flight-config-map.d/*
/opt/flight/etc/profile.d/*
/opt/flight/etc/settings.d/*
/opt/flight/etc/setup.sh
/opt/flight/etc/setup.csh
/opt/flight/libexec/commands/*
%dir /opt/flight/libexec/flight-starter/
/opt/flight/libexec/flight-starter/*
%dir /opt/flight/lib/flight-starter-patches/
/opt/flight/lib/flight-starter-patches/*
%exclude /opt/flight/libexec/flight-starter/banner

%post
old=/opt/flight/etc/flight-config-map.yml
new=/opt/flight/etc/flight-config-map.d/zz-cluster.yml
sys=/opt/flight/etc/flight-config-map.d/cluster.yml
if [ -e "$old" ]; then
  if cmp "$old" "$sys" >/dev/null; then
    rm -f "$old"
  else
    mv "$old" "$new"
  fi
fi

%changelog
* Tue Apr 25 2023 Jack Millard <jack.millard@alces-flight.com> - 2023.1.0
- Updated to 2023.1.0
* Tue Oct  4 2022 Jack Millard <jack.millard@alces-flight.com> - 2022.4.1
- Updated to 2022.4.1
* Thu May 19 2022 Ben Armston <ben.armston@alces-flight.com> - 2022.3.0
- Updated to 2022.3.0
* Fri Apr  1 2022 Ben Armston <ben.armston@alces-flight.com> - 2022.2.0
- Updated to 2022.2.0
* Mon Mar  7 2022 Ben Armston <ben.armston@alces-flight.com> - 2022.1.0
- Updated to 2022.1.0
* Thu Nov 25 2021 Ben Armston <ben.armston@alces-flight.com> - 2021.9.0
- Updated to 2021.9.0
* Thu Nov 11 2021 Ben Armston <ben.armston@alces-flight.com> - 2021.8.0
- Updated to 2021.8.0
* Tue Sep 14 2021 Ben Armston <ben.armston@alces-flight.com> - 2021.7.0
- Updated to 2021.7.0
* Fri Jun 11 2021 Ben Armston <ben.armston@alces-flight.com> - 2021.4.0
- Updated to 2021.4.0
* Thu Apr 29 2021 Ben Armston <ben.armston@alces-flight.com> - 2021.3.0
- Updated to 2021.3.0
* Wed Jun 24 2020 Mark J. Titorenko <mark.titorenko@alces-flight.com> - 2020.2.x
- Reworked to use plugin approach
* Tue Apr 28 2020 Mark J. Titorenko <mark.titorenko@alces-flight.com> - 2020.2.2
- Updated to 2020.2.2
- Only execute banner script under interactive shells
* Tue Apr 14 2020 Mark J. Titorenko <mark.titorenko@alces-flight.com> - 2020.2.1
- Updated to 2020.2.1
- Additional robustness when "nounset" shell option is used
* Wed Apr  8 2020 Stu Franks <stu.franks@openflighthpc.org> - 2020.2.0
- Updated to 2020.2.0
* Thu Apr  2 2020 Mark J. Titorenko <mark.titorenko@alces-flight.com> - 2020.1.3
- Updated to 2020.1.3
- Support /etc/lsb-release if /etc/redhat-release not present
* Thu Mar 12 2020 Mark J. Titorenko <mark.titorenko@alces-flight.com> - 2020.1.2
- Updated to 2020.1.2
- Added sourceable setup scripts for use in job scripts
* Mon Dec 16 2019 Stu Franks <stu.franks@openflighthpc.org> - 2020.1.1
- Updated to 2020.1.1
* Wed Dec 11 2019 Mark J. Titorenko <mark.titorenko@alces-flight.com> - 2020.1.0
- Updated numbering scheme
- Updated to 2020.1.0
* Mon Nov  4 2019 Mark J. Titorenko <mark.titorenko@alces-flight.com> - 1.2.1
- Updated to v1.2.1
* Mon Oct 28 2019 Mark J. Titorenko <mark.titorenko@alces-flight.com> - 1.2.0
- Updated to v1.2.0
* Tue Oct  8 2019 Mark J. Titorenko <mark.titorenko@alces-flight.com> - 1.1.1
- Updated to v1.1.1
* Fri Oct  4 2019 Mark J. Titorenko <mark.titorenko@alces-flight.com> - 1.1.0
- Initial Package

%package -n flight-plugin-system-starter
Summary: Provides profile script integration for Flight Starter
Release: %{_flight_pkg_rel}
Requires: flight-starter
Requires: setup
Provides: flight-starter-system-1.0
Conflicts: flight-plugin-manual-starter
%description -n flight-plugin-system-starter
Provides profile script integration for Flight Starter
%files -n flight-plugin-system-starter
%config(noreplace) %{_sysconfdir}/xdg/*
%{_sysconfdir}/profile.d/*

%package -n flight-plugin-manual-starter
Summary: Provides manually managed profile script integration for Flight Starter
Release: %{_flight_pkg_rel}
Requires: flight-starter
Provides: flight-starter-system-1.0
Conflicts: flight-plugin-system-starter
%description -n flight-plugin-manual-starter
Provides manually managed profile script integration for Flight Starter
%files -n flight-plugin-manual-starter
%config(noreplace) /opt/flight/etc/plugin/xdg/*
/opt/flight/etc/plugin/profile.d/*

%package banner
Summary: OpenFlightHPC branded banner for Flight Starter
Release: %{_flight_pkg_rel}
Requires: flight-starter
Provides: flight-starter-banner-system-1.0
%description banner
OpenFlightHPC branded banner for Flight Starter
%files banner
%defattr(-,root,root,-)
%license LICENSE.txt
%config(noreplace) /opt/flight/etc/flight-starter.rc
%config(noreplace) /opt/flight/etc/flight-starter.cshrc
/opt/flight/etc/banner/banner.erb
/opt/flight/etc/banner/banner.txt
/opt/flight/etc/banner/banner.yml
/opt/flight/libexec/flight-starter/banner
