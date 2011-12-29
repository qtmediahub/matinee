/*
 * Copyright (C) 2010 Johannes Zellner <webmaster@nebulon.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA
 */

import QtQuick 2.0
import QtQuick.Particles 2.0
import IpAddressFinder 1.0

FocusScope {
    id: root
    anchors.fill: parent
    clip: true
    state: ""
    scale: 1

    signal activateView(var type)

    transform: [
        Rotation {
            id: rootRot
            axis { x: 0; y: 1; z: 0 }
            origin { x: root.width; y: root.height/2 }
            angle: 0
        },
        Rotation {
            id: rootRot2
            axis { x: 1; y: 0; z: 0 }
            origin { x: root.width/2; y: root.height }
            angle: 0
        }
    ]

    states: [
        State {
            name: "active"
            PropertyChanges {
                target: rootRot
                angle: 0
            }
            PropertyChanges {
                target: root
                scale: 1
            }
        },
        State {
            name: "musicInactive"
            PropertyChanges {
                target: rootRot
                angle: -45
            }
            PropertyChanges {
                target: root
                scale: 0.8
            }
            PropertyChanges {
                target: rootRot2
                angle: 0
            }
        },
        State {
            name: "pictureInactive"
            PropertyChanges {
                target: rootRot
                angle: -45
            }
            PropertyChanges {
                target: root
                scale: 0.8
            }
            PropertyChanges {
                target: rootRot2
                angle: 0
            }
        },
        State {
            name: "videoInactive"
            PropertyChanges {
                target: rootRot2
                angle: 50
            }
            PropertyChanges {
                target: root
                scale: 0.8
                opacity: 0.5
            }
            PropertyChanges {
                target: rootRot
                angle: 0
            }
        }
    ]

    transitions: [
        Transition {
            from: ""
            NumberAnimation { property: "scale"; duration: 600; easing.type: Easing.OutQuad }
            NumberAnimation { property: "angle"; duration: 300; easing.type: Easing.OutQuad }
            NumberAnimation { property: "opacity"; duration: 1000; easing.type: Easing.OutQuad }
        },
        Transition {
            NumberAnimation { property: "scale"; duration: 1200; easing.type: Easing.OutQuad }
            NumberAnimation { property: "angle"; duration: 600; easing.type: Easing.OutQuad }
            NumberAnimation { property: "opacity"; duration: 1000; easing.type: Easing.OutQuad }
        }
    ]

    Item {
        id: container
        anchors.fill: parent

        Image {
            anchors.fill: parent
            source: "../images/air.jpg"
            smooth: true
        }

        PreviewGrid {
            id: previewGrid
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height/1.5
            width: parent.width*2
            mediaType: mainMenu.mediaType
        }

        Emitter {
            system: particleSystem

            ParticleSystem {
                id: particleSystem

                ImageParticle {
                    system: particleSystem
                    alpha: 0
                    source: "../images/particle_circle_2.png"
                }
            }

            emitRate: 0.1
            lifeSpan: 40000

            y: parent.height
            x: 0
            width: parent.width

            speed: PointDirection {x: 0; y: -20; xVariation: 10; yVariation: 2;}
            speedFromMovement: 8
            size: 40
            sizeVariation: 20
        }

        Emitter {
            system: particleSystem2

            ParticleSystem {
                id: particleSystem2

                ImageParticle {
                    system: particleSystem2
                    alpha: 0
                    source: "../images/particle_circle_3.png"
                }
            }

            emitRate: 0.1
            lifeSpan: 40000

            y: parent.height
            x: 0
            width: parent.width

            speed: PointDirection {x: 0; y: -20; xVariation: 10; yVariation: 2;}
            speedFromMovement: 8
            size: 40
            sizeVariation: 20
        }

        Clock {
            id: clockItem
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 20
        }

        MainMenu {
            id: mainMenu

            height: 300
            width: parent.width
            anchors.bottom: parent.bottom
            focus: true

            onActivateView: root.activateView(type)
        }

        Text {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            text: ipAddressFinder.ipAddresses[0]

            IpAddressFinder {
                id: ipAddressFinder
            }
        }
    }

    Component.onCompleted: {
        mainMenu.forceActiveFocus()
    }
}
