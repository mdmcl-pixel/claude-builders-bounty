# Script

## Hook

**A fake POWER10 fooled RustChain's passive hardware checks.**

## Narration

RustChain tried to tell real exotic hardware from emulation — and a fake POWER10 exposed the hard part.

In its June 2026 anti-emulation research, a full-system QEMU pseries guest reported both `ppc64le` and `POWER10`, so the architecture signals agreed.

The remaining tell was a QEMU artifact from virtio-SCSI. Remove that artifact by changing the virtual storage path, and the passive rules can classify the guest as physical, exotic-server hardware.

RustChain also tested an active ILP probe, but adversarial reruns overlapped bare metal, so that idea was rejected.

The current recommendation is fail-safe: don't grant exotic multipliers from passive evidence alone. The open challenge is an architecture-specific active probe that emulation can't faithfully reproduce.

**Estimated narration:** ~50 seconds at a natural technical-presenter pace.
