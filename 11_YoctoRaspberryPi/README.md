# Raspberry Pi with Yocto (more failures)

The previous tests involved QEMU and x86. The following tests involve actual hardware with a Raspberry Pi B+, and a Raspberry Pi 3 A+.
The initial objectives were:
* Compile and deploy Linux 4.14 with Xenomai 3.1 (Cobalt) for the arm architecture on the Raspberry Pi B+.
* Compile and deploy Linux 4.14 with Xenomai 3.1 (Cobalt) for the arm architecture on the Raspberry Pi 3 A+.
* Use a UART to USB stick to get the boot logs without having to switch keyboard and screen to the RPi thanks to minicom or screen.
* Use RJ45, DHCP and SSH to connect to the Raspberry Pi B+.
* Use WiFi, DHCP and SSH to connect to the Raspberry Pi 3 A+.
* Compile and deploy Linux 4.14 with Xenomai 3.1 (Cobalt) for the aarch64 (arm64) architecture on the Raspberry Pi 3 A+.

The first step was to compile and deploy Linux 4.14 (without Xenomai) and get UART to work OK.
Even just that proved to be challenging.
The following tests were performed:

             | Test 1               | Test 2               | Test 3               | Test 4               | Test 5               | Test 6
------------ | -------------------- | -------------------- | -------------------- | -------------------- | -------------------- | --------------------
Yocto        | sumo                 | thud                 | thud                 | thud                 | warrior              | zeus
PCB          | B+                   | B+                   | 3 A+                 | 3 A+                 | 3 A+                 | 3 A+
RPi          | raspberrypi.conf     | raspberrypi.conf     | raspberrypi3.conf    | raspberrypi3-64.conf | raspberrypi3-64.conf | raspberrypi3-64.conf
ARCH         | arm                  | arm                  | arm                  | aarch64 (arm64)      | aarch64 (arm64)      | aarch64 (arm64)
Linux        | 4.14.64              | 4.14.112             | 4.14.112             | 4.14.112             | 4.19.88              | 4.14.112
RT (Xenomai) | No                   | No                   | No                   | No                   | No                   | No
Build        | OK                   | OK                   | OK                   | OK                   | OK                   | FAIL
Boot         | FAIL                 | OK                   | OK                   | FAIL                 | FAIL                 | N/A
UART         | N/A                  | Not tested           | Partial (miniuart)   | N/A                  | N/A                  | N/A

Since I was mostly interested in the ARMv8-a (AArch64) architecture, I was disappointed with my tests.
I am still to try the more recent Yocto branches, but I fear that the more recent branches deal mostly with Linux kernel 5.\*, while I am interested in 4.14.

Xenomai and the EVL Project require both to work on the mainline Linux kernel.
It seems that few vendors use the mainline kernel. In particular, Raspberry maintains its own version of the kernel.
It is this RPi Linux kernel that is available in the meta-raspberry layer.
Then, of course, there is little overlap between the Linux kernel versions officially supported by Xenomai, and those supported by Raspberry.
There are many repos here and there that provide support for one specific Raspberry Linux kernel version and I-Pipe.
But I could not find 4.14.78-arm64.

So in the end, I gave up on the experiment, and started the next one (spoiler: it failed too).
