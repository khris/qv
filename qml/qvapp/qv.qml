import QtQuick 1.0

import "core.js" as Core

Rectangle {
    id: base

    width: 640
    height: 360
    color: "#333333"

    Item {
        id: container
        state: ""

        width: 300
        height: 300

        anchors.right: parent.right
        anchors.rightMargin: y - parent.y
        anchors.verticalCenter: parent.verticalCenter

        property int rotationCount: 0
        property int lastRotationCount: 0

        Item {
            id: board
            anchors.fill: parent
        }

        Timer {
            id: watingRotation

            interval: 600
            repeat: false
            running: false

            onTriggered: {
                Core.rotateTable()
                Core.applyGravity()
            }
        }

        transitions: [
            Transition {
                from: "*"
                to: "rotating"

                SequentialAnimation {
                    RotationAnimation {
                        duration: 200
                        direction: RotationAnimation.Clockwise
                    }

                    ScriptAction {
                        script: {
                            container.lastRotationCount = container.rotationCount
                            container.state = "rotated"
                        }
                    }
                }
            },
            Transition {
                from: "rotating"
                to: "rotated"

                ScriptAction {
                    script: {
                        watingRotation.stop()
                        watingRotation.start()
                    }
                }
            },
            Transition {
                from: "*"
                to: "aligning"

                SequentialAnimation {
                    PauseAnimation { duration: 200 }
                    ScriptAction { script: { container.state = "" } }
                }
            }
        ]

        states: [
            State {
                name: "rotating"
                PropertyChanges {
                    target: container
                    rotation: container.rotationCount * 90
                }
            },
            State {
                name: "rotated"
                PropertyChanges {
                    target: container
                    rotation: container.lastRotationCount * 90
                }
            },
            State {
                name: "aligning"
            }

        ]

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onClicked: {
                if(mouse.button == Qt.RightButton) {
                    if(container.state != "aligning") {
                        Core.deselectAll()
                        container.rotationCount = (parent.rotationCount + 1) % 4
                        container.state = "rotating"
                    }
                } else if(mouse.button == Qt.LeftButton) {
                    switch(container.state) {
                        case "aligning":
                        case "rotating": {
                            break
                        }
                        case "rotated": {
                            watingRotation.stop()
                            Core.floodFill(board.childAt(mouse.x, mouse.y))
                            Core.rotateTable()
                            Core.applyGravity()
                            break
                        }
                        default: {
                            Core.floodFill(board.childAt(mouse.x, mouse.y))
                            Core.applyGravity()
                            break
                        }
                    }
                }
            }
        }
    }

    Text {
        id: rotationCountText
        x: 310
        width: 80
        color: "#ffffff"
        text: "엘린 옷벗기는 발칙한 게임"
        anchors.bottom: parent.bottom
        anchors.top: container.bottom
        font.family: "Malgun Gothic"
        font.pointSize: 17
        font.bold: true
        verticalAlignment: Text.AlignVCenter
    }

    Component.onCompleted: {
        Core.initBoard()
    }
}
