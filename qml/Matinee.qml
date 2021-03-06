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

    property int bigFont: matinee.width / 25
    property int mediumFont: matinee.width / 50
    property int smallFont: matinee.width / 70

    property variant activeView: mainView
    property variant mainMenuView: mainView
    property alias mediaPlayer: mediaPlayerContainer.mediaPlayer

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    function showView(view) {
        runtime.contextContent.invalidateContextContent()

        if (view == mainView) {
            matinee.activeView.state = ""
            matinee.activeView = view
            matinee.activeView.state = ""
        } else if (view === videoView) {
            matinee.activeView.state = "videoInactive"
            matinee.activeView = view
            matinee.activeView.state = "active"
            runtime.contextContent.newContextContent("matinee", "Video.qml", videoView.getModelIdList())
        } else if (view === pictureView) {
            matinee.activeView.state = "pictureInactive"
            matinee.activeView = view
            matinee.activeView.state = "active"
            runtime.contextContent.newContextContent("matinee", "Picture.qml", pictureView.getModelIdList())
        } else if (view === musicView) {
            matinee.activeView.state = "musicInactive"
            matinee.activeView = view
            matinee.activeView.state = "active"
        } else if (view === settingsView) {
            matinee.activeView.state = "settingsInactive"
            matinee.activeView = view
            matinee.activeView.state = "active"
        }

        matinee.activeView.forceActiveFocus()
    }

    Connections {
        target: runtime.contextContent
        onItemSelectedById: matinee.activeView.selectById(id);
    }

    MediaPlayerContainer {
        id: mediaPlayerContainer
        anchors.fill: parent
    }

    PictureView {
        id: pictureView
        anchors.fill: parent
        onBack: matinee.showView(mainView)
        onRowsInserted: runtime.contextContent.newContextContent("matinee", "Picture.qml", pictureView.getModelIdList())
    }

    VideoView {
        id: videoView
        anchors.fill: parent
        onBack: matinee.showView(mainView)
        onRowsInserted: runtime.contextContent.newContextContent("matinee", "Video.qml", videoView.getModelIdList())
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
            } else if (type === "settings") {
                matinee.showView(settingsView);
            }
        }
    }

    MusicView {
        id: musicView
        anchors.fill: parent
        onBack: matinee.showView(mainView)
    }

    SettingsView {
        id: settingsView
        anchors.fill: parent
        onBack: matinee.showView(mainView)
    }

    VolumeOSD {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 20
    }

    Component.onCompleted: {
        //        runtime.mediaScanner.addSearchPath("music", "/home/jzellner/minimal_media/music/", "music");
        //        runtime.mediaScanner.addSearchPath("video", "/home/jzellner/minimal_media/video/", "video");
        //        runtime.mediaScanner.addSearchPath("picture", "/home/jzellner/minimal_media/picture/", "picture");
    }

    Keys.onVolumeUpPressed: mediaPlayer.increaseVolume();
    Keys.onVolumeDownPressed: mediaPlayer.decreaseVolume();

    Keys.onPressed: {
        event.accepted = true
        if (event.key == Qt.Key_MediaTogglePlayPause) {
            mediaPlayer.togglePlayPause()
        } else if (event.key == Qt.Key_MediaStop) {
            mediaPlayer.stop()
        } else if (event.key == Qt.Key_MediaPrevious) {
            mediaPlayer.playPrevious()
        } else if (event.key == Qt.Key_MediaNext) {
            mediaPlayer.playNext()
        } else {
            event.accepted = false
        }
    }
}

