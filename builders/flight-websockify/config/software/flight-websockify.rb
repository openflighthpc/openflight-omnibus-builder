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
name 'flight-websockify'
default_version '0.0.0'

source path: File.expand_path('../../lib', __dir__)

license 'LGPLv3'
license_file 'LICENSE.txt'
skip_transitive_dependency_licensing true

# Numpy has a bunch of files which depend on each other, this can be ignored
#whitelist_file Regexp.new('\.venv/lib/python\d\.\d/site-packages/numpy\.libs/libgfortran-.+')
#whitelist_file Regexp.new('\.venv/lib/python\d\.\d/site-packages/numpy\.libs/libopenblasp-.+')
whitelist_file Regexp.new('\.venv/.*')

build do
  env = with_embedded_path("PIPENV_VENV_IN_PROJECT" => 'true')

  # Place the openflight version of python onto the path
  env['PATH'] = "/opt/flight/opt/python/bin:#{env['PATH']}"

  # Copies the pip files to the install dir
  ['Pipfile', 'Pipfile.lock'].each do |file|
    copy file, File.join(install_dir, file)
  end

  # Builds the virtual env
  command(<<-CMD, env: env)
    cd #{install_dir}
    pipenv install
  CMD

  # Generates the bin symlinks
  block do
    Dir.chdir install_dir do
      FileUtils.mkdir_p 'bin'
      Dir.glob('.venv/bin/*').each do |path|
        FileUtils.ln_s File.join('..', path), File.join('bin', File.basename(path))
      end
    end
  end
end
