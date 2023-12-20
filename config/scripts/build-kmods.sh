#!/usr/bin/env bash

set -oue pipefail

KERNEL_NAME="kernel"
ARCH="$(rpm -E '%_arch')"
KERNEL="$(rpm -q "${KERNEL_NAME}" --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"
RELEASE="$(rpm -E '%fedora')"

# We will link dnf to rpm-ostree for correct installation
ln -s /usr/bin/rpm-ostree /usr/bin/dnf

akmods --force --kernels "${KERNEL}" --kmod acpi_ec
modinfo /usr/lib/modules/${KERNEL}/extra/acpi_ec/acpi_ec.ko.xz >/dev/null ||
	(find /var/cache/akmods/acpi_ec/ -name \*.log -print -exec cat {} \; && exit 1)

# Remove the link to rpm-ostree
rm -f /usr/bin/dnf
