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

FocusScope {
    id: matinee
    width: 1280
    height: 720
//    width: 1920
//    height: 1080

    property int bigFont: matinee.width / 25
    property int mediumFont: matinee.width / 50
    property int smallFont: matinee.width / 70

    property variant activeView: root

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    function showView(view) {
        matinee.activeView.scale = 0
        matinee.activeView = view
        matinee.activeView.scale = 1
        matinee.activeView.forceActiveFocus()
    }

    MusicView {
        id: musicView
        anchors.fill: parent
        onBack: matinee.showView(root)
    }

    FocusScope {
        id: root
        anchors.fill: parent
        opacity: 1

        Behavior on scale {
            NumberAnimation { duration: 2000 }
        }

        Image {
            anchors.fill: parent
            source: "../images/air.jpg"
            smooth: true
        }

        Clock {
            id: clockItem
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 20
        }

        PreviewGrid {
            id: previewGrid
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height/1.5
            width: parent.width*2
            mediaType: mainMenu.mediaType
        }

        MainMenu {
            id: mainMenu

            height: 300
            width: parent.width
            anchors.bottom: parent.bottom
            focus: true

            onActivateView: {
                if (type === "music") {
                    matinee.showView(musicView);
                }
            }
        }

        Component.onCompleted: {
            mainMenu.forceActiveFocus()
        }
    }
}
