name 'flight-python'
default_version '0.0.0'

dependency 'python'
license 'EPL-2.0'
license_file 'LICENSE.txt'

build do
  # Check that flight-python has not been installed or previously built.
  # NOTE: this is done when the software file is loaded

  if %w(python3 python pip3 pip).any? {|f| File.exists?(File.join("/opt/flight/bin", f))}
    raise <<~ERROR
      flight-python can not be built when existing version has been installed!
      Please remove the system version before continuing
    ERROR
  end

  dist_dir = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'dist'))
  copy File.join(dist_dir, 'bin', '*'), File.join(install_dir, 'bin')

  links = [
    ["bin/python3", ["bin/python", "../../bin/python3"]],
    ["bin/python",  [              "../../bin/python"]],
    ["bin/pip3",    ["bin/pip",    "../../bin/pip3"]],
    ["bin/pip",     [              "../../bin/pip"]],
  ]
  links.each do |src, dsts|
    dsts.each do |dst|
      link File.join(install_dir, src), File.expand_path(File.join(install_dir, dst))
    end
  end
end
