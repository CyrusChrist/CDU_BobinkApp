import QtQuick 6.7
import QtQuick.Shapes 1.0
import QtQuick.Layouts
import "../../"
import Bobink


Item {
    id: _item

    property real value: value
    property real offset: 1 // Facteur de différence entre la valeur machine et la valeur affichée
    property real fontSize: fontSize
    property string unit: unit
    property real max: 100
    property bool alert: false
    required property string nodeId
    property string style: "circle"

    property real centerX: width / 2
    property real centerY: height / 2

    // Ensure radius is always valid: if width is too small (or 0 during component creation),
    // fallback to a default positive value to avoid invalid arguments in canvas drawing
    property real r: width > 20 ? (width / 2 - 10) : 10
    property real r2: r - 10

    OpcUaMonitoredNode {
        monitored: _item.visible
        nodeId: _item.nodeId
        onValueChanged: _item.value = value * _item.offset
    }

    Item {
        id: circleGauge
        //Layout.alignment: Qt.AlignTop
        anchors.top: parent.top
        width: _item.width
        height: _item.height
        visible: _item.style === "circle"

        Canvas {
            id: _canvas
            width: parent.width
            height: parent.height


            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)


                // Cercle gris
                ctx.beginPath()
                ctx.arc(centerX, centerY, _item.r, 3 * Math.PI / 2, - Math.PI / 2 , false)
                ctx.lineWidth = _item.width * 0.1
                ctx.strokeStyle = appTheme.gradientLight2
                ctx.stroke()

                // Cercle rouge
                ctx.beginPath()
                ctx.arc(centerX, centerY, _item.r, Math.PI / 2, Math.PI / 2 + Math.PI * value / (max / 2), false)
                ctx.lineWidth = _item.width * 0.1
                ctx.strokeStyle = (alert && value >= max) ? "red" : appTheme.bodyText
                ctx.stroke()

            }
        }

        Text {
            visible: _item.fontSize !== 0
            text: value.toFixed(0) + unit
            //Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            anchors.centerIn: parent
            font.bold: true
            // anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: fontSize
            color: appTheme.bodyText
        }

        Text {
            id: overheatText
            text: "🔥"
            // Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            anchors.centerIn: parent
            font.pixelSize: 28
            font.bold: true
            color: "red"
            visible: alert && value >= max
            opacity: 0.0
            z: 10

            // Clignotement par fondu
            Behavior on opacity {
                NumberAnimation { duration: 300 }
            }

            SequentialAnimation on opacity {
                loops: Animation.Infinite
                running: overheatText.visible
                NumberAnimation { to: 1.0; duration: 500; easing.type: Easing.InOutQuad }
                PauseAnimation { duration: 200 }
                NumberAnimation { to: 0.0; duration: 500; easing.type: Easing.InOutQuad }
                PauseAnimation { duration: 200 }
            }
        }

    }

    Item {
        id: rectangleGauge
        anchors.top: parent.top
        width: _item.width
        height: _item.height
        visible: _item.style === "rectangle"

        RowLayout {

            Rectangle {
                Layout.preferredHeight: _item.width * 0.1
                Layout.preferredWidth: _item.width * 0.8
                color: Qt.lighter(appTheme.gradientLight2, 1.1)
                radius: Constants.dp(5)

                Rectangle {
                    anchors.left: parent.left
                    height: parent.height
                    width: parent.width * value / 100
                    color: (alert && value >= max) ? "red" : appTheme.bodyText
                    topLeftRadius: parent.radius
                    bottomLeftRadius: parent.radius
                    topRightRadius: value > 98 ? parent.radius : 0
                    bottomRightRadius: value > 98 ? parent.radius : 0

                }
            }

            Text {
                text: value.toFixed(0) + unit
                font.bold: true
                font.pixelSize: fontSize
                color: appTheme.bodyText
            }

        }
    }

    Connections {
        target: _item
        function onValueChanged() { _canvas.requestPaint() }
    }

}

