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
name "enforce-flight-runway"
default_version "0.0.0"

Dir.mktmpdir do |tmpdir|
  source path: tmpdir
end


build do
  block do
    version_file = '/opt/flight/opt/runway/version-manifest.json'
    raise "Flight Runway is not installed!" unless File.exists?(version_file)

    cur = Gem::Version.new JSON.parse(File.read(version_file))["build_version"]

    gte = Gem::Version.new overrides[:flight_version_gte]
    lt = Gem::Version.new overrides[:flight_version_lt]

    raise <<~ERROR.chomp if cur < gte
      Flight Runway is to old!
      Requires >= #{gte.to_s}
      Got       = #{cur.to_s}
    ERROR

    raise <<~ERROR.chomp if cur >= lt
      Flight Runway is to new!
      Requires < #{lt.to_s}
      Got:     = #{cur.to_s}
    ERROR
  end
end
