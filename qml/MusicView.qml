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
        structure: "album|title"
    }

    Image {
        anchors.fill: parent
        source: "../images/stripes.png"
        cache: false
        sourceSize.width: parent.width
        opacity: matinee.mediaPlayer.active ? 0 : 1
        Behavior on opacity { NumberAnimation {} }
    }

    ListView {
        id: listView
        anchors.fill: parent
        anchors.leftMargin: 50
        anchors.rightMargin: 50
        model: musicModel
        focus: true

        onCurrentIndexChanged: {
            trackModel.sqlCondition = "\"artist\" = \"" + listView.currentItem.artist + "\""
        }

        delegate: Rectangle {
            id: delegate

            property string artist: model.artist

            width: listView.width
            height: (ListView.isCurrentItem ? delegateListView.height : 0) + cover.height
            clip: true
            opacity: ListView.isCurrentItem ? 1 : 0.6
            gradient: Gradient {
                GradientStop { position: 0; color: index % 2 ? "#aa000000" : "#aa1A6289" }
                GradientStop { position: 0.2; color: index % 2 ? "#bb000000" : "#bb1A6289" }
                GradientStop { position: 1; color: "#00000000" }
            }


            Behavior on height {
                NumberAnimation { easing.type: Easing.OutBack; duration: 500 }
            }

            Row {
                id: delegateRow
                anchors.top: parent.top
                height: cover.height
                width: parent.width

                Image {
                    id: cover
                    width: 128
                    height: width
                    source: model.thumbnail
                    smooth: true
                }

                Text {
                    id: artist
                    text: model.artist
                    color: "white"
                    elide: Text.ElideRight
                    font.pixelSize: 32
                }
            }

            ListView {
                id: delegateListView
                anchors.top: delegateRow.bottom
                x: 150
                width: parent.width
                height: count * 64
                model: trackModel
                clip: true
                opacity: delegate.ListView.isCurrentItem ? 1 : 0

                Behavior on opacity { NumberAnimation { duration: 800 } }

                delegate: Item {
                    width: parent.width
                    height: 64
                    opacity: model.dotdot ? 0 : 1

                    Image {
                        id: delegateAlbumIcon
                        source: model.previewUrl
                        width: 64
                        height: width
                        smooth: true
                    }

                    Text {
                        anchors.left: delegateAlbumIcon.right
                        anchors.leftMargin: 20
                        anchors.verticalCenter: delegateAlbumIcon.verticalCenter
    //                    text: (model.track ? model.track + " - " : "") + (model.title ? model.title : "unknown")
                        text: model.album
                        color: "white"
                        font.pixelSize: 20
                    }
                }
            }
        }
    }

    Keys.onMenuPressed: {
        root.back()
    }
    Keys.onEnterPressed: {
        matinee.mediaPlayer.playForeground(trackModel, 1)
    }
}
