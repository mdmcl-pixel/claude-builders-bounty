# Vertical Visual Plan — 9:16

Use a clean 1080×1920 canvas. Keep source text large enough to read on mobile. Use only the public RustChain repository and simple text/shape overlays; no stock footage is required.

## 0:00–0:04 — Hook

**On-screen text:** `A fake POWER10 fooled the passive checks.`

Capture instruction: open `docs/RIPPOA_TCG_ANTIEMULATION_FINDINGS.md` in the RustChain repository and crop the TL;DR line containing `fake POWER10`. Add a slow 105% push-in.

## 0:04–0:14 — Internally consistent identity

Split the vertical frame into two terminal-style cards:

- `machine = ppc64le`
- `cpu = POWER10`

Under them, add: `Signals agree ✓`

Capture instruction: use the attack-ladder / frontier-case text from the same source file as the background evidence, with the two identity values highlighted.

## 0:14–0:25 — The remaining tell

**On-screen sequence:**

1. `Only tell left: scsi:vm`
2. `Artifact tied to virtio-SCSI`
3. `Remove the artifact → passive evidence can look physical`

Capture instruction: crop the frontier-case paragraph describing the removable `/proc/scsi/scsi` QEMU artifact and the resulting `physical / exotic-server` classification. Do not show shell commands or operational bypass instructions.

## 0:25–0:37 — Active probe tested, then rejected

Show a simple two-column card:

`Initial result` → `looked promising`

`Adversarial rerun` → `overlapped bare metal`

Then stamp: `REFUTED`

Capture instruction: highlight the source's `Active probe (ilp_ratio) — built, then REFUTED by adversarial testing` heading and the sentence stating that TCG `ilp_ratio` overlaps bare metal.

## 0:37–0:50 — Fail-safe conclusion

**On-screen text:**

`Passive evidence alone ≠ exotic multiplier`

Then:

`Open problem: architecture-specific active proof`

Capture instruction: show the `Future fixes` section, especially the recommendations to require an architecture-specific active probe and cap multiplier weight on consistency-only evidence.

## End card

`Source: Scottcjn/Rustchain — RIP-PoA Anti-Emulation Findings`

`Research, not marketing claims.`

### Editing notes

- Keep each source crop on screen long enough to verify the highlighted phrase.
- Do not imply that RustChain currently has a solved anti-emulation system; the source explicitly says the frontier remains open.
- Do not show exploit commands from older red-team material.
