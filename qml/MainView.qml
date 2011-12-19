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
    id: root
    anchors.fill: parent
    clip: true
    state: "active"
    scale: 0.8

    signal activateView(var type)

    transform: Rotation {
        id: rootRot
        axis { x: 0; y: 1; z: 0 }
        origin { x: root.width; y: root.height/2 }
        angle: -45
    }

    states: State {
        name: "active"
        PropertyChanges {
            target: rootRot
            angle: 0
        }
        PropertyChanges {
            target: root
            scale: 1
        }
    }

    transitions: [
        Transition {
            from: "active"
            NumberAnimation { property: "scale"; duration: 600; easing.type: Easing.OutQuad }
            NumberAnimation { property: "angle"; duration: 300; easing.type: Easing.OutQuad }
        },
        Transition {
            from: ""
            NumberAnimation { property: "scale"; duration: 1200; easing.type: Easing.OutQuad }
            NumberAnimation { property: "angle"; duration: 600; easing.type: Easing.OutQuad }
        }
    ]

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

        onActivateView: root.activateView(type)
    }

    Component.onCompleted: {
        mainMenu.forceActiveFocus()
    }
}
