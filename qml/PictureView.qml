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
import MediaModel 1.0

FocusScope {
    id: root
    width: 800
    height: 480
    opacity: 0

    signal back()

    property int currentIndex: 0
    property real delegateZ: 0

    states: State {
        name: "active"
        PropertyChanges { target: root; opacity: 1 }
    }

    MediaModel {
        id: pictureModel
        mediaType: "picture"
        structure: "year|month|fileName"
    }

    Image {
        anchors.fill: parent
        source: "../images/air.jpg"
        smooth: true
    }

    Viewport {
        id: viewport
        width: parent.width
        height: parent.height
        navigation: false

        light: Light {
            ambientColor: "white"
        }

        camera: Camera {
            id: mainCamera
            property real myScale: 0
            eye: Qt.vector3d(0, 0, 20)
            center: Qt.vector3d(0, 0, 0)
            farPlane: 10000
            nearPlane: 5
        }

        Repeater {
            id: repeaterView
            model: pictureModel
            delegate: Cube {
                id: viewDelegate
                effect: Effect {
                    texture: {
                        if (model.dotdot) return "../images/folder-music.png"
                        else if (model.previewUrl == "" ) return "../images/default-media.png"
                        else return model.previewUrl
                    }
                    blending: true
                }

                x: (index%6)*1.1-3;
                y: Math.floor(index/6)*1.1-2
                z: root.currentIndex === index ? 4 : 1

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
    Keys.onEnterPressed: goIntoAnimation.start()
    Keys.onLeftPressed: root.currentIndex = root.currentIndex > 0 ? root.currentIndex-1 : repeaterView.count-1
    Keys.onRightPressed: root.currentIndex = root.currentIndex < repeaterView.count-1 ? root.currentIndex+1 : 0
    Keys.onUpPressed: root.currentIndex = (root.currentIndex/6) < repeaterView.count/6-1 ? root.currentIndex+6 : root.currentIndex%6
    Keys.onDownPressed: root.currentIndex = root.currentIndex-6

    Behavior on opacity {
        NumberAnimation { duration: 2000 }
    }
}
