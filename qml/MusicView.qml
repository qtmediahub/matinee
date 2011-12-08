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

FocusScope {
    id: root
    width: 800
    height: 480

    signal back()

    property int currentIndex: 0
    property real delegateZ: 0

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    //    Image {
    //        anchors.fill: parent
    //        source: "../images/stripes.png"
    //    }

    Viewport {
        id: viewport
        width: parent.width
        height: parent.height
        navigation: false

        //        Skybox {
        //            source: "skybox"
        //        }

        light: Light {
            ambientColor: "white"
        }

        camera: Camera {
            id: main_camera
            property real myScale: 0
            eye: Qt.vector3d(10, -10, 20)
            center: Qt.vector3d(0, 0, 0)
            farPlane: 10000
            nearPlane: 5
        }

        Repeater {
            id: repeaterView
            model: 50
            delegate: Cube {
                id: viewDelegate
                effect: Effect {
                    texture: "../images/test/" + (index % 9) + ".png"
                }

                x: (index%10)*1.5-7.5;
                y: Math.floor(index/10)*1.5-2
                z: root.delegateZ

                SequentialAnimation on scale {
                    loops: Animation.Infinite
                    running: index != root.currentIndex
                    alwaysRunToEnd: true
                    NumberAnimation { to: 0; duration: Math.random()*10000 }
                    NumberAnimation { to: 1; duration: Math.random()*10000 }
                    PauseAnimation { duration: 10000 }
                }

                NumberAnimation {
                    running: index === root.currentIndex
                    target: rot;
                    loops: Animation.Infinite
                    property: "angle";
                    to: 360; duration: 2000
                    alwaysRunToEnd: true
                }

                transform: Rotation3D {
                    id: rot
                    axis: Qt.vector3d(1,1,1)
                    angle: 0
                }
            }
        }
    }

    SequentialAnimation {
        id: goIntoAnimation
        alwaysRunToEnd: true
        NumberAnimation {
            target: root
            property: "delegateZ"
            to: 20
            duration: 250
            easing.type: Easing.InQuad
        }
        NumberAnimation {
            target: root
            property: "delegateZ"
            from: -1000
            to: 0
            duration: 2000
            easing.type: Easing.OutBack
            easing.overshoot: 0.2
        }
    }

    Keys.onDeletePressed: root.back()
    Keys.onLeftPressed: root.currentIndex = root.currentIndex > 0 ? root.currentIndex-1 : repeaterView.model
    Keys.onRightPressed: root.currentIndex = root.currentIndex < repeaterView.model-1 ? root.currentIndex+1 : 0
    Keys.onEnterPressed: goIntoAnimation.start()

    Behavior on scale {
        NumberAnimation { duration: 2000 }
    }
}
