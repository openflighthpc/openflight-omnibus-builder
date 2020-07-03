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

dependency 'python3'

skip_transitive_dependency_licensing true

build do
  env = with_standard_compiler_flags(with_embedded_path)

  %w(
    appdirs>=1.4.0
    autorepr==0.3.0
    packaging==16.8
    prompt-toolkit==1.0.9
    pyparsing==2.1.10
    requests==2.12.5
    requests-file==1.4.1
    six==1.10.0
    terminaltables==3.1.0
    wcwidth==0.1.7
  ).each do |req|
    command "#{install_dir}/embedded/bin/pip3 install --build #{project_dir} --install-option=\"--install-scripts=#{install_dir}/bin\" #{req}", :env => env
  end
  command "#{install_dir}/embedded/bin/pip3 install prompt-toolkit==1.0.9 six==1.10.0 wcwidth==0.2.5 click==6.7 --src #{install_dir}/lib -e git+https://github.com/alces-software/click-repl.git@6a809b2af43054035027618f9fd37af4c31a8abc#egg=click_repl", :env => env
end
