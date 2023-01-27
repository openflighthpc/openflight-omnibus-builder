## Coming soon...

# Omnibus builder structure

The purpose of this document is to explain the most important parts of the Omnibus builder structure to you. It will only be describing elements of the builder that you will ever need to edit that aren't fully described by the Omnibus documentation (or are specific to OpenFlightHPC projects).

## `bin/omnibus`
The `bin/omnibus` entrypoint is installed by Bundler and doesn't require any changes It looks for a Ruby file in `config/projects` with the name given to Omnibus at the command line.

## Projects

The top-level project file defines the application as a whole.

### Project description

The project file will always contain the following [Omnibus method calls](https://github.com/chef/omnibus#projects):

| Method | Description |
|--------|-------------|
| `name` | The name of the project (formatted as it would be in a GitHub repo URL) |
| `maintainer` | The name of the entity who maintains the package (always `Alces Flight Ltd`, for OpenFlightHPC packages) |
| `homepage` | The URL for the project's GitHub repository |
| `friendly_name` | The name of the project with user-friendly formatting |
| `description` | A short description of the project |

These methods describe the package in a way that will be displayed to the user when they install it from their favourite package manager.

### Project setup

`install_dir` is the path to which the package will be installed on the user's system. For OpenFlightHPC packages, this will almost always be `/opt/flight/opt/<executable-name>`.

A constant, `VERSION`, will be set in the project file. This constant is used throughout the builder to specify the version of the package being built, and *must* be equal to the GitHub tag that you wish to build against.

`build_iteration` is a incrementable value that lets you build the same version multiple times (by default, you cannot build a package that already exists in `pkg/`). This value should *always* be reset to `1` when the final package build is ready.

The `dependency` calls refer to dependencies required at build time. *All* `dependency` calls (except `preparation` and `version-manifest`) should correspond to a script to be found in the `config/software directory.

The `runtime_dependency` calls refer to dependencies that are required at package runtime (i.e. packages that must be installed before this package can be installed). Two runtime dependencies that will almost always be required are `flight-runway` and `flight-ruby-system-2.0`. These will be found and installed by the user's package manager when your project is installed.

You may define extra files in the builder to be installed to the user's system along with your cloned/built package. You may define these extra files with `extra_package_file '</path/to/file>'. The path given to `extra_package_file` must match the filepath relative to the root of the package builder, and it will be installed to the same place on the target system (see `opt/flight/libexec/commands/<name>` for an example).

## Softwares
