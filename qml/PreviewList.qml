/* * Copyright (C) 2010 Johannes Zellner <webmaster@nebulon.de>
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

Item {
    id: root

    width: 800
    height: 480

    transform: Rotation {
        angle: -30 + matinee.width/200
        axis { x: 0; y: 1; z: 0 }
        origin.x: root.width
        origin.y: -50
    }

    property alias mediaType: previewModel.mediaType

    MediaModel {
        id: previewModel
        mediaType: "music"
        structure: mediaType == "music" ? "artist" : "fileName"

        Behavior on mediaType {
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation { target: shaderEffect1; property: "fadeMarginX"; from: 0; to: 3; duration: 1300; }
                    NumberAnimation { target: previewView; property: "contentX"; to: -previewView.width*2; duration: 700; easing.type: Easing.InQuad }
                }

                PropertyAction { target: previewModel; property: "mediaType"}
                PauseAnimation { duration: 100 }
                ParallelAnimation {
                    NumberAnimation { target: shaderEffect1; property: "fadeMarginX"; from: 3; to: 0; duration: 800; }
                    NumberAnimation { target: previewView; property: "contentX"; to: 0; duration: 700; easing.type: Easing.OutQuad }
                }
            }
        }
    }

    ShaderEffectSource {
        id: theSource
        sourceItem: previewView
        smooth: true
        hideSource: runtime.skin.settings.fancy
    }

    ShaderEffect {
        id: shaderEffect1
        width: theSource.sourceItem.width
        height: theSource.sourceItem.height
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        visible: runtime.skin.settings.fancy

        transform: Scale {
            origin.x: parent.width
            origin.y: parent.height/2
            xScale: 2
            yScale: 1
        }

        property real fadeMargin: 0.2
        property real fadeMarginX: 0
        property variant src: theSource

        SequentialAnimation on fadeMargin {
            running: true
            loops: Animation.Infinite
            NumberAnimation { to: 0.1; duration: 4000; easing.type: Easing.OutQuad }
            NumberAnimation { to: 0.2; duration: 4000; easing.type: Easing.OutQuad }
        }

        vertexShader: "
            uniform lowp mat4 qt_Matrix;
            attribute lowp vec4 qt_Vertex;
            attribute lowp vec2 qt_MultiTexCoord0;
            varying lowp vec2 coord;

            void main() {
                coord = qt_MultiTexCoord0;
                gl_Position = qt_Matrix * qt_Vertex;
            }
        "

        fragmentShader: "
            varying lowp vec2 coord;
            uniform sampler2D src;
            uniform lowp float qt_Opacity;
            uniform lowp float fadeMargin;
            uniform lowp float fadeMarginX;

            void main() {
                lowp vec4 tex = texture2D(src, coord);
                lowp vec4 color;

                tex.rgba = tex.rgba + (1. - abs(coord.x - fadeMarginX));

                if (coord.y < fadeMargin)
                    color = tex.rgba * qt_Opacity * coord.y*(1.0/fadeMargin);
                else
                    color = tex.rgba * qt_Opacity;

                gl_FragColor = color * coord.x;
            }
        "
    }

    ShaderEffectSource {
        id: theSource2
        sourceItem: shaderEffect1
        smooth: true
        hideSource: false
    }

    ShaderEffect {
        width: theSource2.sourceItem.width
        height: theSource2.sourceItem.height/2.0
        anchors.right: parent.right
        anchors.top: shaderEffect1.bottom
        visible: runtime.skin.settings.fancy

        transform: Scale {
            origin.x: parent.width
            origin.y: parent.height/2
            xScale: 2
            yScale: 1
        }

        property variant src: theSource2
        property real alpha: 0.3

        SequentialAnimation on alpha {
            loops: -1
            NumberAnimation { to: 0.8; duration: 5000 }
            NumberAnimation { to: 0.3; duration: 5000 }
        }

        fragmentShader:
            "
            varying highp vec2 qt_TexCoord0;
            uniform sampler2D src;
            uniform lowp float qt_Opacity;
            uniform highp float alpha;

            void main() {
                highp vec4 pix = texture2D(src, vec2(qt_TexCoord0.x, 1.0 - qt_TexCoord0.y));
                gl_FragColor = qt_Opacity * pix * alpha; //vec4(pix.r, pix.g, pix.b, pix.a);
            }
            "
    }

    ListView {
        id: previewView
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: parent.height/2
        model: previewModel
        orientation: ListView.Horizontal
        clip: true
        interactive: false

        NumberAnimation {
            id: scrollerAnimation
            running: false
            target: previewView
            property: "contentX"
            to: previewView.contentWidth
            duration: previewView.contentWidth > 0 ? previewView.contentWidth*10 : 0
        }

        delegate: Item {
            id: delegate
            width: ListView.view.height
            height: ListView.view.height

            Image {
                anchors.fill: parent
                source: model.previewUrl
                sourceSize.width: delegate.width
            }
        }
    }
}
