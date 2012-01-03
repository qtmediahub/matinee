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

//    MediaModel {
//        id: pictureModel
//        mediaType: "picture"
//        structure: "year|month|fileName"
//    }

    ListModel {
        id: pictureModel
        ListElement { previewUrl: "../images/audio/amphetamin.jpg"; artist: "Amphetamin" }
        ListElement { previewUrl: "../images/audio/enemy_leone.jpg"; artist: "Enemy Leone" }
        ListElement { previewUrl: "../images/audio/ensueno.jpg"; artist: "Ensueno" }
        ListElement { previewUrl: "../images/audio/hopeful_expectations.jpg"; artist: "Expectations" }
        ListElement { previewUrl: "../images/audio/calle_n.jpg"; artist: "Calle N" }
        ListElement { previewUrl: "../images/audio/soundasen.jpg"; artist: "Soundasen" }
    }

    Image {
        anchors.fill: parent
        source: "../images/air.jpg"
        smooth: true
        cache: false
    }

    Loader {
        id: myLoader
        anchors.fill: parent
        source: "PictureViewViewport.qml"
    }

    Text {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        text: pictureModel.get(myLoader.item.currentIndex).artist
        font.pixelSize: 40
        color: "white"
    }

    Keys.onDeletePressed: root.back()
}
