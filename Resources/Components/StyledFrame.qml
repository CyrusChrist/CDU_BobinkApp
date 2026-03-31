import QtQuick
import QtQuick.Controls
import Bobink
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Effects
import "../.."

Frame {
    id: styledFrame
    property string style: "thin"
    property color shadowColor: "black"


    background: Item {
        anchors.fill: parent
        Rectangle {

            anchors.fill: parent
            opacity: 1
            radius: 15 * Constants.scaleFactor

            gradient: Gradient {
                GradientStop { position: 0.0; color: style === "thin" ? "#A1A1A1"
                                                                      : style === "shadowed" ? "transparent"
                                                                                             : Qt.darker("#A1A1A1") }
                GradientStop { position: 0.8; color:
                        style === "thin" ? Qt.lighter(appTheme.backgroundColor, 1.1)
                                         : style === "shadowed" ? "transparent"
                                                                : Qt.darker("#A1A1A1", 1.1) }
            }

        }

        Rectangle {
            id: liseretBlanc
            width: fond.width + 0.5
            height: fond.height
            anchors.right: fond.right
            anchors.bottom: fond.bottom
            radius: fond.radius
            color: Qt.lighter(fond.color, 1.8)
            visible: styledFrame.style === "shadowed"
        }

        Rectangle {

            id: fond
            anchors.centerIn: parent
            width: styledFrame.width - 2
            height: styledFrame.height - 2
            opacity: 1
            radius: 15 * Constants.scaleFactor
            color: style === "thin" ? appTheme.backgroundColor
                                    : Qt.lighter(appTheme.backgroundColor, 1.1)

        }

        MultiEffect {
            id: blackShadow
            anchors.fill: source
            source: fond
            shadowEnabled: true
            shadowColor: styledFrame.shadowColor
            opacity: 0.4
            visible: style === "shadowed"
        }


    }


}
