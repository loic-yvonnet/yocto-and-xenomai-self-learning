# Yet another shaming failure

At some point, it sounded like a good idea to pull poky inside a container on top of CROPS and bitbake it right away. But I should have learnt my Docker lessons. When you mount a volume, the host overrides the container mounted directory... and you lose the content of the container workdir!

Anyway, poky is just a sample project and not a mandatory infrastructure (which was my initial understanding). In other words, CROPS is simply just the right way to go, and does not require any upper level container.
