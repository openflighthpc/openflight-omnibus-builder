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
PUMA_COPY_RIGHT_HEADER = <<~HEADER
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
HEADER

name 'update_puma_scripts'
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
      start: File.join('/opt/flight/etc/service/types', service, 'start.sh'),
      start_bin: File.join(install_dir, 'bin/start'),
      stop: File.join('/opt/flight/etc/service/types', service, 'stop.sh'),
      restart: File.join('/opt/flight/etc/service/types', service, 'restart.sh'),
      reload: File.join('/opt/flight/etc/service/types', service, 'reload.sh')
    }

    # Render the start script
    rendered[:start] = <<~START
      #!/bin/bash
      #{PUMA_COPY_RIGHT_HEADER}
      set -e

      # Required to correctly handle output parsing.
      if [ -f /etc/locale.conf ]; then
        . /etc/locale.conf
      fi
      export LANG=${LANG:-en_US.UTF-8}

      # Create the temporary PID file
      pidfile=$(mktemp /tmp/flight-#{service}-deletable.XXXXXXXX.pid)
      rm "${pidfile}"

      tool_bg #{paths[:start_bin]} "$pidfile"

      # Wait up to 10ish seconds for puma to start
      for _ in `seq 1 20`; do
        sleep 0.5
        if [ -f "$pidfile" ]; then
          pid=$(cat "$pidfile" | tr -d "\\n")
        fi
        if [ -n "$pid" ]; then
          break
        fi
      done

      # Ensure the pidfile is removed
      rm -f "$pidfile"

      # Report back the pid or error
      if [ -n "$pid" ]; then
        # Wait a second to ensure puma is still running
        sleep 1
        kill -0 "$pid" 2>/dev/null
        if [ "$?" -ne 0 ]; then
          echo Failed to start #{service} >&2
          exit 2
        fi

        tool_set pid=$pid
      else
        echo Failed to start #{service} >&2
        exit 1
      fi
    START

    # Render the start bin
    rendered[:start_bin] = <<~START_BIN
      #!/bin/bash
      #{PUMA_COPY_RIGHT_HEADER}

      pid_file="$1"
      if [ -z "$pid_file" ]; then
        echo "The pid_file argument has not been provided!" >&2
        exit 1
      fi
      if [ -z "$flight_ROOT" ]; then
        echo "flight_ROOT has not been set!" >&2
        exit 1
      fi
      if [ -z "$PUMA_LOG_FILE" ]; then
        echo "PUMA_LOG_FILE has not been set!" >&2
        exit 1
      fi

      # Ensure the log directory exists
      mkdir -p $(dirname "$PUMA_LOG_FILE")

      # Exec into the ruby/puma process so the PID does not change
      exec "${flight_ROOT}"/bin/flexec ruby #{install_dir}/bin/puma \\
        --config #{install_dir}/config/puma.rb \\
        --pidfile "$pid_file" \\
        --redirect-stdout "$PUMA_LOG_FILE" \\
        --redirect-stderr "$PUMA_LOG_FILE" \\
        --redirect-append \\
        --dir #{install_dir} \\
        >>"${PUMA_LOG_FILE}" 2>&1
    START_BIN

    # Render the stop script
    rendered[:stop] = <<~STOP
      #!/bin/bash
      #{PUMA_COPY_RIGHT_HEADER}

      pid_file="$1"
      if [ -z "$pid_file" ]; then
        echo "The pid_file argument has not been provided!" >&2
        exit 1
      fi
      if [ -z "$flight_ROOT" ]; then
        echo "flight_ROOT has not been set!" >&2
        exit 1
      fi
      if [ -z "$PUMA_LOG_FILE" ]; then
        echo "PUMA_LOG_FILE has not been set!" >&2
        exit 1
      fi

      # Ensure the log directory exists
      mkdir -p $(dirname "$PUMA_LOG_FILE")

      # Stop puma
      "${flight_root}"/bin/flexec ruby #{install_dir}/bin/pumactl stop \\
        --pidfile $1 \\
        --config-file #{install_dir}/config/puma.rb \\
        >>"$PUMA_LOG_FILE" 2>&1
    STOP

    # Render the restart script
    rendered[:restart] = <<~RESTART
      #!/bin/bash
      #{PUMA_COPY_RIGHT_HEADER}

      OLD_PID="$1"

      #{paths[:stop]} "$OLD_PID"

      # Wait up to 10ish seconds for puma to stop
      state=1
      for _ in `seq 1 20`; do
        kill -0 "$OLD_PID" 2>/dev/null
        state=$?
        if [ "$state" -ne 0 ]; then
          break
        fi
      done

      if [ "$state" -eq 0 ]; then
        echo Failed to stop #{service}
        exit 1
      fi

      #{paths[:start]}
    RESTART

    # Render the reload script
    rendered[:reload] = <<~RELOAD
      #!/bin/bash
      #{PUMA_COPY_RIGHT_HEADER}

      pid_file="$1"
      if [ -z "$pid_file" ]; then
        echo "The pid_file argument has not been provided!" >&2
        exit 1
      fi
      if [ -z "$flight_ROOT" ]; then
        echo "flight_ROOT has not been set!" >&2
        exit 1
      fi
      if [ -z "$PUMA_LOG_FILE" ]; then
        echo "PUMA_LOG_FILE has not been set!" >&2
        exit 1
      fi

      # Ensure the log directory exists
      mkdir -p $(dirname "$PUMA_LOG_FILE")

      # Restarts the puma worker processes
      "${flight_root}"/bin/flexec ruby #{install_dir}/bin/pumactl restart \\
        --pidfile $1 \\
        --config-file #{install_dir}/config/puma.rb \\
        >>"$PUMA_LOG_FILE" 2>&1

      # Sleeps two seconds and ensure puma is still running
      sleep 2
      kill -0 "$(cat "$pid_file")" 2>/dev/null
      if [ "$?" -ne 0]; then
        echo Failed to reload #{service} >&2
        exit 2
      fi

      # Ensures the PID remains set (it hasn't changed)
      tool_set pid=$(cat "$pid_file")
    RELOAD

    # Ensure all the scripts are up to date
    updated = []
    [:start, :start_bin, :stop, :restart, :reload].each do |type|
      path = File.join(root_dir, paths[type])
      new = rendered[type]
      old = (File.exists?(path) ? File.read(path) : '')
      unless old == new
        updated << path
        FileUtils.mkdir_p File.dirname(path)
        File.write path, new
        FileUtils.chmod 0775, path
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
