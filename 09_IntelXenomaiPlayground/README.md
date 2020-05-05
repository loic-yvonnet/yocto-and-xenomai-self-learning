# Another day, another failure

Intel Xenomai looks great. However, I can't run the Xenomai latency test from the emulated embedded OS.

## Xenomai latency fails to create threads

In summary, the Xenomai `latency` fails in the Intel Xenomai intel-corei7-64 image.

The problem may be reproduced from a Ubuntu 18.04 host by following these steps:
* In a terminal, install Go:
    ```
    wget https://dl.google.com/go/go1.14.2.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf go1.14.2.linux-amd64.tar.gz
    rm go1.14.2.linux-amd64.tar.gz
    PATH=$PATH:/usr/local/go/bin
    ```

* Install the Yocto Project dependencies:
    ```
    sudo apt-get install gawk wget git-core diffstat unzip texinfo gcc-multilib \
         build-essential chrpath socat cpio python3 python3-pip python3-pexpect \
         xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev \
         pylint3 xterm
    
    ```

* Clone Intel Xenomai and run the download script (when prompted, type "1"):
    ```
    git clone git@github.com:intel/xenomai.git
    cd xenomai
    chmod 755 download.sh
    ./download.sh
    ```

* Bake the XFCE image:
    ```
    cd snapshots/manifest_1/
    source poky/oe-init-build-env build
    bitbake -k core-image-xfce-sdk

    ```

* Run the image in QEMU (when prompted for login, type "root"):
    ```
    runqemu intel-corei7-64 qemuparams="-m 2048 -smp 4" slirp nographic
    ```

* Check the Xenomai install:
    ```
    dmesg | grep -i Xenomai
    cat /proc/xenomai/sched/threads
    ```

* Export the LD_LIBRARY_PATH and PATH:
    ```
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/xenomai/lib
    export PATH=$PATH:/usr/xenomai/bin
    ```

* Make sure we are root and our [real-time priority soft limit is not too restrictive](https://stackoverflow.com/questions/9313428/getting-eperm-when-calling-pthread-create-for-sched-fifo-thread-as-root-on-lin):
    ```
    whoami
    ulimit -r unlimited
    ```

* Add [root to the allowed group](https://gitlab.denx.de/Xenomai/xenomai/-/commit/cf21e806295981a9d0e342f683bfef419b6e3c68):
    ```
    cat /sys/module/xenomai/parameters/allowed_group
    ls -l /sys/module/xenomai/parameters/allowed_group 
    chmod 744 /sys/module/xenomai/parameters/allowed_group
    echo "0" >> /sys/module/xenomai/parameters/allowed_group
    cat /sys/module/xenomai/parameters/allowed_group
    ```

* Run the Xenomai `latency`:
    ```
    latency -p 1000
    ```

Actual result:
* `latency` return code is 1.
* `latency` fails with the following log:
    ```
    == Sampling period: 1000 us
    == Test mode: periodic user-mode task
    == All results in microseconds
    latency: pthread_create(latency): Operation not permitted
    ```

Expected result: [The latency test should display a message every second with minimum, maximum and average latency values.](https://gitlab.denx.de/Xenomai/xenomai/-/wikis/Installing_Xenomai_3#user-content-testing-the-installation).
