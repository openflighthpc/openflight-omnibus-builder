#
# Copyright 2012-2016 Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name "nginx"
default_version "1.27.0"

dependency "pcre"
dependency "openssl"
dependency "zlib"

license "BSD-2-Clause"
license_file "LICENSE"

source url: "https://nginx.org/download/nginx-#{version}.tar.gz"

version("1.27.0") { source md5: "a1b1cbaed987893c63cf6ab23809d85f" }

relative_path "nginx-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "./configure" \
          " --prefix=#{install_dir}/embedded" \
          " --with-http_ssl_module" \
          " --with-http_stub_status_module" \
          " --with-ipv6" \
          " --with-pcre" \
          " --without-pcre2" \
          " --with-debug" \
          " --with-cc-opt=\"-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include\"" \
          " --with-ld-opt=-L#{install_dir}/embedded/lib", env: env

  make "-j #{workers}", env: env
  make "install", env: env

  # Ensure the logs directory is available on rebuild from git cache
  touch "#{install_dir}/embedded/logs/.gitkeep"
end
