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

    property variant activeView: mainView

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    function showView(view) {
        if (view == mainView) {
            matinee.activeView.state = ""
            matinee.activeView = view
            matinee.activeView.state = ""
        } else if (view === videoView) {
            matinee.activeView.state = "videoInactive"
            matinee.activeView = view
            matinee.activeView.state = "active"
        } else if (view === pictureView) {
            matinee.activeView.state = "pictureInactive"
            matinee.activeView = view
            matinee.activeView.state = "active"
        } else if (view === musicView) {
            matinee.activeView.state = "musicInactive"
            matinee.activeView = view
            matinee.activeView.state = "active"
        }

        matinee.activeView.forceActiveFocus()
    }

    PictureView {
        id: pictureView
        anchors.fill: parent
        onBack: matinee.showView(mainView)
    }

    VideoView {
        id: videoView
        anchors.fill: parent
        onBack: matinee.showView(mainView)
    }

    MainView {
        id: mainView
        anchors.fill: parent

        onActivateView: {
            if (type === "music") {
                matinee.showView(musicView);
            } else if (type === "picture") {
                matinee.showView(pictureView);
            } else if (type === "video") {
                matinee.showView(videoView);
            }
        }
    }

    MusicView {
        id: musicView
        anchors.fill: parent
        onBack: matinee.showView(mainView)
    }
}
