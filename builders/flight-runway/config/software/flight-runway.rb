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
name "flight-runway"
default_version '0.0.0'

source git: 'https://github.com/openflighthpc/flight-runway'

dependency "ruby"
dependency "rb-readline"
dependency "bundler"
dependency 'paint-gem'

license 'EPL-2.0'
license_file 'LICENSE.txt'
skip_transitive_dependency_licensing true

build do
  [
    'pkg/bin',
    'pkg/dist'
  ].each do |path|
    copy(
      path,
      File.expand_path(install_dir),
      preserve: true
    )
  end

  [
    'pkg/ruby/openflight',
    'pkg/ruby/openflight.rb'
  ].each do |path|
    copy(
      path,
      Dir.glob(
        File.expand_path("#{install_dir}/embedded/lib/ruby/site_ruby/*")
      ).first,
      preserve: true
    )
  end

  [
    'bin',
    'etc',
    'libexec',
  ].each do |path|
    copy(
      path,
      "/opt/flight",
      preserve: true,
    )
  end
end
