import QtQuick
import QtQuick.Controls
import Bobink
import QtQuick.Controls.Basic
import QtQuick.Effects
import ".."
import "../.."

Switch {
    id: control
    text: qsTr("ON")
    implicitWidth: 75
    implicitHeight: 37.5

    property bool onOffText: true
    property bool disactivated: !enabled
    property string nodeId: ""

    indicator: Item {
        id: indicatorRoot
        implicitWidth: parent.width
        implicitHeight: parent.height
        anchors.centerIn: parent

        Rectangle {
            id: rectangle
            anchors.fill: parent
            radius: height / 2
            gradient: Gradient {
                orientation: control.rotation !== -90 ? Gradient.Vertical : Gradient.Horizontal
                GradientStop {position: 0.0; color: "black" }
                GradientStop {position: 1.0; color: "white"}
            }

            border.width: 0
            anchors.verticalCenter: parent.verticalCenter
            opacity: 0.5
            rotation: control.rotation === -90 ? 180 : 0
        }

        Rectangle {
            id: innerRectangle
            width: rectangle.width - 2 * Constants.scaleFactor
            height: rectangle.height - 2 * Constants.scaleFactor
            radius: height / 2
            border.width: 0
            // anchors.verticalCenter: parent.verticalCenter
            anchors.centerIn: parent
            color: control.checked ? Qt.lighter(appTheme.gradientMid, 1.4) : appTheme.bodyText

            Behavior on color {
                ColorAnimation {
                    duration: 150
                    easing.type: Easing.InOutQuad
                }
            }
        }

        Text {
            text: control.checked ? "ON" : "OFF"
            anchors.verticalCenter: parent.verticalCenter
            x: control.checked? 12 * Constants.scaleFactor : parent.width - width - 12 * Constants.scaleFactor
            color: control.down ? Qt.darker(appTheme.bodyText, 1.5) :
                                  (control.checked ? appTheme.bodyText :  appTheme.inversedText)
            verticalAlignment: Text.AlignVCenter
            // horizontalAlignment: Text.AlignLeft
            font.weight: Font.DemiBold
            font.pixelSize: control.width * 0.15
            opacity: 0.8
            visible: onOffText
        }

        Rectangle {
            id: circleToggle
            x: control.checked ? parent.width - width - 4 * Constants.scaleFactor : 4 * Constants.scaleFactor
            width: control.height * 0.8
            height: width
            radius: height / 2
            color: control.down ? "#cccccc" : "#f0f0f0"
            border.width: 0
            anchors.verticalCenter: parent.verticalCenter

            Behavior on x {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.InOutQuad
                }
            }

        }

        MultiEffect {
             id: blackShadow
             anchors.fill: source
             source: circleToggle
             blurMax: 6
             shadowEnabled: true
             shadowColor: "black"
             opacity: control.down ? 0.9 : 0.6
        }

        Rectangle {
            anchors.fill: innerRectangle
            radius: innerRectangle.radius
            anchors.centerIn: innerRectangle
            color: "dark grey"
            opacity: 0.5
            visible: disactivated
        }

    }

    contentItem: Text {
        text: control.text
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: -13 * Constants.scaleFactor

        opacity: 0
        color: control.down ? appTheme.bodyText : appTheme.bodyText
        verticalAlignment: Text.AlignVCenter
        font.weight: Font.DemiBold
        font.pointSize: 10
        leftPadding: control.indicator.width + control.spacing
    }
    Loader {
        id: opcuaLoader
        active: control.nodeId !== ""
        sourceComponent: opcuaNodeComponent
    }
    onCheckedChanged: {
        if(opcuaLoader.item)  {
            opcuaLoader.item.writeValue(checked)
        }
    }
    Component {
        id: opcuaNodeComponent
        OpcUaMonitoredNode {
            monitored: control.visible
            nodeId: control.nodeId
            onValueChanged: control.checked = value
        }
    }
}
