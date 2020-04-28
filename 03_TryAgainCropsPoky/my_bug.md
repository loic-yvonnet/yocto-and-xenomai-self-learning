In summary, QEMU hangs in the CROPS/Poky Docker container after the login prompt.

The problem may be reproduced from a Ubuntu 18.04 host by following these steps:
* In a terminal, type:
    ```
    docker pull crops/poky:ubuntu-18.04
    mkdir workdir
    cd workdir
    git clone git://git.yoctoproject.org/poky
    docker run --name yocto-dev --rm -it \
    	-v $PWD/workdir:/workdir \
    	crops/poky:ubuntu-18.04 --workdir=/workdir
    ```

* In a different terminal, create a file named `compile.sh`:
    ```
    #!/bin/bash

    source ./poky/oe-init-build-env > /dev/null
    bitbake core-image-minimal
    ```

* Create a file named `run.sh`:
    ```
    #!/bin/bash

    source ./poky/oe-init-build-env > /dev/null
    runqemu qemux86-64 core-image-minimal qemuparams="-m 256" slirp nographic
    ```

* Finally, type:
    ```
    chmod 755 compile.sh
    chmod 755 run.sh
    docker exec -w /workdir -u pokyuser -i yocto-dev bash < compile.sh
    docker exec -w /workdir -u pokyuser -i yocto-dev bash < run.sh
    ```

Actual result:
* QEMU boots the core-image-minimal.
* It displays the login prompt.
* After entering "root", QEMU hangs and never displays the prompt.
* It is not possible to execute a command from the emulated OS.

Expected result:
* QEMU boots the core-image-minimal.
* It displays the login prompt.
* After entering "root", QEMU displays the regular prompt.
* It is possible to execute commands in the emulated OS.

On the other hand, compiling and running the core-image-minimal from the Ubuntu 18.04 host in QEMU works as expected.

Is there a workaround to run QEMU from a Docker container?

PS: I am new to the Yocto project and QEMU. It may not be a good idea to run QEMU on top of a Docker container. I am simply trying to see if I can run everything from a container.