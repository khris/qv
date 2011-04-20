import QtQuick 1.0
import Qt.labs.particles 1.0

Item {
    id: base

    property int col: 0; property int row: 0
    property int type: 0

    property bool dead: false
    property bool selected: false
    property bool animating: false

    Behavior on y {
        enabled: base.animating
        NumberAnimation { duration: 200 }
    }

    Image {
        id: img

        anchors.fill: parent
        scale: base.selected == true ? 1.0 : 0.9

        source: "res/" + base.type + ".png"
    }

    Particles {
        id: deadEffect

        anchors.centerIn: base
        width: 1; height: 1

        source: "res/dust.png"

        angle: 270; angleDeviation: 360
        velocity: 80; velocityDeviation: 60
        emissionRate: 0
        fadeInDuration: 200; fadeOutDuration: 300
        lifeSpan: 500

        ParticleMotionGravity {
            acceleration:100; xattractor: 0; yattractor: 1000
        }
    }

    states: [
        State {
            name: "alive"
            when: dead == false
            PropertyChanges { target: img; visible: true; }
        },
        State {
            name: "dying"
            when: dead == true
            PropertyChanges { target: img; visible: false; }
            StateChangeScript { script: { deadEffect.burst(100); base.destroy(1000) } }
        }
    ]
}
