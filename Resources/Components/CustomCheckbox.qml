import QtQuick
import QtQuick.Controls
import Bobink
import QtQuick.Controls.Basic
import QtQuick.Effects
import "../../"

CheckBox {
    id: control

    property string nodeId: ""

    implicitWidth: 26
    implicitHeight: 26
    text: ""

    indicator: Rectangle {
            anchors.fill: parent
            radius: parent.height * 0.14
            color: control.checked ? "#35a646" : "transparent"
            border.color: control.checked ? "transparent" : appTheme.bodyText

            Image {
                anchors.centerIn: parent
                width: parent.height * 0.6
                height: width
                visible: control.checked
                source: "../Images/Check.svg"
                fillMode: Image.PreserveAspectFit
            }
        }

    Loader {
        id: opcuaLoader
        active: control.nodeId !== ""
        sourceComponent: opcuaNodeComponent
    }
    onCheckedChanged: {
        if(opcuaLoader.item)  {
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
