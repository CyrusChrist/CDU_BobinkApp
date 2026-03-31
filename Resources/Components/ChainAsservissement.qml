import QtQuick
import QtQuick.Controls
import Bobink
import QtQuick.Layouts
import QtQuick.Effects
import "../.."

RowLayout {
    id: root
    spacing: 0 * Constants.scaleFactor
    property bool checked: true
    property string nodeId: ""


    Rectangle {

        width: 20 * Constants.scaleFactor
        height : 1 * Constants.scaleFactor
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop {position: 0.0; color: "transparent" }
            GradientStop {position: 0.5; color: appTheme.bodyText }
            GradientStop {position: 1.0; color: "transparent" }
        }
    }

    Button {
        id: buttonLink
        checkable: true
        checked: true
        rotation: root.rotation === 90 ? -90 : 0
        Layout.preferredWidth: 50 * Constants.scaleFactor
        Layout.preferredHeight: 50 * Constants.scaleFactor
        Image {
	sourceSize: Qt.size(width, height) 
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: !buttonLink.checked ? "../Images/LinkBroken.svg" : "../Images/Link.svg"
        }

        background: Rectangle {
            color: "transparent"
        }

        onCheckedChanged: root.checked = !root.checked

        onClicked: {
            if(root.nodeId !== ""){
                opcuaLoader.item.setValue(checked)
            }
        }

        Loader {
            id: opcuaLoader
            active: root.nodeId !== ""
            sourceComponent: opcuaNodeComponent
        }

        Component {
            id: opcuaNodeComponent
            OpcUaMonitoredNode {
                monitored: root.visible
                nodeId: root.nodeId
                onValueChanged: root.checked = value
            }
        }
    }


    Rectangle {

        width: 20 * Constants.scaleFactor
        height : 1 * Constants.scaleFactor
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop {position: 0.0; color: "transparent" }
            GradientStop {position: 0.5; color: appTheme.bodyText }
            GradientStop {position: 1.0; color: "transparent" }
        }
    }

    MouseArea {
        hoverEnabled: true

        onClicked: {
            !buttonLink.checked
            // root.checked = !root.checked
        }

    }


}
