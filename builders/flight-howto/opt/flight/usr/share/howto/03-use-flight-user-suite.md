# flight-user-suite(7)

## What is Flight User Suite?

The Flight User Suite is a collection of environment tools that provide you with easy and intuitive ways to manage the software and desktop sessions in your research envrionment. The purpose of these tools is to get you started with HPC as quickly as possible without needing to worry about your environment, leaving you to do what you do best - research!

The tools are non-intrusive to the research environment, defaulting to a “deactivated” state which leaves you free to configure and utilise the base environment how you want.

Flight User Suite is made up of the following tools:

 * Flight Runway: the foundation of the OpenFlight environment, providing the `flight` command entry point for accessing the other OpenFlight tools.
 * Flight Env: a tool for the management of various software package ecosystems, providing access to a wide variety of HPC applications.
 * Flight Desktop: an intuitive tool for launching VNC-ready virtual desktops for many different desktop environments (gnome, xterm, kde, etc.)
 * Flight Howto: you're using it!

## Installing Flight User Suite

Usually Flight User Suite has already been installed in your OpenFlight environment, but if you're missing any of the above tools, the OpenFlight project packages tools as both RPM and DEB packages that are hosted in package repositories which can be quickly installed with a couple of commands.

### CentOS 7 and CentOS 8

  * Install the Flight User Suite RPM:
     `sudo yum install flight-user-suite`

### Ubuntu 18.04 and Ubuntu 20.04

  * Install the Flight User Suite package:
     `sudo apt-get install flight-user-suite`

## What's next?

Read about:

 * How to get started with the Flight Environment:
    `flight howto show work-with-the-flight-environment`

 * How to run jobs:
    `flight howto show run-jobs`
    `flight howto show use-a-scheduler`

You can find more help and documentation in the OpenFlight docs:

> <https://build.openflighthpc.org/>
> <https://use.openflighthpc.org/>

## License

This work is licensed under a Creative Commons Attribution-ShareAlike
4.0 International License.

See <http://creativecommons.org/licenses/by-sa/4.0/> for more
information.

Copyright (C) 2020 Alces Flight Ltd.
