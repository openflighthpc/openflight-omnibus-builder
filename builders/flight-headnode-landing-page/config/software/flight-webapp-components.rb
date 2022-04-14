
require 'zlib'
require 'minitar'

name 'flight-webapp-components'
default_version '0.0.0'

source git: "https://github.com/openflighthpc/flight-webapp-components"

dependency 'enforce-flight-nodejs'

skip_transitive_dependency_licensing true

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # Build flight-webapp-components and the login menu
  block do
    # Build flight-webapp-components
    command "cd #{project_dir} && /opt/flight/bin/yarn install", env: env
    command "cd #{project_dir} && /opt/flight/bin/yarn run build", env: env

    # Build flight login menu
    command "cd #{project_dir}/builder && /opt/flight/bin/yarn install", env: env
    command "cd #{project_dir}/builder && /opt/flight/bin/yarn run build", env: env

    # Move newly generated static js and css files to headnode dir
    FileUtils.mkdir_p(File.join(install_dir, "content", "js"))
    command "cp " \
            "#{project_dir}/builder/build/static/js/main.js " \
            "#{install_dir}/content/js/login.js"
    command "cp " \
            "#{project_dir}/builder/build/static/css/main.css " \
            "#{install_dir}/content/styles/login.css"
  end

  # Clean up components dir
  FileUtils.rm_rf(project_dir)
end
