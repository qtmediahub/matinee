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

Item {
    id: root
    width: childrenRect.width
    height: childrenRect.height

    property date now

    Timer {
        id: updateTimer
        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: { root.now = new Date() }
    }

    Text {
        id: timeLabel
        text: Qt.formatDateTime(root.now, "hh:mm:ss AP")
        font.pointSize: 24
        style: Text.Sunken
        color: "white"
    }
}
