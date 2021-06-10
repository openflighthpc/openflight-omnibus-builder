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

  # We have a couple of executables, `python3` and `pip3` that we'd like to
  # have at different locations.  Ideally, we'd have them installed in one
  # location and symlinked to the others.  Unfortunately, omnibus makes that
  # difficult as one of the locations `/opt/flight/bin` is outside of
  # `install_dir`.
  #
  # I have abandoned attempts to get symlinks working correctly.  Instead I've
  # settled for having a single source pair of files and copy them to the
  # correct locations as part of the build.
  builder_root = Pathname.new(File.dirname(__FILE__)).join('../..').expand_path
  ofb = builder_root.join('opt/flight/bin')
  copy ofb.join('*').to_s, File.join(install_dir, 'bin')
end
