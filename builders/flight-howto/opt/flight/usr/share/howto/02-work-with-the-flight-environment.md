# Working with Flight(7)

## Activating the Flight System

The Flight User Suite sits unobtrusively on the research environment with the `flight` command serving as an entrypoint to the various system commands.

While deactivated the `flight` command provides some quick tips for activating the system and finding out more about the flight system (`flight info`).

To activate your OpenFlight environment, simply run `flight start`. When first run, this will also generate some login keys that ease SSH access within your cluster by allowing passwordless logins between nodes.

The OpenFlight environment can be set to automatically activate on login by running `flight set always on`.

## Customising the Environment

### Setting the Research Environment Name

To identify your research environment, you can supply a cluster name that is displayed in the prompt when the Flight System is active.

Specify your cluster name as follows:

```
flight config set cluster.name mycluster
```

## What's next?

Read about:

 * The useful suite of tools provided by the Flight User Suite:
    `flight howto show use-flight-user-suite`

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
