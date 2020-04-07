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
name "enforce-yum-packages"
default_version "0.0.0"

Dir.mktmpdir do |tmpdir|
  source path: tmpdir

  # Fixes bug where project_dir isn't created. This is likely due to the source
  # being empty. It prevents any system commands from being ran
  FileUtils.mkdir_p project_dir
end

build do
  packages = ['gcc', 'make', 'ruby-devel', 'pam-devel']
  command <<~CMD
    status=0
    missing=()
    #{
      packages.map do |p|
        <<~SUBCMD
          yum list installed #{p}
          if [ $? -ne 0 ]; then
            status=1
            missing+=('#{p}')
          fi
        SUBCMD
      end.join("\n")
    }
    if [ $status -ne 0 ]; then
      echo Please run the following command to install required packages: >&2
      echo yum install -y -e0 ${missing[@]} >&2
    fi
    exit $status
  CMD
end
