# Metadata

## Primary title

**The Fake POWER10 That Fooled Passive Hardware Checks**

## Alternate titles

- **RustChain Tested a Fake POWER10 — Here's What Broke**
- **Why Passive VM Detection Wasn't Enough for RustChain**

## Hook line

**A fake POWER10 fooled RustChain's passive hardware checks.**

## Description

RustChain's June 2026 anti-emulation research tested real QEMU/KVM and full-system TCG negatives against its passive hardware-fingerprint signals. One frontier case — a full-system ppc64le guest presenting itself as POWER10 — exposed how internally consistent emulation can slip past passive checks once removable virtualization artifacts are gone.

The project also tested an active ILP-based probe, then explicitly rejected it after adversarial reruns overlapped bare-metal results. Its published interim recommendation is fail-safe weighting and an architecture-specific active probe before exotic hardware multipliers are trusted.

Source material is mapped claim-by-claim in `SOURCES.md`.

## Suggested tags

`RustChain` `hardware security` `virtualization` `QEMU` `POWER10` `anti-emulation` `blockchain` `DePIN` `open source`

## Suggested caption text

A fake POWER10 exposed the limit of passive hardware fingerprinting. RustChain's own adversarial testing found that consistent full-system emulation could look physical once removable VM artifacts disappeared — and a promising active probe was later refuted. The published fix direction is architecture-specific active evidence plus fail-safe reward weighting.

## Thumbnail / first-frame text

**FAKE POWER10**

Smaller line: `Passive checks fooled`
