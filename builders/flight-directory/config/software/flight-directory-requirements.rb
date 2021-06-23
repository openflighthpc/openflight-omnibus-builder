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
name 'flight-directory-requirements'
default_version '0.0.0'

skip_transitive_dependency_licensing true

source path: File.expand_path('../../lib', __dir__)

build do
  env = with_embedded_path("PIPENV_VENV_IN_PROJECT" => 'true')

  # Place the openflight version of python onto the path
  env['PATH'] = "/opt/flight/opt/python/bin:#{env['PATH']}"

  # Copies the pip files to the install dir
  ['Pipfile', 'Pipfile.lock'].each do |file|
    copy file, File.join(install_dir, file)
  end

  # Add flight-directory lib to the PYTHON_PATH, using venv .pth magic
  # https://stackoverflow.com/a/10739838
  sys = overrides[:python_system] || raise("The python_system has not been overriden")
  lib = File.join(install_dir, 'lib')
  pth = File.join(install_dir, ".venv/lib/python#{sys}/site-packages/directory.pth")
  block do
    FileUtils.mkdir_p File.dirname(pth)
    File.write(pth, lib)
  end

  # Builds the virtual env
  command(<<-CMD, env: env)
    cd #{install_dir}
    pipenv install --python /opt/flight/opt/python/bin/python --deploy
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
