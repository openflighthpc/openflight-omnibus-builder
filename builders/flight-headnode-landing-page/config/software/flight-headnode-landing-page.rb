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

require 'zlib'
require 'minitar'

name 'flight-headnode-landing-page'
default_version '0.0.0'

source git: "https://github.com/openflighthpc/flight-landing-page"

license 'EPL-2.0'
license_file 'LICENSE.txt'
skip_transitive_dependency_licensing true

build do
  type = 'default'
  # Moves the content for the landing page into place.
  copy "landing-page/types/#{type}/*", install_dir

  # Extract the text from the demo config-pack and generate the download files
  readme = "/opt/flight/usr/share/www/downloads/config-packs/example/README.md"
  tarball = "/opt/flight/usr/share/www/downloads/config-packs/example/example.tar.gz"
  block do
    metapath = File.join(install_dir, 'content/config-packs/example.md.disabled')
    text = File.read(metapath).split("---\n").last

    # Clean the existing downloads directory
    FileUtils.mkdir_p(File.dirname(readme))
    FileUtils.rm_f readme
    FileUtils.rm_f tarball

    # Create the readme and tarball
    File.write(readme, text)
    Dir.chdir(File.dirname(readme)) do
      Minitar.pack('README.md', Zlib::GzipWriter.new(File.open(tarball, 'wb')))
    end
  end

  project.extra_package_file readme
  project.extra_package_file tarball
end
