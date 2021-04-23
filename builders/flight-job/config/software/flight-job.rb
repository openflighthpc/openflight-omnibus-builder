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
require 'ostruct'
require 'find'

name 'flight-job'
default_version '0.0.0'

source git: 'https://github.com/openflighthpc/flight-job'

dependency 'flight-runway'
whitelist_file Regexp.new("vendor/ruby/.*\.so$")

license 'EPL-2.0'
license_file 'LICENSE.txt'
skip_transitive_dependency_licensing true

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # Moves the project into place
  block do
    FileUtils.mkdir_p File.join(install_dir, 'etc')
  end
  [
    'Gemfile', 'Gemfile.lock', 'bin/job', 'lib', 'LICENSE.txt', 'README.md',
    'etc/flight-job.yaml'
  ].each do |file|
    copy file, File.expand_path("#{install_dir}/#{file}/..")
  end

  # Update the config
  block do
    path = File.join(install_dir, 'etc/flight-job.yaml')
    templates_dir = "/opt/flight/usr/share/job/templates"
    slurm_dir = "/opt/flight/libexec/job/slurm"
    check_cron = '/opt/flight/libexec/job/check-cron.sh'
    mapping_path = '/opt/flight/etc/job/state-maps/flight-slurm.yaml'
    content = [
      File.read(path),
      "state_map_path: #{mapping_path}",
      "submit_script_path: /opt/flight/libexec/job/flight-slurm/submit.sh",
      "monitor_script_path: /opt/flight/libexec/job/flight-slurm/monitor.sh",
      "templates_dir: #{templates_dir}",
      "check_cron: #{check_cron}",
      ''
    ].join("\n")
    File.write path, content

    # Cleanup and move check-cron.sh into place
    block do
      FileUtils.rm_rf File.dirname(check_cron)
      FileUtils.mkdir_p File.dirname(check_cron)
    end
    copy 'libexec/check-cron.sh', check_cron
    project.extra_package_file check_cron

    # Cleanup and move the mapping file into place
    block do
      FileUtils.rm_rf File.dirname(mapping_path)
      FileUtils.mkdir_p File.dirname(mapping_path)
    end
    copy 'etc/state-maps/slurm.yaml', mapping_path
    project.extra_package_file mapping_path

    # Cleanup the initial state of the slurm dir
    block do
      FileUtils.rm_rf slurm_dir
      FileUtils.mkdir_p slurm_dir
    end

    # Copy the slurm scripts into place
    copy 'libexec/slurm', File.expand_path('..', slurm_dir)
    Find.find(File.join(project_dir, 'libexec/slurm')) do |f|
      if File.file?(f)
        $stdout.puts "Found slurm script #{File.basename(f)}"
        install_path = File.join(slurm_dir, File.basename(f))
        project.extra_package_file(install_path)
      end
    end

    # Cleanup the initial state of the templates directory
    block do
      FileUtils.rm_rf templates_dir
      FileUtils.mkdir_p templates_dir
    end

    # Copy the example templates into place
    Dir.glob(File.join(project_dir, 'usr/share/*')).each do |dir|
      basename = File.basename(dir)
      copy File.join('usr/share', basename), templates_dir
    end

    # Flag the entire templates dir as package files
    block do
      Find.find(templates_dir).each do |path|
        next unless File.file?(path)
        $stdout.puts "Found template file: #{path}"
        project.extra_package_file path
      end
    end
  end

  # Installs the gems to the shared `vendor/share`
  flags = [
    '--with default',
    "--without development test",
    '--path vendor'
  ].join(' ')
  command "cd #{install_dir} && /opt/flight/bin/bundle install #{flags}", env: env
end
