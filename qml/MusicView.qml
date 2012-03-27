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
        structure: "album|track,title"
        dotDotPosition: MediaModel.Nowhere
    }

    Image {
        anchors.fill: parent
        source: "../images/air.jpg"
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

        Keys.onEnterPressed: {
            trackModel.sqlCondition = "\"artist\" = \"" + listView.currentItem.artist + "\""
            listView.currentItem.active = true;
            listView.currentItem.albumGridView.focus = true;
        }

        Keys.onMenuPressed: {
            if (listView.currentItem.active) {
                listView.currentItem.active = false;
                listView.currentItem.albumGridView.focus = false;
                listView.focus = true;
            } else {
                root.back();
            }
        }

        Keys.onContext1Pressed: {
            print("play artist")
        }

        delegate: Rectangle {
            id: delegate

            property string artist: model.artist
            property bool active: false
            property alias albumGridView: albumGridView

            width: listView.width
            height: albumGridView.height + cover.height + cover.anchors.margins*2
            clip: true
            opacity: ListView.isCurrentItem ? 1 : 0.4
            color: ListView.isCurrentItem ? "#44000000" : "#00000000"
            state: active ? "active" : ""

            Behavior on color { ColorAnimation {} }
            Behavior on opacity { NumberAnimation {} }
            Behavior on height { NumberAnimation { easing.type: Easing.OutBack; duration: 500 } }

            states : [
                State {
                    name: "active"
                    AnchorChanges { target: artistText; anchors.top: cover.top; anchors.verticalCenter: undefined }
                    PropertyChanges { target: albumText; opacity: 0.5 }
                }
            ]

            transitions: [
                Transition {
                    AnchorAnimation { }
                    NumberAnimation { }
                }
            ]

            Image {
                id: cover
                width: 64
                height: width
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 10
                source: model.previewUrl != "" ? model.previewUrl : "../images/default-media.png"
                smooth: true
            }

            MatineeMediumText {
                id: artistText
                anchors.verticalCenter: cover.verticalCenter
                anchors.left: cover.right
                anchors.leftMargin: 10
                text: model.artist
            }

            MatineeMediumText {
                id: albumText
                anchors.top: artistText.bottom
                anchors.left: cover.right
                anchors.leftMargin: 10
                opacity: 0
                text: trackModel.part != "album" && albumGridView.currentItem ? albumGridView.currentItem.album : albumGridView.count + " albums by this artist"
            }

            GridView {
                id: albumGridView
                anchors.top: cover.bottom
                x: 150
                width: parent.width - albumGridView.x
                height: delegate.active ? Math.ceil(count/2.0) * cellHeight : 0
                model: trackModel
                clip: true
                opacity: delegate.active ? 1 : 0
                cellWidth: width/2.0
                cellHeight: trackModel.part == "album" ? 64 : 32
                keyNavigationWraps: true
                flow: GridView.TopToBottom

                Behavior on opacity { NumberAnimation { duration: 800 } }

                Keys.onEnterPressed: {
                    if (trackModel.part == "album") {
                        trackModel.enter(albumGridView.currentIndex)
                        albumGridView.currentIndex = 0
                    } else {
                        matinee.mediaPlayer.playBackground(trackModel, albumGridView.currentIndex)
                    }
                }

                Keys.onMenuPressed: {
                    if (trackModel.part != "album") {
                        trackModel.back()
                        albumGridView.currentIndex = 0
                    } else {
                        event.accepted = false
                    }
                }

                Keys.onContext1Pressed: {
                    print("play album by context key "+albumGridView.currentIndex)
                }

                // we need to explicitly handle them
                Keys.onUpPressed: moveCurrentIndexUp()
                Keys.onDownPressed: moveCurrentIndexDown()

                delegate: Item {
                    id: albumDelegate
                    property string album: model.album ? model.album : ""

                    width: GridView.view.cellWidth
                    height: GridView.view.cellHeight
                    opacity: GridView.isCurrentItem ? 1 : 0.5
                    transformOrigin: Item.Left

                    Image {
                        id: delegateAlbumIcon
                        source: (model.dotdot || model.previewUrl == "") ? "../images/default-media.png" : model.previewUrl
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.margins: 5
                        width: height
                        height: parent.height-5
                        smooth: true
                        visible: trackModel.part == "album"
                    }

                    MatineeMediumText {
                        width: parent.width - anchors.leftMargin - delegateAlbumIcon.width
                        anchors.left: delegateAlbumIcon.right
                        anchors.leftMargin: 20
                        anchors.verticalCenter: parent.verticalCenter
                        text: model.dotdot ? "back" : trackModel.part == "album" ? model.album : (model.track ? model.track : "") + " " + model.title
                    }

                    NumberAnimation {
                        id: delegateAnimation
                        target: albumDelegate
                        property: "scale"
                        from: 0
                        to: 1
                        duration: 500
                        easing.type: Easing.OutBack
                    }

                    Component.onCompleted: delegateAnimation.restart()
                }
            }
        }
    }
}
