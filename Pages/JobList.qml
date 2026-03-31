import QtQuick
import QtQuick.Controls
import Bobink
import QtQuick.Layouts
import QtQuick.Effects
import "../Resources/Components"
import "../"

Item {
    id: root

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40 * Constants.scaleFactor
        spacing: 40 * Constants.scaleFactor


        Text {
            Layout.fillWidth: true

            text: qsTr("Liste des jobs")
            font.pixelSize: Math.max(35, parent.width * 0.037)
            font.bold: true
            color: appTheme.bodyText
        }

        Item { Layout.fillHeight: true }

    }

}
