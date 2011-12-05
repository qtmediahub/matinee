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

import QtQuick 1.1

FocusScope {
    id: root
    width: 800
    height: 480

    property string mediaType: mainMenuModel.get(pathView.currentIndex).mediaType

    ListModel {
        id: mainMenuModel

        ListElement { name: "Music"; icon: "../images/folder-music.png"; mediaType: "music" }
        ListElement { name: "Picture"; icon: "../images/folder-image.png"; mediaType: "picture" }
        ListElement { name: "Video"; icon: "../images/folder-video.png"; mediaType: "video" }
        ListElement { name: "Radio"; icon: "../images/folder-radio.png"; mediaType: "radio" }
    }

    PathView {
        id : pathView

        model: mainMenuModel
        anchors.fill: parent
        preferredHighlightBegin: 400/(pathView.width+200)
        preferredHighlightEnd: 400/(pathView.width+200)
        dragMargin: width
        focus: true
        pathItemCount: 4
        highlightMoveDuration: 1000

        delegate: Item {
            id: delegateItem

            property variant modelData: model
            property real myScale: PathView.pathScale
            property real myOpacity: PathView.textOpacity

            width: 256
            height: 256
            opacity: PathView.opacity

            Image {
                id: iconImage
                source: delegateItem.modelData.icon
                smooth: true
                scale: delegateItem.myScale
                transformOrigin: Item.Bottom
            }

            Text {
                text: delegateItem.modelData.name
                font.pixelSize: matinee.bigFont
                style: Text.Sunken
                color: "white"
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                opacity: delegateItem.myOpacity
            }
        }

        path: Path {

            startX: -100; startY: pathView.height/2.0
            PathAttribute { name: "pathScale"; value: 0.8 }
            PathAttribute { name: "opacity"; value: 0.8 }
            PathAttribute { name: "textOpacity"; value: 0 }

            PathLine { x: 200; y: pathView.height/2.0 }
            PathAttribute { name: "pathScale"; value: 0.8 }
            PathAttribute { name: "textOpacity"; value: 0 }

            PathLine { x: 300; y: pathView.height/2.0 }
            PathAttribute { name: "pathScale"; value: 1.5 }
            PathAttribute { name: "opacity"; value: 1.0 }
            PathAttribute { name: "textOpacity"; value: 1.0 }

            PathLine { x: 400; y: pathView.height/2.0 }
            PathAttribute { name: "pathScale"; value: 0.8 }
            PathAttribute { name: "textOpacity"; value: 0 }

            PathLine { x: pathView.width+100; y: pathView.height/2.0 }
            PathAttribute { name: "pathScale"; value: 0.8 }
            PathAttribute { name: "opacity"; value: 0.8 }
            PathAttribute { name: "textOpacity"; value: 0 }
        }

        Keys.onRightPressed: pathView.incrementCurrentIndex();
        Keys.onLeftPressed: pathView.decrementCurrentIndex();
    }
}
