import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15
import Bobink
import "../"

Page {
    // Tu déclares la propriété pour recevoir le logger
    property var logger

    ListView {
        anchors.fill: parent
        model: logger ? logger.lines : []
        delegate: Text {
            text: modelData
            font.pixelSize: 12
        }
    }

    Component.onCompleted: {
        console.log("Ceci est un test")
        console.warn("Un avertissement")
        console.error("Une erreur")
    }
}

