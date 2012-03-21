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
    property bool currentIndexSelected: false
    property int columns: 3

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

    MediaModel {
        id: musicModel
        mediaType: "music"
        structure: "artist|title"
    }

    MediaModel {
        id: trackModel
        mediaType: "music"
        structure: "artist|title"
    }

    Image {
        anchors.fill: parent
        source: "../images/stripes.png"
        cache: false
        sourceSize.width: parent.width
        opacity: matinee.mediaPlayer.active ? 0 : 1
        Behavior on opacity { NumberAnimation {} }
    }

    Flickable {
        anchors.centerIn: parent
        width: myGrid.width
        height: parent.height
        contentWidth: myGrid.width
        contentHeight: myGrid.height
        contentY:  repeaterView.itemAt(root.currentIndex) ? repeaterView.itemAt(root.currentIndex).y-(height/2-myGrid.cellSize/2) : 0

        Behavior on contentY {
            NumberAnimation { duration: 1000; easing.type: Easing.OutExpo}
        }

        Item {
            id: myGrid
            width: root.columns * (cellSize+spacing)
            height: (Math.floor(repeaterView.count/root.columns)) * (cellSize+spacing)

            property int spacing: 40
            property int cellSize: 256

            Repeater {
                id: repeaterView
                model: musicModel
                delegate:  Item {
                    id: viewDelegate

                    property real swing: 0

                    x: (index%root.columns)*(myGrid.cellSize+myGrid.spacing)
                    y: Math.floor(index/root.columns)*(myGrid.cellSize+myGrid.spacing)
                    width: myGrid.cellSize
                    height: myGrid.cellSize
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
                                x: myGrid.width/2 - viewDelegate.width/2
                                y: myGrid.height/2 - viewDelegate.height/2
                                z: 2
                            }
                            PropertyChanges {
                                target: viewDelegateRotation
                                angle: 360
                            }
                            PropertyChanges {
                                target: viewDelegateRotation2
                                angle: 0
                            }
                            PropertyChanges {
                                target: discContent
                                opacity: 1
                            }
                        }
                    ]

                    transitions: [
                        Transition {
                            to: ""
                            SequentialAnimation {
                                NumberAnimation { target: discContent; property: "opacity" }
                                NumberAnimation { properties: "opacity, scale, x, y, swing"; duration: 500; }
                            }
                        },
                        Transition {
                            SequentialAnimation {
                                NumberAnimation { properties: "opacity, scale, x, y, angle, swing"; duration: 500; }
                                NumberAnimation { target: discContent; property: "opacity" }
                            }
                        }
                    ]

                    Rectangle {
                        id: discContent
                        color: "#111111"
                        anchors.fill: parent
                        opacity: 0

                        Text {
                            id: discContentTitle
                            anchors.top: parent.top
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.topMargin: 40
                            text: model.artist
                            color: "steelblue"
                        }

                        ListView {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.top: discContentTitle.bottom
                            anchors.margins: 10

                            model: trackModel
                            clip: true

                            delegate: Text {
                                width: parent.width
                                horizontalAlignment: Text.AlignHCenter
                                opacity: model.dotdot ? 0 : 1
                                text: (model.track ? model.track + " - " : "") + (model.title ? model.title : "unknown")
                                color: "white"
                                font.pixelSize: 12
                            }
                        }
                    }

                    Item {
                        id: discCover
                        anchors.fill: parent

                        Rectangle {
                            anchors.fill: parent
                            color: "#222222"
                        }

                        transform: [
                            Rotation {
                                axis { x: 0; y: 1; z: 0 }
                                angle: viewDelegate.swing
                                origin { x: viewDelegate.width; y: viewDelegate.height/2; }
                            }
                        ]

                        Image {
                            id: discCoverImage
                            anchors.fill: parent
                            anchors.margins: 10
                            smooth: true
                            source: {
                                if (model.dotdot) return "../images/folder-music.png"
                                else if (model.previewUrl == "" ) return ""
                                else return model.previewUrl
                            }

                            transform: [
                                Rotation {
                                    axis { x: 0; y: 1; z: 0 }
                                    angle: viewDelegate.swing < 90 ? 0 : 180
                                    origin { x: discCoverImage.width/2; y: discCoverImage.height/2; }
                                }
                            ]
                        }
                    }

                    transform: [
                        Rotation {
                            id: viewDelegateRotation
                            axis { x: 1; y: 0; z: 0 }
                            angle: 0
                            origin { x: viewDelegate.width/2; y: viewDelegate.height/2; }
                        },
                        Rotation {
                            id: viewDelegateRotation2
                            axis { x: 0; y: 0; z: 1 }
                            angle: 30-Math.random()*60
                            origin { x: viewDelegate.width/2; y: viewDelegate.height/2; }
                            Behavior on angle {
                                SpringAnimation { spring: 2; damping: 0.2; }
                            }
                        }
                    ]

                    // Timer to avoid too long static screens
                    Timer {
                        interval: 5000
                        running: viewDelegate.state == "selected"
                        repeat: true
                        onTriggered: viewDelegateRotation2.angle = 30-Math.random()*60
                    }
                }
            }
        }
    }

    Keys.onLeftPressed: root.currentIndex = root.currentIndex > 0 ? root.currentIndex-1 : repeaterView.count-1
    Keys.onRightPressed: root.currentIndex = root.currentIndex < repeaterView.count-1 ? root.currentIndex+1 : 0
    Keys.onMenuPressed: {
        if (root.currentIndexSelected) {
            root.currentIndexSelected = false
        } else {
            root.back()
        }
    }
    Keys.onEnterPressed: {
        if (root.currentIndexSelected) {
            trackModel.back()
            root.currentIndexSelected = false
        } else {
            trackModel.enter(root.currentIndex)
            root.currentIndexSelected = true
        }
    }
}
