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

    signal back()

    function updateContextContent() {
        if (state == "active")
            runtime.contextContent.newContextContent("matinee", "Picture.qml", pictureModel.getIdList())
        else
            runtime.contextContent.invalidateContextContent()
    }

    property int currentIndex: 0

    states: State {
        name: "active"
        PropertyChanges { target: root; opacity: 1 }
    }


    transitions: [
        Transition {
            ScriptAction { script: updateContextContent() }
            NumberAnimation { property: "opacity"; duration: 2000 }
        }
    ]



    MediaModel {
        id: pictureModel
        mediaType: "picture"
        structure: "year|month|fileName"
    }

    Image {
        anchors.fill: parent
        source: "../images/air.jpg"
        smooth: true
        cache: false
        opacity: matinee.mediaPlayer.active ? 0 : 1
        Behavior on opacity { NumberAnimation {} }
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

                property bool isLeaf: model.isLeaf

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
                        if (model.dotdot) return "../images/folder-grey.png"
                        else if (model.previewUrl == "" ) return "../images/default-media.png"
                        else return model.previewUrl
                    }
                    width: parent.width-20
                    height: parent.height-20
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }

                GridView.onAdd: NumberAnimation {
                    target: delegate
                    property: "scale"
                    from: 0
                    to: 1
                    easing.type: Easing.OutBack
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


    Item {
        id: slideShow
        width: parent.width
        height: parent.height
        x: parent.width
        state: ""

        states: [
            State {
                name: "active"
                PropertyChanges { target: slideShow; x: 0 }
                PropertyChanges { target: slideShowBackground; opacity: 1 }
                ParentChange { target: slideShow; parent: root.parent }
            }
        ]

        transitions: [
            Transition {
                to: "active"
                SequentialAnimation {
                    ParentAnimation { target: slideShow }
                    ScriptAction { script: { slideShowListView.focus = true } }
                    NumberAnimation { property: "x"; duration: 1000; easing.type: Easing.OutBounce; easing.amplitude: 0.2 }
                    NumberAnimation { property: "opacity"; duration: 500; }
                }
            },
            Transition {
                to: ""
                SequentialAnimation {
                    NumberAnimation { properties: "x, opacity"; duration: 500; }
                    ParentAnimation { target: slideShow }
                    ScriptAction { script: { root.focus = true; pictureGrid.focus = true } }
                }
            }
        ]

        Rectangle {
            id: slideShowBackground
            anchors.fill: parent
            color: "black"
            opacity: 0
        }

        ListView {
            id: slideShowListView

            anchors.fill: parent
            orientation: ListView.Horizontal
            snapMode: ListView.SnapToItem
            highlightRangeMode: ListView.StrictlyEnforceRange
            highlightMoveDuration: 500
            highlightMoveSpeed: -1
            highlightFollowsCurrentItem: true
            model: pictureModel
            clip: true

            function rotateCurrentItem(angle) {
                // ensure to always be 90degree aligned
                slideShowListView.currentItem.rotation = Math.round((slideShowListView.currentItem.rotation + angle) / 90) * 90
            }

            delegate: Item {
                width: slideShowListView.width
                height: slideShowListView.height
                Image {
                    id: image
                    fillMode: Image.PreserveAspectFit
                    sourceSize.width: imageThumbnail.width > imageThumbnail.height ? parent.width : 0
                    sourceSize.height: imageThumbnail.width <= imageThumbnail.height ? parent.height : 0
                    anchors.fill: parent
                    source: model.filepath ? model.filepath : ""
                    asynchronous: true
                }
                Image {
                    id: imageThumbnail
                    anchors.fill: image
                    fillMode: Image.PreserveAspectFit
                    visible: image.status != Image.Ready
                    source: model.previewUrl ? model.previewUrl : ""
                }

                Behavior on rotation { NumberAnimation { easing.type: Easing.OutBack; duration: 500 } }
            }

            Keys.onDownPressed: slideShowListView.rotateCurrentItem(90)
            Keys.onUpPressed: slideShowListView.rotateCurrentItem(-90)

            Keys.onEnterPressed: slideShow.state = ""
            Keys.onMenuPressed: slideShow.state = ""
        }
    }

    Connections {
        target: runtime.contextContent
        onItemSelectedById: {
            if (slideShow.state === "") {
                slideShow.state = "active"
            }
            slideShowListView.currentIndex = pictureModel.indexById(id)
        }
    }


    Keys.onMenuPressed: root.back()
    Keys.onEnterPressed: {
        if (pictureGrid.currentItem.isLeaf) {
            if (slideShow.state === "") {
                slideShowListView.highlightMoveDuration = 0
                slideShowListView.currentIndex = pictureGrid.currentIndex
                slideShowListView.highlightMoveDuration = 500
                slideShow.state = "active"
            }
        } else {
            pictureModel.enter(pictureGrid.currentIndex)
            pictureGrid.currentIndex = 0
        }
    }
}
