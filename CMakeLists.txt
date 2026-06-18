cmake_minimum_required(VERSION 3.28)

# ─────────────────────────────────────────────────────────────────────────────
# Suno Client / projectM Video Creator
# Root build. C++23, Ninja, Qt 6.11. Native Arch Linux toolchain.
# See RULES.md and .agent/Phase_1.md for conventions and goals.
# ─────────────────────────────────────────────────────────────────────────────

project(suno_creator
    VERSION 0.1.0
    LANGUAGES CXX
    DESCRIPTION "Suno API client + projectM visualizer + cinematic QML karaoke video creator"
)

# ── Standard & flags ────────────────────────────────────────────────────────
# Lock to C++23 globally so every target inherits it.
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)          # -std=gnu++23 → -std=c++23 (strict)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)  # for clangd

# Treat warnings as errors per RULES.md §1. Keep these in a cached var so the
# app target can extend them without clobbering Qt-injected flags.
set(PROJECT_WARN_FLAGS -Wall -Wextra -Wpedantic -Werror)
add_compile_options(${PROJECT_WARN_FLAGS})

# Default to Release if the caller didn't specify; debug builds opt-in explicitly.
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif()

# Auto-use ccache if present — speeds up Qt-template-heavy rebuilds dramatically.
find_program(CCACHE_PROGRAM ccache)
if(CCACHE_PROGRAM)
    set(CMAKE_CXX_COMPILER_LAUNCHER ${CCACHE_PROGRAM})
    message(STATUS "Found ccache: ${CCACHE_PROGRAM}")
endif()

# ── Qt discovery ─────────────────────────────────────────────────────────────
# Phase 1 needs a working Qt Quick window. We require the modules the later
# phases will consume, so discovery fails early with an actionable message
# instead of a cryptic link error in Phase 4/5.
find_package(Qt6 6.8 COMPONENTS
    Core
    Gui
    Network
    Qml
    Quick
    Quick3D
    OpenGL
    Multimedia
    CONFIG
)

if(NOT Qt6_FOUND)
    message(FATAL_ERROR
        "\n  Qt6 (>= 6.8) was not found by CMake.\n"
        "  On Arch Linux install the required Qt6 modules:\n\n"
        "    sudo pacman -S --needed qt6-base qt6-declarative qt6-quick3d \\\n"
        "        qt6-multimedia qt6-shadertools\n\n"
        "  Detected toolchain so far:\n"
        "    C++ compiler : ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION}\n"
        "    CMake        : ${CMAKE_VERSION}\n"
        "    Generator    : ${CMAKE_GENERATOR}\n"
    )
endif()

message(STATUS "Qt ${Qt6_VERSION} found — using system Qt6 at ${Qt6_DIR}")

# Qt MOC/RCC/QMLCACHEGEN automatic handling for all targets created below.
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# ── CPM.cmake bootstrap ─────────────────────────────────────────────────────
# Fetch the real CPM.cmake module on first configure, cache it in cmake/.
# Lets Phase 2/3/4 pull spdlog/nlohmann/projectM via CPMAddPackage without
# each target re-implementing the download logic.
set(CPM_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/CPM.cmake.module")
if(NOT EXISTS "${CPM_MODULE_PATH}")
    message(STATUS "Bootstrapping CPM.cmake ...")
    file(DOWNLOAD
        "https://github.com/cpm-cmake/CPM.cmake/releases/latest/download/CPM.cmake"
        "${CPM_MODULE_PATH}"
        STATUS cpm_status
        SHOW_PROGRESS
    )
    list(GET cpm_status 0 cpm_ec)
    if(cpm_ec)
        list(GET cpm_status 1 cpm_msg)
        message(WARNING "CPM.cmake download failed (${cpm_ec}): ${cpm_msg}. "
                        "External deps (Phase 2+) will not be available. "
                        "Fetch manually if offline.")
    else()
        message(STATUS "CPM.cmake cached at ${CPM_MODULE_PATH}")
    endif()
endif()
if(EXISTS "${CPM_MODULE_PATH}")
    include("${CPM_MODULE_PATH}")
endif()

# ── Subdirectories ───────────────────────────────────────────────────────────
# App is the only target in Phase 1. Libs are added in later phases but the
# directories already exist so a clean tree is ready.
add_subdirectory(apps/app_shell)

# ── Install (minimal, expanded in Phase 6) ───────────────────────────────────
# Phase 6 will define a proper install rule set; for now we only need the binary.
