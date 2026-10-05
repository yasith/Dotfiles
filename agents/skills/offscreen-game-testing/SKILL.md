---
name: offscreen-game-testing
metadata:
  author: Yasith Vidanaarachchi
description: Implement and use windowless game screenshot and UI input testing without stealing desktop focus. Use when iterating on game visuals, capturing game screens, building screenshot drivers, testing game menus or controls in the background, or cleaning up visual-test artifacts. Especially relevant to Bevy and other native games where a normal launch opens a window. Keep temporary screenshots out of Git and clean only task-owned artifacts.
---

# Offscreen game testing

Treat desktop focus as part of the test contract. A successful run renders the real game and exercises its UI without creating an OS window, moving the user's pointer, or sending desktop keystrokes.

## Establish the capture path

1. Read the project's agent instructions, architecture, theme contract, and existing screenshot driver before changing code. Check Git status so pre-existing changes and reference images remain distinguishable from your artifacts.
2. Prefer an existing windowless capture mode. Inspect its implementation: a hidden, minimized, unfocused, or quickly closed window is not evidence that it cannot steal focus.
3. If needed, add a development/test-only harness that disables the native window runner, renders through the real camera to a GPU texture, and reads that texture back to a file. Keep the normal interactive launch intact. For Bevy, read [the implementation notes](references/bevy.md).
4. If offscreen rendering is unsupported or fails, diagnose the renderer, target, layout, asset readiness, and readback. Report an actual limitation if blocked. Do not silently fall back to launching a visible game. A visible session requires the user's explicit request for that session.

## Make runs reproducible

- Choose the scenario, seed, screen, selection, viewport size, and preferences explicitly. Allow parameterized scenarios instead of a separate code path per screenshot.
- Exercise the production rendering and layout systems. A mock page or separately drawn approximation cannot validate the game.
- Use a campaign/state copy for arbitrary art previews; identify these as previews rather than evidence of a valid campaign transition.
- Isolate persisted preferences and save data. Suppress writes or point the harness at a task-owned temporary profile. Do not consume gameplay RNG for decorative variation or animation.
- Wait for assets, state transitions, layout, and render submission/readback to complete. Avoid relying solely on a fixed sleep. Bound startup and capture time; exit nonzero with a useful log on failure.
- Await saved-image completion before exiting. Record the exact command, scenario, dimensions, and result alongside the capture.

## Iterate on visuals and behavior separately

1. Capture the relevant baseline before a fix when possible. Confirm the output exists, has the requested dimensions, and contains the intended screen rather than a black frame or loading screen.
2. Inspect the image with an image-viewing tool. Check clipping, alignment, text, contrast, art consistency, layering, and action visibility. Compare at consistent dimensions.
3. Make one coherent change, then capture and inspect the affected states. Include a normal viewport and a narrower/taller one when layout changes. Check selected, disabled, modal, and long-text states when relevant.
4. Test interactions through the engine's actual pointer-picking and keyboard event pipeline. Directly invoking an action handler or mutating selected state is not a pointer test. Use the render target's coordinate system and account for UI scaling and letterboxing.
5. Assert outcomes: selection, hover/route preview, committed movement, keyboard focus/activation, modal input blocking, pause and resume. Screenshots prove appearance; state assertions prove behavior. Neither alone proves native OS-window integration.
6. Run the project's required format, lint, and relevant rule tests. Re-run checks when new changes warrant them, not as an unbounded loop.

Keep the user informed of findings during longer runs. Do not use desktop screen capture or input automation to avoid fixing the offscreen harness.

## Manage screenshot artifacts

Default to a unique task-owned directory outside the checkout, or inside a verified ignored directory such as `target/visual-checks/<run-id>/`. Use explicit output paths for screenshots, frame sequences, logs, temporary profiles, and reports. Check ignore behavior with `git check-ignore <path>` before an in-repository capture; also check `git ls-files -- <path>` because ignore rules do not protect already tracked files.

Keep only evidence needed to make the next decision: one baseline, the latest candidate, and any distinct failing state. After inspecting a replacement, remove superseded task-owned captures and frame sequences. Keep diagnostic logs for unresolved failures. Avoid indefinite numbered-image accumulation.

Before deletion:

- List the exact owned files or use the manifest recorded for this run.
- Confirm resolved paths remain inside the intended artifact directory; do not follow symlinks into other directories.
- Confirm no tracked files, source art, approved references, other agents' outputs, or unrelated runs are included.
- Delete those files only. Avoid broad commands such as `git clean -fdx`, repository-wide image globs, or deleting the whole build directory.

Before finishing:

- Audit `git status --short` and `git diff --cached --name-only` for accidental screenshots, logs, profiles, and recordings. Do not force-add ignored artifacts or stage generated output automatically.
- Keep the final image being shown to the user at a stable external or ignored path and provide an absolute link. State what was retained and where. Do not delete an image immediately after linking it.
- Remove remaining superseded task-owned files and stop only the processes started for this run. Bound retained evidence and clean it after it is no longer needed; retaining a final review image is intentional, not a leak.

Temporary iteration captures should not be committed. Runtime art assets and deliberately versioned visual references are different categories. If the repository already tracks reference screenshots, preserve them unless the user or repository workflow explicitly calls for updating/removing them. Adding an ignore rule does not untrack existing files. A request to write this skill is not permission to purge existing repository images.

## Report the result

Briefly report what changed, which screenshots were inspected, which real input assertions passed, and any limitation. Link the retained final evidence and mention that iteration ran without desktop interaction. Distinguish rendered previews, engine input tests, and true campaign end-to-end tests. Never describe an unrun test as passed.
