import QtQuick 1.0

Item {
    id: base

    width: 160
    height: 60

    visible: count > 1

    property int count: 0

    Behavior on count {
        ScriptAction { script: { base.state = ""; base.state = "countdown" } }
    }

    transitions: [
        Transition {
            from: "*"
            to: "countdown"

            SequentialAnimation {
                NumberAnimation {
                    target: countText
                    properties: "anchors.topMargin, opacity"
                    easing.type: Easing.OutQuad
                    duration: 2500 - (Math.min(3, Math.max(0, base.count)) * 10)
                }
                ScriptAction { script: { base.count = 0 } }
            }
        }
    ]

    states: [
        State {
            name: "countdown"
            when: base.count > 0
            PropertyChanges { target: countText; anchors.topMargin: -30 }
            PropertyChanges { target: countText; opacity: 0.0 }
        }
    ]

    Text {
        id: countText

        text: base.count + " Combo"

        anchors.top: base.top
        anchors.topMargin: 30

        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter

        color: "#ffffff"
        font {
            family: "Malgun Gothic"
            bold: true
            pointSize: 24
            italic: true
        }
    }
}
