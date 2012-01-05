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
        text: Qt.formatDateTime(root.now, "hh:mm:ss")
        font.pixelSize: matinee.bigFont
        style: Text.Sunken
        color: "white"
        anchors.right: parent.right
        Behavior on text {
            SequentialAnimation {
            ScriptAction { script: waveAnim.restart() }
            PauseAnimation { duration: 350 }
            PropertyAction {}
            }
        }
    }

    Column {
        ShaderEffect {
            id: shaderEffect1
            width: theSource.sourceItem.width
            height: theSource.sourceItem.height

            property variant source: ShaderEffectSource {
                id: theSource
                sourceItem: timeLabel
                smooth: true
                hideSource: true
            }

            property real wave: 0.3
            property real waveOriginX: 0.5
            property real waveOriginY: 0.5
            property real waveWidth: 0.1
            property real aspectRatio: width/height

            NumberAnimation on wave {
                id: waveAnim
                running: false
                easing.type: "InQuad"
                from: 0.0000; to: 0.9000;
                duration: 500
            }

            fragmentShader:
                "
                varying mediump vec2 qt_TexCoord0;
                uniform sampler2D source;
                uniform highp float wave;
                uniform highp float waveWidth;
                uniform highp float waveOriginX;
                uniform highp float waveOriginY;
                uniform highp float aspectRatio;

                void main(void)
                {
                    mediump vec2 texCoord2 = qt_TexCoord0;
                    mediump vec2 origin = vec2(waveOriginX, (1.0 - waveOriginY) / aspectRatio);

                    highp float fragmentDistance = distance(vec2(texCoord2.s, texCoord2.t / aspectRatio), origin);
                    highp float waveLength = waveWidth + fragmentDistance * 0.25;

                    if ( fragmentDistance > wave && fragmentDistance < wave + waveLength) {
                        highp float distanceFromWaveEdge = min(abs(wave - fragmentDistance), abs(wave + waveLength - fragmentDistance));
                        texCoord2 += sin(1.57075 * distanceFromWaveEdge / waveLength) * distanceFromWaveEdge * 0.08 / fragmentDistance;
                    }

                    gl_FragColor = texture2D(source, texCoord2.st);
                }
                "
        }

        Text {
            id: dateLabel
            text: Qt.formatDateTime(root.now, "dddd dd MMM yyyy")
            font.pixelSize: matinee.mediumFont
            style: Text.Sunken
            color: "silver"
            anchors.right: parent.right
        }
    }
}
