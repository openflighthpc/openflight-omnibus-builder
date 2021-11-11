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

  [
    'Gemfile', 'Gemfile.lock', 'bin/job', 'lib', 'config', 'LICENSE.txt', 'README.md',
  ].each do |file|
    copy file, File.expand_path("#{install_dir}/#{file}/..")
  end

  # Update the config
  block do
    slurm_dir = "/opt/flight/libexec/job/slurm"
    block do
      FileUtils.rm_rf slurm_dir
      FileUtils.mkdir_p slurm_dir
    end
    copy 'libexec/job/slurm', File.expand_path('..', slurm_dir)
    Find.find(File.join(project_dir, 'libexec/job/slurm')) do |f|
      if File.file?(f)
        $stdout.puts "Found slurm script #{File.basename(f)}"
        install_path = File.join(slurm_dir, File.basename(f))
        project.extra_package_file(install_path)
      end
    end

    state_maps_dir = '/opt/flight/etc/job/state-maps'
    block do
      FileUtils.rm_rf state_maps_dir
      FileUtils.mkdir_p state_maps_dir
    end
    Dir.glob(File.join(project_dir, 'etc/job/state-maps/*')).each do |file|
      copy file, state_maps_dir
    end
    block do
      Find.find(state_maps_dir).each do |file|
        next unless File.file?(file)
        $stdout.puts "Found state map file: #{file}"
        project.extra_package_file file
      end
    end

    adapters_dir = "/opt/flight/usr/share/job"
    block do
      FileUtils.rm_rf adapters_dir
      FileUtils.mkdir_p adapters_dir
    end
    Dir.glob(File.join(project_dir, 'usr/share/job/adapter.*.erb')).each do |file|
      copy file, adapters_dir
    end
    block do
      Find.find(adapters_dir).each do |path|
        next unless File.file?(path)
        next unless path =~ /adapter\..*\.erb/
        $stdout.puts "Found adapter file: #{path}"
        project.extra_package_file path
      end
    end

    templates_dir = "/opt/flight/usr/share/job/templates"
    block do
      FileUtils.rm_rf templates_dir
      FileUtils.mkdir_p templates_dir
    end
    Dir.glob(File.join(project_dir, 'usr/share/job/templates/*')).each do |dir|
      basename = File.basename(dir)
      copy File.join('usr/share/job/templates', basename), templates_dir
    end
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
