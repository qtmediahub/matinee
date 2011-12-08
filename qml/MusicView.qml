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

    Image {
        anchors.fill: parent
        source: "../images/stripes.png"
        smooth: true
    }

    Viewport {
        id: viewport
        width: parent.width
        height: parent.height

        camera: Camera {
            id: main_camera
            property real myScale: 0
            eye: Qt.vector3d(0, 4, myScale)
            center: Qt.vector3d(0, 0, 0)

            SequentialAnimation on myScale {
                loops: -1
                NumberAnimation { to: 50; duration: 10000 }
                NumberAnimation { to: 10; duration: 10000 }
            }
        }

        Repeater {
            model: 50
            delegate: Cube {
                id: viewDelegate
                effect: Effect {
                    texture: "../images/test/" + (index % 9) + ".png"
                }

                position: Qt.vector3d((index%10)*1.2, index/10, 0)

                SequentialAnimation on scale {
                    loops: -1
                    NumberAnimation { to: 1; duration: Math.random()*10000 }
                    NumberAnimation { to: 0; duration: Math.random()*10000 }
                }

                NumberAnimation {
                    running: true
                    target: rot;
                    loops: Animation.Infinite
                    property: "angle";
                    to: 360; duration: index*10+5000
                }

                transform: Rotation3D {
                    id: rot
                    axis: Qt.vector3d(0,1,0)
                    angle: 0
                }
            }
        }
    }

    Keys.onEscapePressed: root.back()

    Behavior on opacity {
        NumberAnimation { duration: 2000 }
    }
}
