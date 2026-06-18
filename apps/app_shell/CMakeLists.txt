# apps/app_shell — main executable target.
# Phase 1: minimal Qt Quick window to verify the toolchain end-to-end.

# QTP0001: use the modern ':/qt/qml/' resource prefix for QML modules (Qt 6.8+).
# Set before qt_add_qml_module so the dev warning is suppressed and behavior is pinned.
qt_policy(SET QTP0001 NEW)

qt_add_executable(suno_creator
    main.cpp
)

# QML module: ships main.qml so the app has a visible window.
# qt_add_qml_module bundles QML + registers the URI for Qt 6.11.
qt_add_qml_module(suno_creator
    URI SunoCreator
    VERSION 1.0
    QML_FILES
        Main.qml
)

# Link the Qt modules the whole app will eventually need (cheap to include now,
# confirms linkability early). Main target only needs Core/Gui/Quick.
target_link_libraries(suno_creator PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
)

# Bring the project version into the binary for the Phase 6 diagnostics HUD.
target_compile_definitions(suno_creator PRIVATE
    SUNO_VERSION="${PROJECT_VERSION}"
)

# Make the runtime find its QML without a system install (in-tree dev runs).
set_target_properties(suno_creator PROPERTIES
    WIN32_EXECUTABLE FALSE   # keep a console for early dev logging
    MACOSX_BUNDLE FALSE
)
