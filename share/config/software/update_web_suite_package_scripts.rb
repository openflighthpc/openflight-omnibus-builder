#==============================================================================
# Copyright (C) 2021-present Alces Flight Ltd.
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
HEADER = <<~HEADER
#!/bin/bash
#==============================================================================
# Copyright (C) 2021-present Alces Flight Ltd.
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

# NOTE: This file is managed by 'update_web_suite_package_scripts' software
#       definition. Any changes will be lost on the next build.
HEADER

name 'update_web_suite_package_scripts'
default_version '1.0.0'

license :project_license
skip_transitive_dependency_licensing true

# NOTE: The scripts are intentionally re-rendered on every build to prevent
# them being skipped by the cache
build do
  # Extract information about the project
  service = project.name.sub(/\Aflight-/, '')

  # Define the script paths
  rendered = {}
  paths = {
    postinst: File.join(project.package_scripts_path, 'postinst'),
    prerm:    File.join(project.package_scripts_path, 'prerm'),
    postrm:   File.join(project.package_scripts_path, 'postrm')
  }

  # Render the postinst script
  configure_script = File.join(project.package_scripts_path, 'stubs/postinst-configure')
  configure = if File.exists? configure_script
                File.read(configure_script).chomp
              else
                "${flight_ROOT}/bin/flight service configure #{service} --force --config '{}' >/dev/null 2>&1"
              end

  rendered[:postinst] = <<~POSTINST
    #{HEADER}
    # Ensure flight_ROOT is set correctly
    flight_ROOT=/opt/flight

    # Run the configuration
    #{configure}

    # Check if the service is already running and restart it
    if ${flight_ROOT}/bin/flight service status #{service} | grep -q active ; then
      ${flight_ROOT}/bin/flight service restart #{service}
    fi

    # Reload flight-www to pick up the new config
    ${flight_ROOT}/bin/flight service reload www >/dev/null 2>&1

    exit 0
  POSTINST

  # Render the prerm script
  # NOTE: At the time of writing, `flight-www` has a similar script to this.
  # Any changes made here will likely need to be duplicated
  rendered[:prerm] = <<~PRERM
    #{HEADER}
    # Ensure flight_ROOT is set correctly
    flight_ROOT=/opt/flight

    # On "uninstall" the $1 variable will be either "0" (rpm) or "remove" (deb)
    if [ "$1" == "0" -o "$1" == "remove" ]; then
      # Stop the service
      ${flight_ROOT}/bin/flight service stop #{service}
    fi

    exit 0
  PRERM

  # Render postrm
  rendered[:postrm] = <<~POSTRM
    #{HEADER}
    # Ensure flight_ROOT is set correctly
    flight_ROOT=/opt/flight

    # Reload flight-www to remove the proxy configuration
    ${flight_ROOT}/bin/flight service reload www >/dev/null 2>&1

    exit 0
  POSTRM

  # Ensure all the scripts are up to date
  updated = []
  paths.each do |type, path|
    new = rendered[type]
    old = (File.exists?(path) ? File.read(path) : '')
    unless old == new
      updated << path
      FileUtils.mkdir_p File.dirname(path)
      File.write path, new
      FileUtils.chmod 0644, path
    end
  end
end
