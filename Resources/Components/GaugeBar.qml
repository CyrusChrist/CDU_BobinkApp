import QtQuick
import QtQuick.Controls
import Bobink
import "../../"

Item {

    id: _item
    width: 200 * Constants.scaleFactor
    height: 40 * Constants.scaleFactor

    required property string nodeId
    property real niveau: niveau
    property color color: "green"
    property bool isVertical: false

    Rectangle {
        width: parent.width
        height: parent.height
        border.color: "#A6A6A6"
        border.width: 5 * Constants.scaleFactor

        Rectangle {
            id: jaugeExtern
            width: parent.width - 2 * Constants.scaleFactor
            height: parent.height - 2 * Constants.scaleFactor
            anchors.centerIn: parent
            color: "grey"

            Rectangle {
                id: jaugeIntern
                width: _item.niveau > 100 ? parent.width  : _item.niveau * parent.width  / 100// 50% rempli
                height: parent.height
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 1.0; color: Qt.darker(_item.color, 1.15) }
                    GradientStop { position: 0.0; color: Qt.lighter(_item.color, 0) }
                }

                // topLeftRadius: 10
                // bottomLeftRadius: topLeftRadius
                Behavior on width { NumberAnimation { duration: 500 } }
            }

            Text {
                id: textNiveau
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                property real verticalOffset: jaugeExtern.width - jaugeIntern.width < textNiveau.width + 4
                                              ? - textNiveau.width - 4
                                              : 4

                x: jaugeIntern.width + verticalOffset
                z: 2
                text: _item.niveau.toFixed(0) + "%"
                font.weight: Font.Bold
                font.pointSize: 10
                color: "#F0F0F0"
                rotation: - _item.rotation
            }

        }
    }

    Connections {
        target: _item
        function onNiveauChanged() {
            var r, g, b, ratio;

            if (_item.niveau <= 10) {
                // Rouge pastel
                r = 255;
                g = 100;
                b = 75;

            } else if (_item.niveau <= 20) {
                // Orange pastel
                ratio = (_item.niveau - 10) / 10; // 0 → 1
                r = 255;
                g = 150 + Math.round(60 * ratio); // 150 → 210
                b = 75;

            } else if (_item.niveau <= 40) {
                // Jaune pastel
                ratio = (_item.niveau - 20) / 20; // 0 → 1
                r = 255;
                g = 210 + Math.round(30 * ratio); // 210 → 240
                b = 75 - Math.round(50 * ratio); // 150 → 100

            } else if (_item.niveau <= 100) {
                // Transition vers vert pastel
                ratio = (_item.niveau - 40) / 60; // 0 → 1
                r = 255 - Math.round(153 * ratio); // 255 → 102
                g = 240 - Math.round(20 * ratio);  // 240 → 220
                b = 75 + Math.round(80 * ratio);  // 100 → 180

            } else {
                r = g = b = 200; // hors bornes, gris clair
            }

            var hex = function(v) {
                var h = v.toString(16);
                return h.length === 1 ? "0" + h : h;
            };

            color = "#" + hex(r) + hex(g) + hex(b);
        }
    }
    OpcUaMonitoredNode {
        monitored: _item.visible
        nodeId: _item.nodeId
        onValueChanged: _item.niveau = value
    }

}
