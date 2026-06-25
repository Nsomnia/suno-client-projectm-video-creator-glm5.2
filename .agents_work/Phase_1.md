## Phase 1: Arch Linux Environment, Scaffolding & CMake Build System

# Phase 1: Environment Scaffolding & CMake Build System

You are a senior C++23 software architect and DevOps lead operating autonomously on an Arch Linux development desktop. Your token budget is large but finite; keep your code modular, heavily prioritize modern C++ paradigms, and avoid verbose conversational output. Your primary immediate goal is scaffolding the project.

## Context & Persistence Rules
1. **Directory Rules (RULES.md):** Create a root `RULES.md` specifying project conventions: strict C++23, composition over inheritance, and Qt 6 memory management (parent-child object trees). No conversational fluff.
2. **Skill Tracking (.agent/SKILLS.md):** Create `.agent/SKILLS.md` to log compiler flags, package manager commands (e.g., `pacman`, `vcpkg`), and build execution commands you use. Keep this file updated as your persistent memory.

## Tasks
1. **Scaffold Directory Structure:**
   Create the following granular folders:
   - `/apps/app_shell` (Main executable)
   - `/libs/engine/rendering` (Visuals)
   - `/libs/engine/audio` (DSP / Analysis)
   - `/libs/network/suno` (API clients)
   - `/libs/ui/qml` (Frontend interfaces)
   - `/user_scratch` (Git-ignored directory for cloning reference repos and testing)
   - `/.agent/logs` (Execution logs)

2. **Establish the Build System:**
   - Create a root `CMakeLists.txt` configured for C++23, Ninja, and `CPM.cmake` (download CPM.cmake into `cmake/CPM.cmake`).
   - Configure CMake to locate **Qt 6.8+ (Targeting 6.11.1 on Arch)** using standard `find_package()` (Core, Quick, Quick3D, Qml, Network, Gui).
   - If Qt or dependencies are missing, output a clean CMake `message(FATAL_ERROR ...)` detailing the exact Arch Linux `pacman` packages required.
   - Setup a `vcpkg.json` stub for future Windows cross-compilation support, but prioritize the Arch Linux native toolchain for current builds.
   - Enforce `-Wall -Wextra -Wpedantic` and treat warnings as errors.

3. **Verify Compilation:**
   - Create a minimal "Hello World" Qt Quick C++ main entrypoint and `main.qml` in `/apps/app_shell` to confirm the compiler, linker, and Qt package discovery function correctly.
   - Execute the CMake configuration and Ninja build. Log the standard output to `/.agent/logs/phase_1_build.log`.
   - Iterate until the basic Qt window successfully compiles and runs.
