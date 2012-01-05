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
    visible: false

    property bool waving: true

    signal back()

    states: State {
        name: "active"
        PropertyChanges { target: root; opacity: 1; visible: true }
    }

    transitions: [
        Transition {
            to: ""
            SequentialAnimation {
                NumberAnimation { property: "opacity"; duration: 500 }
                PropertyAction { properties: "opacity, visible" }
            }
        },
        Transition {
            to: "active"
            SequentialAnimation {
                PropertyAction { properties: "visible" }
                NumberAnimation { property: "opacity"; duration: 2000 }
            }
        }
    ]

        Image {
            id: qtLogo
            source: "../images/qtlogo.png"
            smooth: true
            width: 256
            height: 256
            fillMode: Image.PreserveAspectFit
        }

        ShaderEffect {
            id: shaderEffect1
            width: theSource.sourceItem.width
            height: theSource.sourceItem.height
            anchors.left: parent.left
            anchors.leftMargin: 200
            anchors.verticalCenter: parent.verticalCenter

            property variant source: ShaderEffectSource {
                id: theSource
                sourceItem: qtLogo
                smooth: true
                hideSource: true
            }

            fragmentShader:
                "
                varying mediump vec2 qt_TexCoord0;
                uniform sampler2D source;

                void main(void)
                {
                    gl_FragColor = texture2D(source, qt_TexCoord0.st);
                }
                "
        }

    Keys.onMenuPressed: root.back()
}
