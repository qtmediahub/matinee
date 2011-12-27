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
    property bool currentIndexSelected: false
    property int columns: 7

    states: State {
        name: "active"
        PropertyChanges { target: root; opacity: 1 }
    }

    MediaModel {
        id: musicModel
        mediaType: "music"
        structure: "artist|title"
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
            delegate:  Item {
                id: viewDelegate

                property real swing: 0

                x: (index%root.columns)*width
                y: Math.floor(index/root.columns)*width
                width: 256
                height: width
                smooth: true
                opacity: 0.4
                scale: 1
                z: 0
                state: root.currentIndex === index ? (root.currentIndexSelected ? "active" : "selected") : ""

                states: [
                    State {
                        name: "selected"
                        PropertyChanges {
                            target: viewDelegate
                            swing: 0
                            scale: 1.5
                            opacity: 1
                            z: 2
                        }
                        PropertyChanges {
                            target: viewDelegateRotation
                            angle: 360
                        }
                    },
                    State {
                        name: "active"
                        PropertyChanges {
                            target: viewDelegate
                            swing: 120
                            scale: 2
                            opacity: 1
                            x: root.width/2 - viewDelegate.width/2
                            y: root.height/2 - viewDelegate.height/2
                            z: 2
                        }
                        PropertyChanges {
                            target: viewDelegateRotation
                            angle: 360
                        }
                    }
                ]

                transitions: [
                    Transition {
                        NumberAnimation { properties: "opacity, scale, x, y, angle, swing"; duration: 1000; }
                    }
                ]

                Rectangle {
                    id: discContent
                    color: "black"
                    anchors.fill: parent

                    Image {
                        source: "../images/media-optical.png"
                        anchors.fill: parent
                        smooth: true

                        Text {
                            id: discContentTitle
                            anchors.top: parent.top
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.topMargin: 40
                            text: model.artist
                            color: "lightsteelblue"
                        }
                    }
                }

                Rectangle {
                    id: discCover
                    color: "black"
                    anchors.fill: parent

                    transform: [
                        Rotation {
                            axis { x: 0; y: 1; z: 0 }
                            angle: viewDelegate.swing
                            origin { x: viewDelegate.width; y: viewDelegate.height/2; }
                        }
                    ]

                    Image {
                        anchors.fill: parent
                        source: {
                            if (model.dotdot) return "../images/folder-music.png"
                            else if (model.previewUrl == "" ) return ""
                            else return model.previewUrl
                        }
                    }
                }

                transform: [
                    Rotation {
                        id: viewDelegateRotation
                        axis { x: 1; y: 0; z: 0 }
                        angle: 0
                        origin { x: viewDelegate.width/2; y: viewDelegate.height/2; }
                    }
                ]
            }
        }
    }

    Keys.onDeletePressed: root.back()
    Keys.onLeftPressed: root.currentIndex = root.currentIndex > 0 ? root.currentIndex-1 : repeaterView.count-1
    Keys.onRightPressed: root.currentIndex = root.currentIndex < repeaterView.count-1 ? root.currentIndex+1 : 0
    Keys.onDownPressed: root.currentIndex = (root.currentIndex/root.columns) < repeaterView.count/root.columns-1 ? root.currentIndex+root.columns : root.currentIndex%root.columns
    Keys.onUpPressed: root.currentIndex = root.currentIndex-root.columns
    Keys.onEnterPressed: {
        if (root.currentIndexSelected) {
            root.currentIndexSelected = false
        } else {
            root.currentIndexSelected = true
        }
    }

    Behavior on opacity {
        NumberAnimation { duration: 2000 }
    }
}
