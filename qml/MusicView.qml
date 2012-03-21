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

    ListView {
        id: listView
        anchors.fill: parent
        anchors.leftMargin: 50
        anchors.rightMargin: 50
        model: musicModel
        focus: true

        // FIXME!
        onCurrentIndexChanged: {
            trackModel.back()
            trackModel.enter(currentIndex)
        }

        delegate: Rectangle {
            id: delegate
            width: listView.width
            height: (ListView.isCurrentItem ? delegateListView.height : 0) + cover.height

            color: index % 2 ? "#88000000" : "#881A6289"
            clip: true
            opacity: ListView.isCurrentItem ? 1 : 0.6

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
                height: count * 25
                model: trackModel
                clip: true
                opacity: delegate.ListView.isCurrentItem ? 1 : 0

                Behavior on opacity { NumberAnimation { duration: 800 } }

                delegate: Text {
                    width: parent.width
                    opacity: model.dotdot ? 0 : 1
                    text: (model.track ? model.track + " - " : "") + (model.title ? model.title : "unknown")
                    color: "white"
                    font.pixelSize: 20
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
