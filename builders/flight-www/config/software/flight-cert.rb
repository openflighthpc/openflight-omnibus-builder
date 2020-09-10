#==============================================================================
# Copyright (C) 2019-present Alces Flight Ltd.
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
name 'flight-cert'
default_version '0.0.0'

source git: 'https://github.com/openflighthpc/flight-cert'

dependency 'enforce-flight-runway'

license 'EPL-2.0'
license_file 'LICENSE.txt'
skip_transitive_dependency_licensing true

whitelist_file Regexp.new("vendor/ruby/.*\.so$")

build do
  env = with_standard_compiler_flags(with_embedded_path)
  sub_install_dir = File.join(install_dir, 'cert')

  # Moves the project into place
  block do
    # Creates the sub install directory
    FileUtils.mkdir_p sub_install_dir
    [
      'Gemfile', 'Gemfile.lock', 'bin', 'lib', 'LICENSE.txt', 'README.md'
    ].each do |file|
      FileUtils.cp_r File.expand_path(file, project_dir), sub_install_dir
    end

    # Links the internal config to the system version
    FileUtils.mkdir_p File.expand_path('etc', sub_install_dir)
    FileUtils.ln_sf '/opt/flight/etc/share/www.yaml', File.expand_path('etc/config.yaml', sub_install_dir)
  end

  # Defines the context the reference template will be rendered in
  context = OpenStruct.new(
    program: <<~CONF,
      config :program_name,         default: ENV.fetch('FLIGHT_PROGRAM_NAME', 'flight www')
      config :program_application,  default: '#{project.friendly_name}'
      config :program_description,  default: '#{project.description}'
    CONF
    selfsigned_dir: <<~CONF,
      config :selfsigned_dir, default: '/opt/flight/etc/www/self-signed'
    CONF
    ssl_paths: <<~CONF,
      config :ssl_fullchain,  default: '/opt/flight/etc/www/ssl/fullchain.pem'
      config :ssl_privkey,    default: '/opt/flight/etc/www/ssl/key.pem'
    CONF
    letsencrypt_live_dir: <<~CONF,
      config :letsencrypt_live_dir, default: '/opt/flight/etc/letsencrypt/live'
    CONF
    certbot: <<~CONF,
      config :certbot_bin,  default: '/opt/flight/opt/certbot/bin/certbot'
      config :certbot_plugin_flags, default: '--nginx --nginx-ctl /opt/flight/opt/www/embedded/sbin/nginx --nginx-server-root /opt/flight/etc/www --config-dir /opt/flight/etc/letsencrypt --logs-dir /opt/flight/var/log/letsencrypt --work-dir /opt/flight/var/lib/letsencrypt'
    CONF
    cron: <<~CONF,
      config :cron_path,    default: '/opt/flight/etc/cron/weekly/flight-www-auto-cert-renewal'
      config :cron_script,  default: <<~SCRIPT
        #!/bin/bash
        /opt/flight/bin/flight www cert-gen
      SCRIPT
    CONF
    https_enable_paths: <<~CONF,
      config :https_enable_paths, default: [
        '/opt/flight/etc/www/http.d/https.conf',
        '/opt/flight/etc/www/server-http.d/redirect-http-to-https.conf'
      ]
    CONF
    status_command: <<~CONF,
      config :status_command, default: '/opt/flight/bin/flight service status www | grep active'
    CONF
    restart_command: <<~CONF,
      config :restart_command, default: '/opt/flight/bin/flight service restart www | grep "service has been restarted"'
    CONF
    start_command_prompt: <<~CONF,
      config :start_command_prompt, default: '/opt/flight/bin/flight service start www'
    CONF
    log_path: <<~CONF
      config :log_path, default: '/opt/flight/var/log/cert/cert.log'
    CONF
  ).instance_exec { self.binding }

  # Renders the reference into the project directory
  rendered_path = 'etc/config.reference.rendered'
  block do
    template = File.read(File.join(project_dir, 'etc/config.reference')).gsub(/^#<%/, '<%')
    reference = ERB.new(template, nil, '-').result(context)
    File.write(File.join(project_dir, rendered_path), reference)
  end

  # Installs the rendered reference config
  mkdir File.expand_path('etc', sub_install_dir)
  copy rendered_path, File.expand_path('etc/config.reference', sub_install_dir)

  # Installs the gems to the shared `vendor/share`
  flags = [
    '--with default',
    "--without development test",
    '--path vendor'
  ].join(' ')
  command "cd #{sub_install_dir} && /opt/flight/bin/bundle install #{flags}", env: env
end
