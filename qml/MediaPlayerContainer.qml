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

Item {
    id: root
    width: 1280
    height: 720

    property alias mediaPlayer: avPlayer

    AVPlayer {
        id: avPlayer
        anchors.fill: parent


    }

    Image {
        id: icon
        anchors.centerIn: parent
        source: "../images/media-playback-pause.png"
        opacity: 0
        scale: 1
        smooth: true
        state: avPlayer.paused ? "pause" : "play"

        states: [
            State {
                name: "pause"
                PropertyChanges {
                    target: icon
                    source: "../images/media-playback-pause.png"
                    opacity: 1
                    scale: 1
                }
            },
            State {
                name: "play"
                PropertyChanges {
                    target: icon
                    source: "../images/media-playback-play.png"
                    opacity: 0
                    scale: 4
                }
            }
        ]

        transitions: [
            Transition {
                from: "play"
                to: "pause"
                NumberAnimation { property: "opacity"; duration: 500; }
                NumberAnimation { property: "scale"; duration: 400; }
            },
            Transition {
                from: "pause"
                to: "play"
                NumberAnimation { property: "opacity"; duration: 300; }
                NumberAnimation { property: "scale"; duration: 400; }
            }
        ]
    }
}
