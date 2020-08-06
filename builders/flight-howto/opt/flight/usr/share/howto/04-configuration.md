# Cluster Configuration Options
## Autoscaling
With some Cloud providers it is possible to have nodes added and removed at run-time. This is usually managed through job-scheduler information to determine what sort of availability is required at that moment in time.

To determine the state of autoscaling on the cluster:

{language=python}
```
[alces@login1(scooby) ~]$ alces configure autoscaling status
Autoscaling: enabled
```

The state can then be toggled by providing `enabled`/`disabled` to the autoscaling command. In the event of autoscaling being set to disabled - the number of nodes currently running will be frozen, no more will be added or removed:

{language=python}
```
[alces@login1(scooby) ~]$ alces configure autoscaling: autoscaling disabled
alces configure autoscaling: autoscaling disabled
```

## Clocksource
On most systems there are multiple devices available for managing the time. The alces configure utility has controls to ensure that the chosen clocksource is consistent across the entire cluster.

To view the available clocksources:

{language=python}
```
[alces@login1(scooby) ~]$ alces configure clocksource
[*] default
[*] xen
[ ] tsc
[ ] hpet
[ ] acpi_pm
```

Xen is the default clocksource, this is indicated with the additional asterisk in the default column. The clocksource can be changed to any value in the list (including `default` to set it back to the original settings):

{language=python}
```
[alces@login1(scooby) ~]$ alces configure clocksource tsc
```

## Dropcache
When running large HPC applications it is likely that the caches build up with data from previous runs. There are a few options available for dropcache:

> - `pagecache` - Drops the paged files in RAM
> 
> - `slabobjs` - Reclaim slab objects, such as dentries and inodes
> 
> - `both` - Perform both of the above actions

The pagecache can be dropped as follows:

{language=python}
```
[alces@login1(scooby) ~]$ alces configure dropcache pagecach
alces configure dropcache: clean caches from pagecache dropped
```

## Hyperthreading
Some Cloud instances are configured with "virtual" CPU cores. For each physical processor core, the OS addresses a second virtual core - this is known as [Hyperthreading](https://en.wikipedia.org/wiki/Hyper-threading). In some cases, your application may suffer a performance drop when Hyperthreading is enabled. Alces Flight Compute includes the necessary tools to easily and dynamically disable Hyperthreading on each of your instances.

### Checking the status of Hyperthreading
You can check whether a node has Hyperthreading enabled or disabled by running the following command:

{language=bash}
```
[alces@node-xf5(scooby) ~]$ alces configure hyperthreading
alces configure hyperthreading: hyperthreading is enabled
```

### Disabling Hyperthreading
Disabling Hyperthreading will dynamically turn off the secondary thread for each physical CPU core which your instance has access to. For most platforms, this will effectively halve the number of CPU cores reported by your instance. To see the current number of cores available to your instance, users can run the following example command:

{language=bash}
```
[alces@node-xf5(scooby) ~]$ cat /proc/cpuinfo | grep processor | wc -l
8
```

Users can then disable Hyperthreading and confirm its status using the following commands:

{language=bash}
```
[alces@node-xf5(scooby) ~]$ alces configure hyperthreading disable
alces configure hyperthreading: hyperthreading disabled
[alces@node-xf5(scooby) ~]$ cat /proc/cpuinfo | grep processor | wc -l
4
```

## Transparent Huge Pages
Transparent Huge Pages, or THP, allow for larger blocks of memory to be managed within in a single page. This allows for the system to be able to utilise large amounts of memory more effectively.

To check the current status of THP:

{language=python}
```
[alces@login1(scooby) ~]$ alces configure thp status
enabled
```

The state of THP can then be modified by replacing `status` with `enable` or `disable`:

{language=python}
```
[alces@login1(scooby) ~]$ alces configure thp disable
```

