# CPM.cmake — downloaded at configure time by the root CMakeLists.txt.
# This file is a bootstrap shim: it fetches the official CPM.cmake module from
# the CPM.cmake GitHub release on first configure and caches it here so
# subsequent offline builds work.
#
# Source: https://github.com/ClausKleijn/CPM.cmake (official: cpm-cmake/CPM.cmake)
# The actual download logic lives in the root CMakeLists.txt (`bootstrap_cpm`).
# This placeholder exists so the cmake/ directory is version-controlled and so
# the bootstrap has a stable local path to write to.

# NOTE: If the file `cmake/CPM.cmake.module` exists, it is the real module and
# is included directly by the root CMakeLists. Otherwise the bootstrap fetches it.
