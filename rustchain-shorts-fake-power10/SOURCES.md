# Sources and Claim Map

All technical claims in this package are grounded in public RustChain repository material. No benchmark numbers or capabilities are invented.

## Primary source

**RustChain — `docs/RIPPOA_TCG_ANTIEMULATION_FINDINGS.md`**  
Permanent source revision used for this package:  
https://github.com/Scottcjn/Rustchain/blob/552fbb3294a855e3828990ebc6e11735abd6cccd/docs/RIPPOA_TCG_ANTIEMULATION_FINDINGS.md

### Claim → source section

| Package claim | Source section / evidence |
|---|---|
| RustChain tested real QEMU/KVM guests, qemu-user TCG, and full-system TCG including a fake POWER10 | `TL;DR` |
| The frontier full-system pseries guest reported `machine=ppc64le` and `cpu=POWER10` | `TL;DR` and `The attack ladder` |
| Its remaining introspection tell was a removable virtio-SCSI / `scsi:vm` artifact | `The attack ladder` / `The frontier case` |
| With that artifact gone, passive rules can classify the fake POWER10 as `physical / exotic-server` | `TL;DR` and `The frontier case` |
| The proposed `ilp_ratio` active probe initially appeared useful but was refuted under adversarial reruns | `Active probe (ilp_ratio) — built, then REFUTED by adversarial testing` |
| TCG `ilp_ratio` overlapped bare-metal results | same active-probe section |
| The research says the anti-emulation frontier remains open | `TL;DR` and active-probe conclusion |
| Interim recommendation: do not grant exotic multipliers from passive evidence alone | `Why this matters for rewards` and `Future fixes` |
| Proposed direction: architecture-specific active probes and fail-safe multiplier caps | `Future fixes`, items 1 and 5 |

## Bounty specification

**Scottcjn/rustchain-bounties#16601 — Distribution Packages**  
https://github.com/Scottcjn/rustchain-bounties/issues/16601

Relevant package category: **C — Shorts / clip kit**, base reward **15 RTC**, requiring a ≤60-second script, vertical visuals or exact capture instructions, hook line, and metadata.

## Editorial guardrails used

- The script does **not** claim RustChain has solved anti-emulation; the source explicitly says the frontier remains open.
- The package does **not** reproduce bypass commands or operational exploitation steps.
- The visual plan asks editors to show the source text itself for the key claims.
- The package distinguishes measured/reproduced research findings from recommendations and future work.
