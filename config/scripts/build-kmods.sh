#!/usr/bin/env bash

set -oue pipefail

ARCH="$(rpm -E '%_arch')"
KERNEL="$(rpm -q "${KERNEL_NAME}" --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"
RELEASE="$(rpm -E '%fedora')"

akmods --force --kernels "${KERNEL}" --kmod acpi_ec
modinfo /usr/lib/modules/${KERNEL}/extra/acpi_ec/acpi_ec.ko.xz >/dev/null ||
	(find /var/cache/akmods/acpi_ec/ -name \*.log -print -exec cat {} \; && exit 1)
