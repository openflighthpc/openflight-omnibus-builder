name "sqlite3"
default_version "3.31.1"

dependency "libxslt"

version_tag = version.split('.').map { |part| '%02d' % part.to_i }.join[1..-1]
year = "2020"

source :url => "http://www.sqlite.org/#{year}/sqlite-autoconf-#{version_tag}.tar.gz",
       :sha1 => "ea14ef2dc4cc7fcbc5ebbb018d3a03faa3a41cb4"

relative_path "sqlite-autoconf-#{version_tag}"

env = {
  "LDFLAGS" => "-Wl,-rpath,#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
}

build do
  command "./configure --prefix=#{install_dir}/embedded --disable-readline", :env => env
  command "make", :env => env
  command "make install"
end
