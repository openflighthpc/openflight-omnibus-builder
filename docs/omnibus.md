# Omnibus builder structure

The purpose of this document is to explain the most important parts of the Omnibus builder structure to you. It will only be describing elements of the builder that you will ever need to edit that aren't fully described by the Omnibus documentation (or are specific to OpenFlightHPC projects).

## `bin/omnibus`
The `bin/omnibus` entrypoint is installed by Bundler and doesn't require any changes. It looks for a project file in `config/projects` with the name given to Omnibus at the command line.

## Projects

The top-level project file defines the application as a whole.

### Project description

The project file will always contain the following [Omnibus DSL method calls](https://github.com/chef/omnibus#projects):

| Method | Description |
|--------|-------------|
| `name` | The name of the project (formatted as it would be in a GitHub repo URL) |
| `maintainer` | The name of the entity who maintains the package (always `Alces Flight Ltd`, for OpenFlightHPC packages) |
| `homepage` | The URL for the project's GitHub repository |
| `friendly_name` | The name of the project with user-friendly formatting |
| `description` | A short description of the project |

These DSL methods describe the package in a way that will be displayed to the user when they install it from their favourite package manager. The `homepage` method sets the repository that will be cloned at build time.

### Project setup

`install_dir` is the path to which the package will be installed on the user's system. For OpenFlightHPC packages, this will almost always be `/opt/flight/opt/<executable-name>`.

A constant, `VERSION`, must be set in the project file. This constant is used throughout the builder to specify the version of the package being built. It *must* be equal to the GitHub tag that you wish to build against. It is conditionally set depending on the current build architecture. When updating a package, please update the `VERSION` setter in the conditional that corresponds to your build architecture.

`build_iteration` is a incrementable value that lets you build the same version multiple times (by default, you cannot build a package that already exists in `pkg/`). This value should *always* be reset to `1` when the final package build is ready.

`config_file` allows you to specify any file(s) that will be installed as a config file. Specifying a file here prevents a pre-existing config file from being overwritten, so you should almost always include it specifying your project's `etc/config.yml` file.

The `dependency` calls refer to dependencies required at build time. *All* `dependency` calls (except `preparation` and `version-manifest`) should correspond to a script to be found in the `config/software directory.

The `runtime_dependency` calls refer to dependencies that are required at package runtime (i.e. packages that must be installed before this package can be installed). Two runtime dependencies that will almost always be required are `flight-runway` and `flight-ruby-system-2.0`. These will be found and installed by the user's package manager when your project is installed.

You may define extra files in the builder to be installed to the user's system along with your cloned/built package. You may define these extra files with `extra_package_file '</path/to/file>'. The path given to `extra_package_file` must match the filepath relative to the root of the package builder, and it will be installed to the same place on the target system (see `opt/flight/libexec/commands/<name>` for an example).

## Softwares

Software files define individual components of the overall package. They are a good way to split the build/installation of your package into multiple steps/blocks. You will always have a software file for your project, as this is what is triggered by the top-level project definition.

Some of the DSL methods here exist because software definition files are designed to be able to be used by multiple project definitions at the same time. For example, `default_version` exists to specify which software version should be used when the top-level project definition doesn't specify a version.

### Software definition

| Method | Description |
|--------|-------------|
| `name` | The name of the software component (always comes first) |
| `default_version` | The build version to use when version is not set by project definition |
| `source` | The URL containing the source for the project (the GitHub repo URL) |
| `dependency` | Another Omnibus software component that this software depends on (triggers that software component now) |
| `build` | A block definition giving instructions on how to install the application |

The template builder will automatically generate a software file for your application, and a software filed named `enforce-flight-runway.rb`. The latter enforces that the user has installed `flight-runway` before they install your application (as well as before a developer tries to build it).

### Software build definition

The logic to actually install your application belongs to the `build` block defined in `config/software/<project>.rb` file. The most basic structure for this file resembles the following:

- Add compiler flags to the environment hash
- Move all the files/directories of your project into place
- Install any gems in your project's Gemfile
- Define version block
  - Set up the default `etc/config.yml` file for your application

The template builder generates all of this automatically. You should check that the "Move all files into place" step includes all of the files/directories in your application. You should also fill in any config keys you want to be set upon installation. In the case that your application has more setup required on the user's system, include it in the `build` block. Software definition files are just Ruby, after all. Some DSL methods you may find useful include:

| Variable | Description |
|----------|-------------|
| `install_dir` | The absolute path of the directory containing the installed package, e.g. `/opt/flight/opt/<package>` |
| `project_dir` | The relative path of the project directory , e.g. `builders/<package>/opt/flight/` |

#### Version blocks

We support building multiple versions of the same software in the same software definition file. This is only really useful when we are maintaining different versions across our RHEL/Debian architectures. A version block is defiend with:

```ruby
build do
  ...
  version '0.0.0' do
    ...
  end
end
```

A version block *must* be defined for each possible version that we are currently maintaining (i.e. each version that is specified in the project file). You should put any version specific build instructions in these blocks. Most of the pre-generated build instructions should remain outside of these blocks, as they are version agnostic instructions.

#### Config file preservation

Unless you register your project's config file in `config/projects/<project>.rb` with `config_file`, a user's config file will be overwritten with the default values you specified just above. Please make sure that you register your project's config file, unless you want the user's config to be overwritten every time they update their application.

## Miscellaneous build files

### Command file

A file exists at `opt/flight/libexec/commands/profile`. It is included in the package to be installed at the same location relative to `/opt/flight`. This is the file invoked by Flight Runway when launching your application. It contains Bash logic at the bottom; you shouldn't need to edit this in 90% of situations. The top of the file defines a name, synopsis, and version number for your application. You should update the name and description to correspond with your application; the version number is updated automatically at build time.

There is another optional key that may be included: `ROOT`. Flight Runway is designed to never be run as `root`, so if your application requires root access, you should include `ROOT: true` in this file to inform Flight Runway to run it as the root user.

### Resources directory

The resources directory contains spec files generated by Omnibus for the platform you're building on. You don't have to (and, honestly, shouldn't) touch these.
