/* * Copyright (C) 2010 Johannes Zellner <webmaster@nebulon.de>
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
import MediaModel 1.0

Item {
    id: root

    width: 800
    height: 480

    property alias mediaType: previewModel.mediaType

    transform: Rotation {
        angle: -30 + matinee.width/200
        axis { x: 0; y: 1; z: 0 }
        origin.x: root.width
        origin.y: -50
    }

    MediaModel {
        id: previewModel
        mediaType: "music"
        structure: "fileName"

        Behavior on mediaType {
            SequentialAnimation {
                PropertyAction { target: scrollerAnimation; property: "running"; value: false}
                NumberAnimation { target: previewView; property: "contentX"; to: -previewView.width*2; duration: 1000; easing.type: Easing.InQuad }
                PropertyAction {}
                PauseAnimation { duration: 500 }
                NumberAnimation { target: previewView; property: "contentX"; to: 0; duration: 1000; easing.type: Easing.OutQuad }
                PropertyAction { target: scrollerAnimation; property: "running"; value: true}
            }
        }
    }

    GridView {
        id: previewView
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: parent.height/2
        cellHeight: height/2
        cellWidth: cellHeight
        model: previewModel
        flow: GridView.TopToBottom
        clip: true
        interactive: false

        NumberAnimation {
            id: scrollerAnimation
            running: false
            target: previewView
            property: "contentX"
            to: previewView.contentWidth
            duration: previewView.contentWidth > 0 ? previewView.contentWidth*10 : 0
        }

        delegate: Image {
            id: delegateImage
            source: model.previewUrl
            width: GridView.view.cellWidth
            height: GridView.view.cellHeight
            sourceSize.width: GridView.view.cellWidth
        }
    }
}
