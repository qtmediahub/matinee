import QtQuick 2.0

Item {
    id: root
    width: 1280
    height: 720

    property alias mediaPlayer: avPlayer

    AVPlayer {
        id: avPlayer
        anchors.fill: parent
    }

    Image {
        id: icon
        anchors.centerIn: parent
        source: "../images/media-playback-pause.png"
        opacity: 0
        scale: 1
        smooth: true
        state: avPlayer.paused ? "pause" : "play"

        states: [
            State {
                name: "pause"
                PropertyChanges {
                    target: icon
                    source: "../images/media-playback-pause.png"
                    opacity: 1
                    scale: 1
                }
            },
            State {
                name: "play"
                PropertyChanges {
                    target: icon
                    source: "../images/media-playback-play.png"
                    opacity: 0
                    scale: 4
                }
            }
        ]

        transitions: [
            Transition {
                from: "play"
                to: "pause"
                NumberAnimation { property: "opacity"; duration: 500; }
                NumberAnimation { property: "scale"; duration: 400; }
            },
            Transition {
                from: "pause"
                to: "play"
                NumberAnimation { property: "opacity"; duration: 300; }
                NumberAnimation { property: "scale"; duration: 400; }
            }
        ]
    }
}
