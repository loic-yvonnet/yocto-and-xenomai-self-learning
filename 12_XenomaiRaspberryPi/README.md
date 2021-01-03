# Xenomai on Raspberry Pi 3 A+

Since I failed to boot Xenomai on Raspberry Pi using Yocto, I decided to take another approach.
I read that Buildroot was supposed to support Xenomai on the Raspberry Pi, but then I read that it did not work.
I did not try (yet) Buildroot for Xenomai so I do not really have an opinion on that, and it may actually work beautifully.
As a matter of fact, I stumbled upon a random thesis that described in details how the student built a working Xenomai on a Raspberry Pi.
The approach of the student was very appealing since it advertised a working mainline Linux kernel with Xenomai on the Raspberry Pi.
Having a mainline Linux means that we can choose any version of I-Pipe and also test EVL Core.
I decided to follow the exact steps of the thesis and create a script so that I may adapt it to the version of Linux I was interested in (4.14.78-arm64).
Unfortunately, this approach did not converge.
I must admit that I did not use the exact same version of Xenomai (I used Xenomai 3.1 stable instead of 3.0-rc2).
Besides, I used a Raspberry Pi 3 A+, where the student seemed to have used a RPi 3 B+.
I am sure that it worked for the student, and I do not question the quality of his thesis, which is actually very good.
Once again, the failure is all mine.
Once I observed that the kernel did not boot (at all, no trace whatsoever), I tried to add das U-Boot to the picture, but it did not help.
At the time of writing, I do not know how to troubleshoot effectively a boot problem (only trial-and-error, which is *not* effective).
