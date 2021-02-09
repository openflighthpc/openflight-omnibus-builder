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
name "enforce-flight-nodejs"
description "enforce existence of flight-nodejs"
default_version "1.0.0"

license :project_license
skip_transitive_dependency_licensing true

build do
  block do
    raise "Flight NodeJS is not installed!" if ! File.exists?('/opt/flight/bin/yarn')
    nodejs_version = `/opt/flight/bin/node --version`.chomp
    major, minor, _patch = nodejs_version.sub(/^v/, '').split('.')
    if major.to_i < 14
      raise "Flight NodeJS has incorrect version: #{nodejs_version} (expected 14.15.x)"
    elsif major.to_i == 14 && minor.to_i < 15
      raise "Flight NodeJS has incorrect version: #{nodejs_version} (expected 14.15.x)"
    end
  end
end
