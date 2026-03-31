import QtQuick
import QtQuick.Controls
import Bobink
import QtQuick.Effects
import "."
import "../.."

Button{
    id: button
    implicitWidth: 100
    implicitHeight: 50



    property string labelText: ""
    property bool clickable: true
    property string nodeId: ""
    property bool bordered: true
    property color btnColor: "#3a3b40"

    property real maxFontSize: width * 0.2  // taille max
    property real minFontSize: 8            // taille min pour pas être illisible
    property int optimalPixelSize: 12 // default value
    onLabelTextChanged: {
        label.text = labelText
        fontCalcTimer.restart()
    }

    onWidthChanged: {fontCalcTimer.restart() }
    onHeightChanged: { fontCalcTimer.restart()}


    Rectangle {
        width: parent.width
        height: parent.height
        radius: 12 * Constants.scaleFactor
        anchors.centerIn: parent
        color: button.btnColor
        border.width: bordered ? 1 * Constants.scaleFactor : 0
        border.color: "#F0F0F0" //"#56629d"
    }

    states: State {
        name: "pressed"
        when: button.pressed
        PropertyChanges {
            target: button
            opacity: 0.6
        }
    }

    transitions: Transition {
        from: "*"
        to: "pressed"
        reversible: true
        NumberAnimation {
            properties: "opacity"
            duration: 100
        }
    }

    FontMetrics {
        id: fm
        font: label.font
    }

    Text {
        id: label
        anchors.centerIn: parent
        color: appTheme.moduleText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        font.pixelSize: button.optimalPixelSize
        text: button.labelText
        function calculateFontSize() {
            var size = button.maxFontSize
            while (size > button.minFontSize) {
                fm.font.pixelSize = size  // Ceci est toujours "à risque", voir plus bas
                var lines = label.text.split("\n")
                var maxLineWidth = 0
                var totalHeight = 0

                for (var i = 0; i < lines.length; i++) {
                    var rect = fm.boundingRect(lines[i])
                    maxLineWidth = Math.max(maxLineWidth, rect.width)
                    totalHeight += rect.height
                }

                if (maxLineWidth <= button.width * 0.95 &&
                        totalHeight <= button.height * 0.95) {
                    break
                }
                size -= 1
            }
            return size
        }

        // Timer utilisé pour déclencher le calcul de la taille du texte après le rendu initial.
        // Permet d’éviter un binding loop qui surviendrait si le font.pixelSize était calculé
        // dynamiquement à partir de FontMetrics dans une propriété liée.
        Timer {
            id: fontCalcTimer
            interval: 1
            running: true
            repeat: false
            onTriggered: {
                button.optimalPixelSize = label.calculateFontSize()
            }
        }
    }

    Rectangle {
        width: parent.width
        height: parent.height
        radius: Constants.dp(12)
        anchors.centerIn: parent
        color: "#606060"
        border.width: bordered ? 1 * Constants.scaleFactor : 0
        border.color: "#b3b3b3" //"#56629d"
        opacity: 0.75
        visible: !button.enabled
    }

    background: Rectangle{
        color: "transparent"
    }

    // Connections {
    //     target: appTheme
    //     onCurrentThemeChanged: radialCanvas.requestPaint()
    // }
    onPressed: {
        if (opcuaLoader.item) {
            opcuaLoader.item.writeValue(true)
            console.log("DEBUG\t" + button.nodeId + " is pressed")
        }
    }
    onReleased: {
        if (opcuaLoader.item) {
            opcuaLoader.item.writeValue(false)
            console.log("DEBUG\t" + button.nodeId + " is released")
        }
    }

    Loader {
        id: opcuaLoader
        active: button.nodeId !== ""
        sourceComponent: opcuaNodeComponent
    }

    Component {
        id: opcuaNodeComponent
        OpcUaMonitoredNode {
            monitored: button.visible
            id: opcuaNode
            nodeId: button.nodeId
            // onValueChanged: button.value = value
        }
    }
}
