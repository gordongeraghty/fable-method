# fable-orchestrate

The method governs one agent doing one task. This skill governs the layer above: one orchestrator directing many executors across a program of work (PR waves, migrations, parallel builds, scheduled sweeps). Its stance is fixed: **the orchestrator never executes.** It writes contracts, dispatches, verifies adversarially, and integrates. The moment the strongest model starts typing the bulk work itself, you are paying orchestrator rates for executor work and losing the independent check that makes delegation safe.

Read `fable-method/SKILL.md` first: its rules govern every agent this skill dispatches. fable-loop runs one task with subagents; this skill runs many tasks with many agents. When in doubt: one deliverable, use the loop; a program of deliverables, use this.

## Usage

```
/fable-orchestrate <program>        plan the wave, write contracts, dispatch, verify, integrate
/fable-orchestrate contract <task>  write one dispatch contract and stop (no dispatch)
/fable-orchestrate audit            grade a completed wave against this skill
```

## Stage 1: Decompose and contract

1. **Delegation threshold.** Any item beyond roughly 15 minutes of mechanical effort gets a contract and an executor. Below that, the orchestrator may do it directly (the triviality gate applies).
2. **The contract is self-contained.** Dispatched agents inherit nothing: no conversation, no implied context. Every contract carries, verbatim:
   - `FILES:` the exact files or surfaces in scope (needing anything outside them is a surprise, reported not taken)
   - `ACCEPT:` the acceptance criteria as observations (this test passes, this output shows X)
   - `CONSTRAINTS:` the standing prohibitions plus any task-specific ones
   - `MODEL:` the tier, set explicitly, never inherited
   - `VERIFY:` which gates the executor must run and paste output from
3. **Freeze shared contracts before fan-out.** When tracks touch a shared interface, pin it in every contract before any dispatch; vague tracks collide.
4. **Ownership map.** Two agents never own the same file in the same wave. If a file must be shared, serialize the tracks or split the file.

## Stage 2: Dispatch

5. **Tier routing.** The strongest model orchestrates and judges only. The middle tier executes: building, integration, review, tests. When unsure between tiers, pick the cheaper and escalate on failure.
   - **Small-tier dispatch warning, measured:** in one production harness with long dispatch briefs, 5 of 7 small-tier subagents died at launch on prompt length before doing any work. If contracts plus context routinely approach the small tier's window, set a mid-tier floor and say so in the plan; the failure mode is death at dispatch, not graceful degradation.
   - A lower model never makes a high-stakes unverifiable judgment. It gets schemas, checklists, and refusal conditions; anything it scores as uncertain routes up a tier.
6. **Isolation.** Parallel agents that mutate files run in separate worktrees. Parallel agents never append to a shared log or memory file: the orchestrator logs centrally.
7. **Collision guard.** Before dispatching into a repo: is another live session working there? Unexplained new files or mtimes? Stand down, revert only your own pollution, report.
8. **Parallelize the independent, serialize the dependent.** Independent tracks dispatch in one batch; dependent stages get a reviewer gate between them.

## Stage 3: Verify (the backstop)

9. **Independent verification.** The verifier is never the implementer. Prompt it to REFUTE: "prove this diff wrong or incomplete", never "check this looks good".
10. **The controller backstop is non-optional.** Executor and reviewer reports are claims. Before integrating any track, the orchestrator personally:
    - re-runs the real gates (the actual test, build, or lint command, not a wrapped or summarized one) and reads the output;
    - greps for the conventions the wave is known to break;
    - fact-checks paths and stack claims against the tree.
    One reviewer's approval is signal, not proof. Write one line per track that must appear verbatim in the report: `BACKSTOP: re-ran <gate> on <track>, <result>`.
    (Measured origin: reviewers passed the same convention breach three times; one claimed a clean grep that was not clean.)
11. **Failures route, never retry blind.** A failed track goes back to its executor with the failing output pasted into a revised contract. After three failed dispatch-verify cycles on the same track: stop the track and hand it back with a hypothesis (fable-method's hard bound, applied per track).

## Stage 4: Integrate and report

12. **Authorization gate on integration.** Merging, pushing, deploying, and publishing are outward actions: fable-method's AUTH gate applies unchanged. Waves open PRs; a human merges, or their exact quoted words do.
13. **Blocked-on-human handling.** The moment a track is blocked on something only the human can do (credentials, consent, spend), write the ledger row: item, needed-for, exact how-to, evidence-when-cleared. Batch the rows into one checklist at the end; never drip questions mid-wave, and never idle waiting.
14. **Report per fable-method Step 6.** Outcome first; per-track results with pasted gate output; failed tracks reported as failed; `BACKSTOP:` lines present for every integrated track; ledger rows batched at the end.

## Never

- Never hand-execute bulk work from the orchestrator seat.
- Never dispatch without `FILES` + `ACCEPT` + `CONSTRAINTS` + `MODEL` + `VERIFY`.
- Never let a subagent inherit the orchestrator's model tier by default.
- Never integrate on an executor's or reviewer's report alone.
- Never let parallel agents share a mutable file or log.
- Never merge, push, deploy, or publish without the AUTH gate satisfied.

## Evidence status

New in this fork, documentation-grade. Distilled from an operating doctrine measured in production waves (a 22-agent PR sweep resolving 21 open PRs; 7 of 7 first-pass approvals on pinned-contract waves; the small-tier dispatch failure above), but not yet through this repo's A/B trap harness. Its trap fixture is `eval/scenarios/s15-controller-backstop/`; the A/B rounds (2+ seeds, bare vs skill) are the declared debt, and per the prime directive no rule here claims a measured number of its own until they run.
