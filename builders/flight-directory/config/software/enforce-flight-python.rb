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

name "enforce-flight-python"
description "enforce existence of flight-python"

# NOTE: This needs to match the MAJOR.MINOR version of flight-python
default_version "0.0"

license :project_license
skip_transitive_dependency_licensing true

build do
  raise "Flight Python is not installed!" if ! File.exists?('/opt/flight/bin/python3')
  python_system = `/opt/flight/bin/python3 --version`.chomp.split(' ').last.gsub(/\.\d+\Z/, '')
  unless python_system == version
    raise "Flight Python has the incorrect system version: #{python_system} (expected #{version})"
  end
end
