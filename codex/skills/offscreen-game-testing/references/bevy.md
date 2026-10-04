# Bevy implementation notes

This pattern was exercised in Bannerfall with Bevy 0.19. Read the project's installed Bevy source and version before adapting APIs; these snippets describe that implementation, not a cross-version drop-in plugin.

## Render without an OS window

- Gate the harness behind a development feature and an explicit screenshot/scenario setting.
- Disable `bevy::winit::WinitPlugin` for offscreen runs. Use `ScheduleRunnerPlugin::run_loop` to advance the application.
- Keep a virtual `Window` ECS entity if existing layout/input code needs dimensions or a window identifier. With Winit disabled, this is data, not a native desktop window.
- Create an `Image::new_target_texture(width, height, TextureFormat::Rgba8UnormSrgb, None)` and add `TextureUsages::COPY_SRC` to its usage.
- Spawn the real `Camera2d` with `IsDefaultUiCamera` and `RenderTarget::Image(handle.clone().into())`.
- Capture with `Screenshot::image(handle.clone())`, not `Screenshot::primary_window()`. Route completion through the saved-screenshot observer before exiting.
- Make output size explicit and verify actual pixels. Offscreen texture dimensions avoid accidentally comparing Retina window captures with logical window dimensions.

Preserve ordinary F12/window screenshots for human interactive sessions. Screenshot mode should default to offscreen; a separate explicit opt-in can enable visible captures when the user requests them.

## Drive real UI input

Inject Bevy `PointerInput` messages with a `Location` targeting the render image and the intended button/press/release/move actions. Translate logical board coordinates using the UI scale and letterboxing offsets. Inject `KeyboardInput` press/release messages using the virtual window entity. These events stay inside the engine; do not send OS input.

Use persistent clickable cell/button entities. Rebuilding them during pointer hover or selection can invalidate pointer targets and keyboard focus. Rebuild art separately from picking nodes. Offscreen hover may need picking `Pointer<Over>`/`Pointer<Out>` observers rather than a window-only `Interaction` path.

A staged smoke test can:

1. Move to a unit, press/release, and assert selection.
2. Hover a legal destination and assert the route preview exists.
3. Click it and assert the game committed the legal move.
4. Press Escape and assert pause; press a gameplay shortcut and assert no mutation.
5. Resume, navigate with Tab, activate with Enter, and assert the intended menu/action.

Allow event processing between stages and fail with assertions. A final screenshot is supplementary evidence, not the input-test verdict.

## Failures encountered in practice

- Black window screenshots: changing focus or hiding a real window was unreliable. Render-to-texture removed that dependency.
- UI label lifecycle race: deferred text metadata insertion raced labels despawned during Update. In this project, scheduling text scaling in PostUpdate before `UiSystems::Prepare` resolved it. Diagnose the actual schedule instead of applying this ordering blindly.
- Preference persistence: screenshot runs should not change the user's saved configuration.
- Preview state: a forced province battle created from a campaign copy verifies art and engine input, not conquest handoff.

## Bannerfall commands

Run from the relevant checkout after confirming these variables still exist. Use a unique external capture directory instead of `docs/`:

```sh
unset BANNERFALL_SHOT_WINDOW BANNERFALL_SHOT_HOLD
capture_dir=$(mktemp -d /tmp/bannerfall-visual.XXXXXX)
BANNERFALL_SHOT=battle-selected BANNERFALL_SHOT_PROVINCE=Goldreach \
  BANNERFALL_SHOT_PATH="$capture_dir/battle.png" cargo run
BANNERFALL_SHOT=battle-pause BANNERFALL_SHOT_SIZE=1000x800 \
  BANNERFALL_SHOT_PATH="$capture_dir/pause.png" cargo run
BANNERFALL_SHOT=battle-input BANNERFALL_SHOT_PROVINCE=Goldreach \
  BANNERFALL_SHOT_PATH="$capture_dir/input.png" cargo run
```

Ensure inherited `BANNERFALL_SHOT_WINDOW` and `BANNERFALL_SHOT_HOLD` are unset for offscreen automated runs. The current input smoke scenario expects Goldreach. Capture sequences (`BANNERFALL_SHOT_FRAMES`) and reduced-motion captures (`BANNERFALL_SHOT_REDUCED=1`) should also use the same owned artifact directory. Record paths, inspect captures, remove superseded files, and retain only the final review evidence outside Git.
