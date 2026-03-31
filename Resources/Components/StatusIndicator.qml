import QtQuick 6.7
import QtQuick.Controls.Basic
import QtQuick.Effects
import Bobink
import "../.."

Item {
    id: indicator
    width: 30 * Constants.scaleFactor
    height: width
    property bool switchable: false
    property color color: "green"
    property bool value: false
    property bool enable: false
    property string text: ""
    property var nodeId: ""
    property int index: -1

    signal clicked()

    onClicked: {
        if(indicator.switchable){
            indicator.value = !indicator.value
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            indicator.clicked()
        }
    }

    Canvas {
        id: radialCanvas
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            var innerColor = indicator.value ? Qt.lighter(indicator.color, 1.8) : indicator.color
            var outerColor = Qt.darker(indicator.color, 1.6)

            var cx = width / 2
            var gradient = ctx.createRadialGradient(0.8 * cx, 0.8 * cx, 0, 0.8 * cx, 0.8 * cx, cx)
            gradient.addColorStop(0, innerColor)
            gradient.addColorStop(1, outerColor)

            ctx.beginPath()
            ctx.arc(cx, cx, cx, 0, 2 * Math.PI)
            ctx.fillStyle = gradient
            ctx.fill()
        }
    }
    onColorChanged: radialCanvas.requestPaint()
    onValueChanged: radialCanvas.requestPaint()
    Text {
        anchors.fill: parent
        anchors.centerIn: parent
        visible: indicator.enable
        text: indicator.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        z: 1
    }

    MultiEffect {
        anchors.fill: source
        source: radialCanvas
        shadowEnabled: true
        shadowColor: Qt.lighter(indicator.color, 1.2)
        opacity: 0.75
        visible: indicator.value
    }


    Loader {
        id: opcuaLoader
        active: indicator.nodeId !== ""
        sourceComponent: opcuaNodeComponent
    }

    Component {
        id: opcuaNodeComponent
        OpcUaMonitoredNode {
            monitored: indicator.visible
            nodeId: indicator.nodeId
            onValueChanged: {
                if(index != -1){
                    indicator.value = value[index]
                }
                else{
                    indicator.value = value
                }
            }
        }
    }
}
