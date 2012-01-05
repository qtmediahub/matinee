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
import Qt3D 1.0
import Qt3D.Shapes 1.0

Viewport {
    id: root
    width: parent.width
    height: parent.height
    navigation: false

    property int columns: 3
    property int spacing: 2
    property int xOffset: 2
    property int yOffset: -4

    property int currentIndex: -1

    states: [
        State{
            name: "selected"
            PropertyChanges { target: mainCamera; eye: Qt.vector3d(0, 0, -4) }
        }
    ]

    function showCurrentItem() {
        if (root.state === "")
            root.state = "selected"
        else
            root.state = ""
    }

    function incrementCurrentIndex() {
        root.currentIndex = (root.currentIndex+1 >= pictureModel.count) ? pictureModel.count-1 : root.currentIndex + 1;
    }

    function decrementCurrentIndex() {
        root.currentIndex = (root.currentIndex-1 < 0) ? 0 : root.currentIndex - 1;
    }

    light: Light {
        ambientColor: "white"
    }

    camera: Camera {
        id: mainCamera
        eye: Qt.vector3d(repeaterView.itemAt(root.currentIndex).x,repeaterView.itemAt(root.currentIndex).y,-5)
        center: Qt.vector3d(0, 0, 0)
        farPlane: 10000
        nearPlane: 1

        Behavior on eye {
            Vector3dAnimation {}
        }
    }

    ListModel {
        id: pictureModel
        ListElement { previewUrl: "../images/audio/hopeful_expectations.jpg"; artist: "Expectations" }
        ListElement { previewUrl: "../images/audio/calle_n.jpg"; artist: "Calle N" }
        ListElement { previewUrl: "../images/audio/soundasen.jpg"; artist: "Soundasen" }
        ListElement { previewUrl: "../images/audio/amphetamin.jpg"; artist: "Amphetamin" }
        ListElement { previewUrl: "../images/audio/enemy_leone.jpg"; artist: "Enemy Leone" }
        ListElement { previewUrl: "../images/audio/ensueno.jpg"; artist: "Ensueno" }
        ListElement { previewUrl: "../images/audio/hopeful_expectations.jpg"; artist: "Expectations" }
        ListElement { previewUrl: "../images/audio/calle_n.jpg"; artist: "Calle N" }
        ListElement { previewUrl: "../images/audio/soundasen.jpg"; artist: "Soundasen" }
    }

    Repeater {
        id: repeaterView
        model: pictureModel
        delegate: Cube {
            id: viewDelegate
            effect: Effect {
                texture: {
                    if (model.dotdot) return ""
                    else if (model.previewUrl == "" ) return "../images/default-media.png"
                    else return model.previewUrl
                }
//                color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1)
                blending: true
            }

            x: {
                if (root.state === "selected") {
                    if (root.currentIndex === index) return 3 + root.xOffset;
                    else return 30;
                } else return (index % root.columns) * root.spacing + root.xOffset;
            }
            y: (root.currentIndex === index && root.state === "selected" ? 2 : Math.floor(index / root.columns) * root.spacing) + root.yOffset;
            z: 5

            scale:  {
                if (root.currentIndex === index) {
                    if (root.state === "selected") return 5;
                    else return 3;
                } else return 1.5;
            }

            Behavior on scale {
                NumberAnimation {}
            }

            Behavior on x {
                 NumberAnimation {}
            }

            Behavior on y {
                 NumberAnimation {}
            }

            transform: Rotation3D {
                axis: Qt.vector3d(0,1,0)
                angle: 0

                NumberAnimation on angle {
                    running: root.currentIndex === index && root.state === "selected"
                    loops: Animation.Infinite
                    from: 0; to: 360; duration: 2000
                    alwaysRunToEnd: true
                }
            }
        }
    }

    Component.onCompleted: root.currentIndex = 0
}
