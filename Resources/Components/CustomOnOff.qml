import QtQuick
import QtQuick.Controls
import Bobink
import QtQuick.Controls.Basic
import QtQuick.Effects
import QtQuick.Layouts
import "../../"

Button {
    id: control
    text: ""
    implicitWidth: 75
    implicitHeight: 75
    checkable: true

    property bool onOffText: true
    property bool disactivated: false
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
            color: control.checked ? "#36a646" : "#f0f0f0"

            Behavior on color {
                ColorAnimation {
                    duration: 150
                    easing.type: Easing.InOutQuad
                }
            }
        }

        Rectangle {
            id: circleToggle
            anchors.centerIn: parent
            width: control.height * 0.82
            height: width
            radius: height / 2
            color: control.down ? Qt.darker(control.checked ? appTheme.bodyText : appTheme.backgroundColor, 1.1)
                                : (control.checked ? appTheme.bodyText : appTheme.backgroundColor)
            border.width: 0
            anchors.verticalCenter: parent.verticalCenter

            Behavior on color {
                ColorAnimation {
                    duration: 150
                    easing.type: Easing.InOutQuad
                }
            }

            Text {
                horizontalAlignment: Text.AlignHCenter
                font.bold: true
                anchors.centerIn: parent
                text: control.checked ? "ON" : "OFF"
                font.pixelSize: control.width * 0.28
                color: control.checked ? "#36a646" : "#f0f0f0"

                Behavior on color {
                    ColorAnimation {
                        duration: 150
                        easing.type: Easing.InOutQuad
                    }
                }

            }
        }


        MultiEffect {
             id: blackShadow
             anchors.fill: source
             source: circleToggle
             blurMax: 6
             shadowEnabled: true
             shadowColor: control.checked ? "dark green" : "black"
             opacity: control.down ? 0 : 0.8
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

    background: Rectangle {
        color: "transparent"
    }

    Loader {
        id: opcuaLoader
        active: control.nodeId !== ""
        sourceComponent: opcuaNodeComponent
    }
    // onClicked: {
    //     if(control.nodeId !== ""){
    //         opcuaLoader.item.setValue(checked)
    //     }
    // }

    onCheckedChanged: {
        if(opcuaLoader.item){
            opcuaLoader.item.setValue(checked)
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
