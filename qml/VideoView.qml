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
import MediaModel 1.0

FocusScope {
    id: root
    width: 800
    height: 480
    opacity: 0
    visible: false

    signal back()

    states: State {
        name: "active"
        PropertyChanges { target: root; opacity: 1; visible: true }
    }

    transitions: [
        Transition {
            to: ""
            SequentialAnimation {
                PauseAnimation { duration: 2000 }
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

    MediaModel {
        id: pictureModel
        mediaType: "video"
        structure: "fileName"
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    ShaderEffectSource {
        id: theSource
        sourceItem: gridView
        smooth: true
        hideSource: true
    }

    ShaderEffect {
        id: shaderEffect1
        width: theSource.sourceItem.width
        height: theSource.sourceItem.height
        anchors.centerIn: parent

        mesh: GridMesh { resolution: Qt.size(50, 10) }

        property variant src: theSource

        property real parabelY: 0.5
        property real parabelYScale: 1.4
        property real parabelCurveDamping: 0.4

        vertexShader: "
            uniform lowp mat4 qt_Matrix;
            attribute lowp vec4 qt_Vertex;
            attribute lowp vec2 qt_MultiTexCoord0;
            varying lowp vec2 coord;
            uniform lowp float parabelY;
            uniform lowp float parabelYScale;
            uniform lowp float parabelCurveDamping;
            uniform lowp float height;

            void main() {
                vec4 pos = qt_Vertex;
                coord = qt_MultiTexCoord0;
                float x = coord.x;

                x = ((x * 2.) - 1.);            // move between -1 and 1
                x = x * parabelCurveDamping;    // curve damping
                pos.y = pos.y * parabelYScale * (parabelY + x*x);

                gl_Position = qt_Matrix * pos;
            }
        "

        SequentialAnimation on parabelCurveDamping {
            running: false
            loops: -1
            NumberAnimation { to: 0; duration: 2000 }
            NumberAnimation { to: 1; duration: 2000 }
        }

        fragmentShader: "
            varying lowp vec2 coord;
            uniform sampler2D src;
            uniform lowp float qt_Opacity;

            void main() {
                lowp vec4 tex = texture2D(src, vec2(coord.x, coord.y)).rgba;
                gl_FragColor = qt_Opacity * tex;
            }
        "
    }

    GridView {
        id: gridView
        anchors.fill: parent
        flow: GridView.TopToBottom
//        model: pictureModel
        model: 100
        cellHeight: 256
        cellWidth: 130
        currentIndex: 0
        highlightRangeMode: GridView.StrictlyEnforceRange
        preferredHighlightBegin: height/2
        preferredHighlightEnd: height/2
        highlightMoveDuration: 1000
        delegate: Image {
            width: GridView.view.cellWidth
            height: GridView.view.cellHeight
//            source: model.previewUrl
            source: "../images/video/" + index%6 + ".jpg"
            scale: GridView.isCurrentItem ? 1.5 : 1.0
            z: GridView.isCurrentItem ? 2 : 1
            smooth: true
            transformOrigin: index%3 === 0 ? Item.Top : index%3 === 2 ? Item.Bottom : Item.Center

            Behavior on scale {
                NumberAnimation {}
            }
        }
    }

    Keys.onDeletePressed: root.back()
    Keys.onLeftPressed: gridView.moveCurrentIndexLeft()
    Keys.onRightPressed: gridView.moveCurrentIndexRight()
    Keys.onUpPressed: gridView.moveCurrentIndexUp()
    Keys.onDownPressed: gridView.moveCurrentIndexDown()
}
