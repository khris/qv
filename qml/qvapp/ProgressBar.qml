import QtQuick 1.0

Item {
    id: base

    width: 100
    height: 20

    property double percent: 50

    signal percentChangingEnded(double percent)

    Rectangle {
        anchors.fill: parent

        color: "#99000000"
    }

    Rectangle {
        anchors {
            top: base.top
            left: base.left
            bottom: base.bottom
        }

        width: base.width / 100 * base.percent

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#ffff00" }
            GradientStop { position: 1.0; color: "#cccc00" }
        }
    }

    Behavior on percent {
        SequentialAnimation {
            NumberAnimation { duration: 20000 }
            ScriptAction { script: base.percentChangingEnded(base.percent) }
        }
    }
}
