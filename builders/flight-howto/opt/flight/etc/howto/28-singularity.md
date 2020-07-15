# Using Gridware with Singularity
Much like how 

:ref:`Gridware can be used within docker containers <docker>`

, Singularity can import those same containers into an image file. Providing an alternative to docker for distributing applications in a platform-agnostic manner.

"System Message: ERROR/3 (28-singularity.rst:, line 6)"
Unknown interpreted text role "ref".

To install singularity support, apply the feature profile (for more info on features see 

:ref:`feature-profiles`

:

"System Message: ERROR/3 (28-singularity.rst:, line 8)"
Unknown interpreted text role "ref".

{language=python}
```
alces customize apply feature/configure-singularity
```

Once the feature has been installed, the Singularity binary can be added to the path by loading the module:

{language=python}
```
module load apps/singularity/2.4
```

## Building Images
Singularity supports a range of [build sources](http://singularity.lbl.gov/archive/docs/v2-3/user-guide#supported-uris) for its images, this documentation will focus primarily on using [Singularity Hub](http://singularity-hub.org/) for building container images.

To build the hello-world container from Singularity Hub:

{language=python}
```
singularity pull shub://vsoch/hello-world
```

This creates an image file in the current working directory called `vsoch-hello-world-master.simg`.

## Running Containers
The image can either be executed as a binary or interactively logged into.

### Executing Container
The container can be run using the predefined entrypoint (at `/Singularity` in the image):

{language=python}
```
[alces@login1(scooby) ~]$ singularity run vsoch-hello-world-master.simg
RaawwWWWWWRRRR!!
```

Or it can have a single command passed through to it to run:

{language=python}
```
[alces@login1(mycluster) ~]$ singularity exec vsoch-hello-world-master.simg cat /etc/os-release
NAME="Ubuntu"
VERSION="14.04.5 LTS, Trusty Tahr"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 14.04.5 LTS"
VERSION_ID="14.04"
HOME_URL="http://www.ubuntu.com/"
SUPPORT_URL="http://help.ubuntu.com/"
BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
```

### Logging into Container
To connect to an interactive shell on the image:

{language=python}
```
[alces@login1(mycluster) ~]$ singularity shell vsoch-hello-world-master.simg
Singularity: Invoking an interactive shell within container...

Singularity vsoch-hello-world-master.simg:~>
```

