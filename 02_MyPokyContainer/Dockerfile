FROM crops/poky:ubuntu-18.04

WORKDIR /workdir

USER root

RUN chown usersetup .

USER usersetup

RUN git clone git://git.yoctoproject.org/poky && \
    source ./poky/oe-init-build-env && \
    bitbake core-image-sato
