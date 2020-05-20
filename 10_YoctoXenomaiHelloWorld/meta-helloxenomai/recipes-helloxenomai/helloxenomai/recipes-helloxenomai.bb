SUMMARY = "Simple Xenomai Hello World C program built with CMake"
SECTION = "examples"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit cmake

DEPENDS = "xenomai"
SRC_URI = "file://*"

S = "${WORKDIR}"

BBCLASSEXTEND = "native"
