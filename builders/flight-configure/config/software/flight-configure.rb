# NOTE: The following copyright header applies to this software file
COPYRIGHT_HEADER = <<~HEADER.chomp
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
HEADER

name 'flight-configure'
default_version '0.0.0'

source git: 'https://github.com/openflighthpc/flight-configure'

dependency 'enforce-flight-runway'
whitelist_file Regexp.new("vendor/ruby/.*\.so$")

license 'EPL-2.0'
license_file 'LICENSE.txt'
skip_transitive_dependency_licensing true

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # Moves the project into place
  [
    'Gemfile', 'Gemfile.lock', 'bin', 'etc', 'lib',
    'LICENSE.txt', 'README.md'
  ].each do |file|
    copy file, File.expand_path("#{install_dir}/#{file}/..")
  end

  # Installs the gems to the shared `vendor/share`
  flags = [
    "--without development test",
    '--path vendor'
  ].join(' ')
  command "cd #{install_dir} && /opt/flight/bin/bundle install #{flags}", env: env

  # Defines the flight specific applications
  block do
    File.write File.join(install_dir, 'etc', '10-flight.conf'), <<~CONF
#{COPYRIGHT_HEADER}

#===============================================================================
# Flight Ecosystem Configuration
# This document augments the base configuration to be compatible with the flight
# tool suite. It should not be updated directly as any changes maybe lost on
# the next update.
#
# Instead, installation specific configuration should be located in:
# 'etc/ZZ-overrides.conf'
#===============================================================================

#===============================================================================
# Program Configuration
# Set various program/CLI parameters
#===============================================================================
@_program_application = "#{project.friendly_name}"
@_program_name        = ENV.fetch("FLIGHT_PROGRAM_NAME", "flight configure")
@_program_description = "#{project.description}"
@_program_version     = "#{version}"

#===============================================================================
# Ensure flight_ROOT is set
# NOTE: This is not used internally
#===============================================================================
flight_root = ENV.fetch("flight_ROOT", '/opt/flight')

#===============================================================================
# Redefine paths to match flight-service
#===============================================================================
@applications_path  = File.join(flight_root, 'etc/service/types')
@data_path          = File.join(flight_root, 'var/lib/service')

#===============================================================================
# Enclude flight_ROOT in the subsystem calls
#===============================================================================
@script_env["flight_ROOT"] = flight_root

#===============================================================================
# Log into it's own directory
#===============================================================================
@log_dir = File.join(flight_root, "var/log/configure")
CONF
  end
end
