// apps/app_shell/main.qml
// Phase 1: minimal Qt Quick window. Confirms QML loading + rendering.
// Phase 5 replaces this with the cinematic multi-page shell.

import QtQuick
import QtQuick.Window

Window {
    id: root
    width: 1280
    height: 720
    minimumWidth: 960
    minimumHeight: 540
    visible: true
    title: qsTr("Suno Creator — Phase 1 Scaffold")
    color: "#0b0e14"

    // Phase 1 smoke-test surface: proves the GPU pipeline renders.
    Rectangle {
        id: phaseBadge
        anchors.centerIn: parent
        width: phaseText.implicitWidth + 64
        height: phaseText.implicitHeight + 32
        radius: 12
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: "#1f6feb" }
            GradientStop { position: 1.0; color: "#0d2d5e" }
        }
        border.color: "#3a7bd5"
        border.width: 1

        Text {
            id: phaseText
            anchors.centerIn: parent
            text: qsTr("Suno Creator\nPhase 1 — Toolchain Verified\nv%1").arg(appBuildVersion)
            color: "#e6edf3"
            font.pixelSize: 22
            font.weight: Font.DemiBold
            horizontalAlignment: Text.AlignHCenter
            lineHeightMode: Text.FixedHeight
            lineHeight: 30
        }

        // Gentle animated pulse — confirms the render loop is actually ticking.
        SequentialAnimation on scale {
            loops: Animation.Infinite
            NumberAnimation { to: 1.04; duration: 900; easing.type: Easing.OutSine }
            NumberAnimation { to: 1.0;  duration: 900; easing.type: Easing.InOutSine }
        }
    }
}
