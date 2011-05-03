import QtQuick 1.0

Rectangle {
    id: base
    color: "#40FFFFFF"
    width: buttonText.width + 40
    height: buttonText.height
    radius: 4

    property alias text: buttonText.text

    signal clicked

    Text {
        id: buttonText
        text: "Button"
        color: "#ffffff"
        font.family: "Malgun Gothic"
        font.pixelSize: 36
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.centerIn: base
    }

    MouseArea {
        id: mouseArea
        hoverEnabled: true
        anchors.fill: base

        onClicked: base.clicked()
    }

    states: [
        State {
            name: "hover"
            when: mouseArea.containsMouse
            PropertyChanges { target: base; color: "#80FFFFFF" }
        }
    ]
}
