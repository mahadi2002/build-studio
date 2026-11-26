# Kernel and Drivers
tier: 3 | sources: The Linux Kernel documentation (kernel.org); Microsoft Windows Driver Kit documentation | updated: 2026-11-26

## Triggers
- OS kernels, hobby OS, device drivers, Linux kernel modules, eBPF programs, bootloaders for an OS.
- Not for ordinary user-space apps or scripts.

## Scope check
- Can do here: write a hobby kernel or module, build it in WSL2 or a Linux VM, and run it in QEMU, VirtualBox or Hyper-V. Unit test pure logic on the host.
- Needs hardware, certification or experts: real device drivers need the real device. Windows kernel drivers need an EV code-signing certificate for release (paid, gate G3). Production kernel code needs expert review.
- Safety and regulatory risks: kernel bugs crash or corrupt the whole machine and its disk. A kernel exploit or rootkit is a security risk. Never load the code on the owner's main PC.

## Role-specific rules
- Test only inside a VM with a snapshot taken first; never on the owner's main machine or the host kernel.
- Turn on sanitizers and lockdep-style checks where the kernel offers them.
- Keep the VM network off or host-only unless the task needs more.
- No code that hides processes, hooks syscalls to evade tools or disables protections.

## Definition of done
- Module or kernel boots in the VM; log and `dmesg` or QEMU serial output shown.
- Unload or reboot is clean, and the VM snapshot used is named in the report.
