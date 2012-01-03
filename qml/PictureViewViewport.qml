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
    property int xOffset: 5
    property int yOffset: 0
    property int spacing: 2

    property int currentIndex: 0

    light: Light {
        ambientColor: "white"
    }

    camera: Camera {
        id: mainCamera
        property real myScale: -30
        property real myScale2: 10
        property real center1: 0
        eye: Qt.vector3d(20, myScale2, myScale)
        center: Qt.vector3d(0, 0, center1)
        farPlane: 10000
        nearPlane: 5
    }

    ListModel {
        id: pictureModel
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

            x: (index % root.columns) * root.spacing + root.xOffset;
            y: Math.floor(index / root.columns) * root.spacing + root.yOffset;
            z: root.currentIndex === index ? -6 : 1
            scale: root.currentIndex === index ? 3 : 1.8

            Behavior on z {
                 NumberAnimation { duration: 500; easing.type: Easing.OutBack }
            }

            transform: Rotation3D {
                axis: Qt.vector3d(0,1,0)
                angle: 0

                NumberAnimation on angle {
                    running: root.currentIndex == index
                    loops: Animation.Infinite
                    from: 0; to: 360; duration: 2000
                    alwaysRunToEnd: true
                }
            }
        }
    }

    SequentialAnimation {
        id: goIntoAnimation
        alwaysRunToEnd: true
        NumberAnimation {
            target: mainCamera
            property: "center1"
            to: -10
            duration: 250
        }
        NumberAnimation {
            target: mainCamera
            property: "center1"
            from: 40
            to: 0
            duration: 400
            easing.type: Easing.OutBack
        }
    }
}
