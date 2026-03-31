import QtQuick
import QtQuick.Controls
import Bobink
import QtQuick.Controls 2.15
import QtQuick.Effects
import "../.."

Frame {
    id: menuFrame
    spacing: 0

    property bool hasShadow: false

    background: Item {
        anchors.fill: parent

            MultiEffect {
                 anchors.fill: source
                 source: fondFrame
                 shadowEnabled: true
                 shadowColor: "black"
                 opacity: 0.3
                 visible: hasShadow
             }

            Rectangle {
                id: fondFrame
                anchors.fill: parent
                color: appTheme.gradientMid
            }

        }
}
