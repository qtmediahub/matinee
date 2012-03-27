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

Rectangle {
    id: root

    width: 250
    height: volumeLabel.height + 10
    anchors.centerIn: parent
    opacity: 0
    scale: 0
    color: "#aaffffff"
    state: ""

    states: [
        State {
            name: "visible"
            PropertyChanges {
                target: root
                opacity: 1
                scale: 1
            }
        }
    ]

    transitions: [
        Transition {
            to: "visible"
            NumberAnimation { properties: "scale,opacity"; easing.type: Easing.OutBack }
        },
        Transition {
            to: ""
            NumberAnimation { properties: "scale,opacity"; easing.type: Easing.InBack }
        }
    ]

    Timer {
        id: displayTimer
        interval: 1000
        onTriggered: root.state = ""
    }

    Rectangle {
        color: "white"
        height: parent.height
        width: matinee.mediaPlayer.volume*parent.width

        onWidthChanged: {
            root.state = "visible"
            displayTimer.restart()
        }

        Behavior on width {
            NumberAnimation { easing.type: Easing.OutBack }
        }
    }

    MatineeMediumText {
        id: volumeLabel
        text: "Volume"
        color: "#66000000"
        anchors.centerIn: parent
    }
}
