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
    id: matinee
    width: 800
    height: 480

    property int bigFont: matinee.width / 25
    property int mediumFont: matinee.width / 50
    property int smallFont: matinee.width / 70

    Image {
        anchors.fill: parent
        source: "../images/stripes.png"
    }

    Clock {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 20
    }

    MainMenu {
        id: mainMenu

        height: 300
        width: parent.width
        anchors.bottom: parent.bottom
        focus: true
    }

    Component.onCompleted: {
        mainMenu.forceActiveFocus()
    }
}
