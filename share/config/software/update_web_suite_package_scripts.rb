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
#!/bin/sh
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


build do
  block do
    # Extract information about the project
    root_dir = File.expand_path('../../..', project.filepath)
    service = project.name.sub(/\Aflight-/, '')

    # Define the script paths
    rendered = {}
    paths = {
      postinst: File.join(root_dir, 'package-scripts', project.name, 'postinst'),
      prerm:    File.join(root_dir, 'package-scripts', project.name, 'prerm'),
      postrm:   File.join(root_dir, 'package-scripts', project.name, 'postrm')
    }

    # Render the postinst script
    configure_script = File.join(project.package_scripts_path, 'postinst-configure')
    configure = if File.exists? configure_script
                  File.read(configure_script).chomp
                else
                  "/opt/flight/bin/flight service configure --force #{service} >/dev/null 2>&1"
                end

    rendered[:postinst] = <<~POSTINST
      #{HEADER}
      # Run the configuration
      #{configure}

      # Check if the service is already running and restart it
      if /opt/flight/bin/flight service status #{service} | grep active >/dev/null 2>&1 ; then
        /opt/flight/bin/flight service restart #{service} >/dev/null 2>&1
      fi

      # Reload flight-www to pick up the new config
      /opt/flight/bin/flight service reload www 1>/dev/null 2>&1

      exit 0
    POSTINST

    # Render the prerm script
    rendered[:prerm] = <<~PRERM
      #{HEADER}
      # On "uninstall" the $1 variable will be either "0" (rpm) or "remove" (deb)
      if [ "$1" == "0" ] || [ "$1" == "remove" ]; then
        # Stop the service
        /opt/flight/bin/flight service stop #{service} >/dev/null 2>&1
      fi

      exit 0
    PRERM

    # Render postrm
    rendered[:postrm] = <<~POSTRM
      #{HEADER}
      # On "uninstall" the $1 variable will be either "0" (rpm) or "remove" (deb)
      if [ "$1" == "0" ] || [ "$1" == "remove" ]; then
        # Reload flight-www to remove the proxy configuration
        /opt/flight/bin/flight service reload www 1>/dev/null 2>&1
      fi

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

    # Crash the build and prompt for the new files to be checked in!
    # This helps ensure the updated version is in the repo and picked up
    unless updated.empty?
      raise <<~ERROR
        The following puma scripts have been modified! Please check them in and restart the build.

        #{updated.join("\n")}
      ERROR
    end
  end
end

