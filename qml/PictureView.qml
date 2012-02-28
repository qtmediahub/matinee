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

    property int currentIndex: 0

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
        mediaType: "picture"
        structure: "fileName"
    }

    Image {
        anchors.fill: parent
        source: "../images/air.jpg"
        smooth: true
        cache: false
    }

    Item {
        id: pictureGridContainer
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left

        width: parent.width
        height: childrenRect.height

        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: 0.5
        }

        GridView {
            id: pictureGrid


            width: cellWidth * 3
            height: matinee.height/1.2

            focus: true
            cellHeight: 256
            cellWidth: cellHeight
            model: pictureModel

            highlightRangeMode: GridView.StrictlyEnforceRange
            preferredHighlightBegin: height/3
            preferredHighlightEnd: height/3
            highlightMoveDuration: 500

            delegate: Item {
                id: delegate

                width: GridView.view.cellWidth
                height: GridView.view.cellHeight
                opacity: GridView.isCurrentItem ? 1 : 0.5
                z: GridView.isCurrentItem ? 1 : 0
                rotation: GridView.isCurrentItem ? -45 + (Math.random() * 90) : 0

                Behavior on opacity {
                    NumberAnimation {}
                }

                Behavior on rotation {
                    RotationAnimation {
                        duration: 2000
                        easing.type: Easing.OutElastic
                    }
                }

                Image {
                    source: {
                        if (model.dotdot) return ""
                        else if (model.previewUrl == "" ) return "../images/default-media.png"
                        else return model.previewUrl
                    }
                    width: parent.width-20
                    height: parent.height-20
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }
            }
        }
    }

    ShaderEffectSource {
        id: theSource2
        sourceItem: pictureGridContainer
        smooth: true
        hideSource: true
    }

    ShaderEffect {
        width: theSource2.sourceItem.width
        height: theSource2.sourceItem.height
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left

        property variant src: theSource2
        property real alpha: 0.5

        fragmentShader:
            "
            varying highp vec2 qt_TexCoord0;
            uniform sampler2D src;
            uniform lowp float qt_Opacity;
            uniform lowp float alpha;

            void main() {
                highp vec4 tex = texture2D(src, vec2(qt_TexCoord0.x, qt_TexCoord0.y));

                if (qt_TexCoord0.y < alpha)
                    tex.rgba = tex.rgba * qt_TexCoord0.y * (1./0.2);
                if (qt_TexCoord0.y > (1. - alpha))
                    tex.rgba = tex.rgba * (1.-qt_TexCoord0.y) * (1./0.2);

                gl_FragColor = tex * qt_Opacity;
            }
            "
    }

    //    PictureViewViewport {
    //        id: viewport
    //        anchors.fill: parent
    //    }

    //    Text {
    //        anchors.top: parent.top
    //        anchors.horizontalCenter: parent.horizontalCenter
    //        text: pictureModel.get(viewport.currentIndex).artist
    //        font.pixelSize: 40
    //        color: "white"
    //    }

    Keys.onMenuPressed: root.back()
    //    Keys.onEnterPressed: viewport.showCurrentItem()
    //    Keys.onRightPressed: viewport.decrementCurrentIndex()
    //    Keys.onLeftPressed: viewport.incrementCurrentIndex()
}
