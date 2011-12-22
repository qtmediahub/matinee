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
    property int columns: 7

    states: State {
        name: "active"
        PropertyChanges { target: root; opacity: 1 }
    }

    MediaModel {
        id: musicModel
        mediaType: "music"
        structure: "artist|album|title"
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    MusicParticles {
        anchors.fill: parent
    }

    Item {
        id: myGrid
        anchors.fill: parent

        Repeater {
            id: repeaterView
            model: musicModel
            delegate: Image {
                id: viewDelegate
                source: {
                    if (model.dotdot) return "../images/folder-music.png"
                    else if (model.previewUrl == "" ) return "../images/default-media.png"
                    else return model.previewUrl
                }

                x: (index%root.columns)*width
                y: Math.floor(index/root.columns)*width

                width: 256
                height: width

                smooth: true

                opacity: index === root.currentIndex ? 1 : 0.6
                scale: index === root.currentIndex ? 1.5 : 1

                transform: Rotation {
                    id: rot
                    axis { x: 1; y: 0; z: 0 }
                    angle: index === root.currentIndex ? 360 : 0
                    origin { x: viewDelegate.width/2; y: viewDelegate.height/2; }

//                    NumberAnimation on angle {
//                        running: index === root.currentIndex
//                        loops: Animation.Infinite
//                        from: 0; to: 360; duration: 2000
//                        alwaysRunToEnd: true
//                    }
                    Behavior on angle {
                        NumberAnimation { duration: 1000 }
                    }
                }

                Behavior on opacity {
                    NumberAnimation {}
                }

                Behavior on scale {
                    NumberAnimation { duration: 1000 }
                }
            }
        }
    }

    SequentialAnimation {
        id: goIntoAnimation
        alwaysRunToEnd: true
        NumberAnimation {
            target: myGrid
            property: "scale"
            to: 20
            duration: 250
            easing.type: Easing.InQuad
        }
        NumberAnimation {
            target: myGrid
            property: "scale"
            from: 0
            to: 1
            duration: 4000
            easing.type: Easing.OutBack
            easing.overshoot: 0.2
        }
    }

    Keys.onDeletePressed: root.back()
    Keys.onLeftPressed: root.currentIndex = root.currentIndex > 0 ? root.currentIndex-1 : repeaterView.count-1
    Keys.onRightPressed: root.currentIndex = root.currentIndex < repeaterView.count-1 ? root.currentIndex+1 : 0
    Keys.onDownPressed: root.currentIndex = (root.currentIndex/root.columns) < repeaterView.count/root.columns-1 ? root.currentIndex+root.columns : root.currentIndex%root.columns
    Keys.onUpPressed: root.currentIndex = root.currentIndex-root.columns
    Keys.onEnterPressed: {
        goIntoAnimation.restart()
//        if (musicModel.part == "artist" || musicModel.part == "album")
//            musicModel.enter(root.currentIndex)
    }

    Behavior on opacity {
        NumberAnimation { duration: 2000 }
    }
}
