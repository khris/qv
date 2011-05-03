import QtQuick 1.0

import "core.js" as Core

Rectangle {
    id: base

    width: 640
    height: 360

    color: "#333333"

    Item {
        id: board

        width: 300
        height: 300
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -10

        property int score: 0

        property int rotationCount: 0
        property int lastRotationCount: 0

        Item {
            id: container
            anchors.fill: board
        }

        Timer {
            id: watingRotation

            interval: 250
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
                    ScriptAction { script: { watingRotation.stop() } }
                    RotationAnimation {
                        easing.type: Easing.InOutCubic
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
                ScriptAction { script: { watingRotation.restart() } }
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
            enabled: base.state == ""
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



    Row {
        id: scoreWidget

        width: board.width

        anchors {
            top: board.bottom
            horizontalCenter: board.horizontalCenter
        }

        Text {
            id: label

            text: "Score"

            color: "#ffffff"
            font {
                family: "Malgun Gothic"
                pointSize: 17
                bold: true
            }

            verticalAlignment: "AlignVCenter"
            horizontalAlignment: "AlignLeft"
        }

        Text {
            id: scoreText

            text: board.score

            width: parent.width - label.width
            color: "#ffffff"
            font {
                family: "Malgun Gothic"
                pointSize: 17
                bold: true
            }

            verticalAlignment: "AlignVCenter"
            horizontalAlignment: "AlignRight"
        }
    }

    Counter {
        id: comboCounter

        anchors.top: board.top
        anchors.right: board.left
    }

    Button {
        anchors {
            bottom: scoreWidget.bottom
            horizontalCenter: scoreWidget.right
            horizontalCenterOffset: (base.width - scoreWidget.width) / 4
        }
        visible: base.state == ""
        text: "Restart"

        onClicked: {
            Core.initGame()
        }
    }

    Rectangle {
        id: fadeRect
        color: "#80000000"
        anchors.fill: parent
        visible: base.state != ""

        Column {
            anchors.centerIn: parent

            Text {
                id: titleText
                color: "#ffffff"
                font.family: "Malgun Gothic"
                font.pixelSize: 72
                width: parent.width
                horizontalAlignment: "AlignHCenter"
            }
            Text {
                id: subTitleText
                color: "#ffffff"
                font.family: "Malgun Gothic"
                font.pixelSize: 36
                width: parent.width
                horizontalAlignment: "AlignHCenter"
            }
            Item {
                width: parent.width
                height: 40
            }
            Button {
                id: startButton
                text: "Yes"

                onClicked: {
                    base.state = ""
                    Core.initGame()
                }
            }
        }
    }

    states: [
        State {
            name: "start"
            PropertyChanges { target: titleText; text: "Welcome!" }
            PropertyChanges { target: subTitleText; text: "Are you ready?" }
        },
        State {
            name: "gameOver"
            PropertyChanges { target: titleText; text: "GAME OVER" }
            PropertyChanges { target: subTitleText; text: "Restart?" }
        }
    ]

    Component.onCompleted: {
        base.state = "start"
        Core.initGame()
    }
}
