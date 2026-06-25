# Agent Skills / Persistent Memory

> Append-only operational memory. Log toolchain facts, commands, and gotchas here so
> every future prompt benefits. Update as the build evolves.

## Host Environment (verified 2026-06-18)
- **OS:** Arch Linux (kernel 7.0.12-1-cachyos)
- **Shell:** fish (user), bash/zsh available for scripting
- **Compiler:** GCC 16.1.1 (`/usr/bin/g++`), clang 22.1.6 (`/usr/bin/clang++`) — both C++23 capable
- **CMake:** 4.3.4 (`/usr/bin/cmake`) ✅ (user installed: `sudo pacman -S cmake ccache sccache ninja vcpkg`)
- **Ninja:** 1.13.2 at `/usr/sbin/ninja`
- **pkg-config:** 2.5.1
- **Git:** 2.54.0
- **ccache:** installed (`/usr/sbin/ccache`) ✅
- **sccache:** installed (`/usr/sbin/sccache`) ✅
- **vcpkg:** 2026-05-27 (`/usr/sbin/vcpkg`) ✅

## ⚠️ CRITICAL: PATH Shadowing by ZCode AppImage (MUST READ)
The ZCode harness AppImage dir (`~/.local/share/AppImage/`) is prepended to PATH
in `~/.bashrc`, `~/.zshrc`, and `~/.config/fish/config.fish`. That dir contains
ONLY the `ZCode-3.1.2-linux-x64.AppImage` file — it is NOT a real tool dir.

**Symptom:** invoking `gcc`, `cmake`, `ccache`, etc. by bare name fails:
  - gcc/g++: `fatal error: cannot execute 'cc1': posix_spawnp: No such file or directory`
  - cmake: `CMake Error: Could not find CMAKE_ROOT !!!`
  - ccache: `error: Could not find compiler "ZCode-3.1.2-linux-x64.AppImage"`
`g++ --version` LIES — it prints version fine but actual compilation fails.

**Fix for ALL build commands:** run with a sanitized PATH excluding the AppImage dir:
```fish
env PATH=/usr/bin:/usr/sbin:/bin:/sbin HOME=$HOME <command>
```
Or export at the top of a build script. NEVER run `cmake`/`gcc`/`ninja`/`ccache`
with the default PATH from this harness — they will fail cryptically.
The real tools are all at `/usr/bin` (gcc/g++/cmake/ccache) and `/usr/sbin` (ninja).
Verified: clean-PATH `gcc /tmp/t.c -o /tmp/t` → 15776-byte binary; `cmake --version` → 4.3.4.

## Qt 6 (verified 2026-06-18)
- **Version:** 6.11.1 (exact Phase 1 target) via `qt6-base`, `qt6-declarative`, etc.
- **qmake6:** present, reports "Using Qt version 6.11.1 in /usr/lib"
- **CMake config dir:** `/usr/lib/cmake/Qt6/` — standard `find_package(Qt6 ...)` works once CMake is installed.
- **Relevant modules installed (all 6.11.1):**
  - `qt6-base` — Core, Gui, Network, Widgets, Concurrent, OpenGL, OpenGLWidgets
  - `qt6-declarative` — Qml, Quick, QuickTest, QuickLayouts
  - `qt6-quick3d` — Quick3D + helpers + particles + effects (Phase 5 cinematic)
  - `qt6-multimedia` — audio/video (Phase 4 audio pipeline)
  - `qt6-shadertools` + `qt6-shadertools-private` — runtime shader compilation (projectM fallback shader)
  - `qt6-5compat` — Qt5 compat APIs
  - `Qt6QuickEffects` present → **MultiEffect available** for Phase 5 blur/translucency.
- **`find_package` components to use:** `Core Gui Quick Quick3D Qml Network Multimedia OpenGL`

## projectM (verified 2026-06-18)
- **Installed (pacman):** `projectm 3.1.12-5.1` — ⚠️ **this is v3, NOT the v4.1.6 target in Phase 4.**
- **pkg-config:** `pkg-config --modversion projectM` → 3.1.12
- **Decision (Phase 4, deferred):** use **CPM fetch of projectm v4.1.6** from GitHub rather than the system v3 package, per Phase 4 spec. System v3 may coexist for reference but will NOT be linked.
- **libprojectM shared lib:** not present at `/usr/lib/libprojectm*` — v3 ships headers + the SDL frontend binary. Confirms CPM fetch is the right call for v4.

## Other libs (verified 2026-06-18)
- **spdlog:** installed (pacman) — use system package for logging (Phase 2).
- **nlohmann-json:** installed (pacman) — use system package for config/serialization (Phase 2).
- **OpenGL:** `pkg-config --modversion gl` → 1.2 (GL pkg-config, Mesa underneath).

## Build Commands (canonical)
```fish
# Configure (once CMake is installed)
cmake -S . -B build -G Ninja \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
      -DCMAKE_CXX_COMPILER=g++ \
      -DCMAKE_CXX_STANDARD=23

# Build
cmake --build build

# Run the shell
./build/apps/app_shell/suno_creator
```

## Pacman packages the user still needs to install
```fish
sudo pacman -S cmake ccache
```
- `cmake` — BLOCKER for Phase 1 build verification.
- `ccache` — strongly recommended for rebuild speed (GCC 16 + Qt templates are heavy).

## Gotchas Log
- (empty — append as discovered)
