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
    implicitWidth: 185 * Constants.scaleFactor
    implicitHeight: 50 * Constants.scaleFactor
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
                orientation: Gradient.Vertical
                GradientStop {position: 0.0; color: "black" }
                GradientStop {position: 1.0; color: "white"}
            }

            border.width: 0
            anchors.verticalCenter: parent.verticalCenter
            opacity: 0.5
        }

        Rectangle {
            id: innerRectangle
            width: rectangle.width - 2
            height: rectangle.height - 2
            radius: height / 2
            border.width: 0
            anchors.verticalCenter: parent.verticalCenter
            color: control.checked ? Qt.lighter(appTheme.gradientMid, 1.4) : appTheme.bodyText

            Behavior on color {
                ColorAnimation {
                    duration: 150
                    easing.type: Easing.InOutQuad
                }
            }

        }



        Rectangle {
            id: circleToggle
            x: control.checked ? parent.width - width - 4 : 4
            width: 88 * Constants.scaleFactor
            height: 40 * Constants.scaleFactor
            radius: height / 2
            color: control.down ? Qt.darker("#f0f0f0", 1.05) : "#f0f0f0"
            border.width: 0
            anchors.verticalCenter: parent.verticalCenter

            Behavior on x {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.InOutQuad
                }
            }

        }

        Text {
            text: qsTr("Manuel")
            anchors.verticalCenter: parent.verticalCenter
            x: parent.width - width - 15 * Constants.scaleFactor
            color: /*(control.checked ? appTheme.bodyText :*/  appTheme.inversedText
            verticalAlignment: Text.AlignVCenter
            font.weight: Font.DemiBold
            font.pixelSize: 19 * Constants.scaleFactor
            opacity: control.checked ? 0.9 : 0.1
        }

        Text {
            text: qsTr("Auto")
            anchors.verticalCenter: parent.verticalCenter
            x: 28 * Constants.scaleFactor
            color: control.checked ? appTheme.bodyText :  appTheme.inversedText
            verticalAlignment: Text.AlignVCenter
            font.weight: Font.DemiBold
            font.pixelSize: 19 * Constants.scaleFactor
            opacity: control.checked ? 0.1 : 1
        }

        MultiEffect {
            id: blackShadow
            anchors.fill: source
            source: circleToggle
            blurMax: 6
            shadowEnabled: true
            shadowColor: "black"
            opacity: control.down ? 1 : 0.6
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
    onClicked: {
        if(control.nodeId !== ""){
            opcuaLoader.item.setValue(!checked)
        }
    }
    Component {
        id: opcuaNodeComponent
        OpcUaMonitoredNode {
            nodeId: control.nodeId
            monitored: control.visible
            onValueChanged: control.checked = !value
        }
    }
}
