import QtQuick 1.0

import "core.js" as Core

Rectangle {
    id: base

    width: 800
    height: 480

    color: "#333333"

    Item {
        id: board

        width: 300
        height: 300

        anchors {
            right: base.right
            rightMargin: y - base.y
            verticalCenter: base.verticalCenter
        }

        property int rotationCount: 0
        property int lastRotationCount: 0

        Item {
            id: container
            anchors.fill: board
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
                            board.lastRotationCount = board.rotationCount
                            board.state = "rotated"
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
                    ScriptAction { script: { board.state = "" } }
                }
            }
        ]

        states: [
            State {
                name: "rotating"
                PropertyChanges {
                    target: board
                    rotation: board.rotationCount * 90
                }
            },
            State {
                name: "rotated"
                PropertyChanges {
                    target: board
                    rotation: board.lastRotationCount * 90
                }
            },
            State {
                name: "aligning"
            }
        ]

        MouseArea {
            id: mouseArea
            anchors.fill: board
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onClicked: {
                if(mouse.button == Qt.RightButton) {
                    if(board.state != "aligning") {
                        Core.deselectAll()
                        board.rotationCount = (board.rotationCount + 1) % 4
                        board.state = "rotating"
                    }
                } else if(mouse.button == Qt.LeftButton) {
                    switch(board.state) {
                        case "aligning":
                        case "rotating": {
                            break
                        }
                        case "rotated": {
                            watingRotation.stop()
                            Core.floodFill(container.childAt(mouse.x, mouse.y))
                            Core.rotateTable()
                            Core.applyGravity()
                            break
                        }
                        default: {
                            Core.floodFill(container.childAt(mouse.x, mouse.y))
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
        anchors.top: board.bottom
        font.family: "Malgun Gothic"
        font.pointSize: 17
        font.bold: true
        verticalAlignment: Text.AlignVCenter
    }

    Component.onCompleted: {
        Core.initBoard()
    }
}
