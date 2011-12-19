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

    Grid {
        id: myGrid
        anchors.fill: parent

        Repeater {
            id: repeaterView
            model: musicModel
            delegate: Image {
                id: viewDelegate
                opacity: 0.7
                source: {
                    if (model.dotdot) return "../images/folder-music.png"
                    else if (model.previewUrl == "" ) return "../images/default-media.png"
                    else return model.previewUrl
                }

                transform: Rotation {
                    id: rot
                    axis { x: 1; y: 1; z: 1 }
                    angle: 0
                    origin { x: viewDelegate.width/2; y: viewDelegate.height/2; }

                    NumberAnimation on angle {
                        running: true
                        loops: Animation.Infinite
                        from: 0; to: 360; duration: 2000*(1+index)
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
    Keys.onUpPressed: root.currentIndex = (root.currentIndex/6) < repeaterView.count/6-1 ? root.currentIndex+6 : root.currentIndex%6
    Keys.onDownPressed: root.currentIndex = root.currentIndex-6
    Keys.onEnterPressed: {
        goIntoAnimation.restart()
//        if (musicModel.part == "artist" || musicModel.part == "album")
//            musicModel.enter(root.currentIndex)
    }

    Behavior on opacity {
        NumberAnimation { duration: 2000 }
    }
}
