import QtQuick
import QtQuick.Controls
import Bobink
import QtQuick.Controls.Basic
import QtQuick.Effects
import "../../"

Button {
    id: control
    implicitWidth: Constants.dp(50)
    implicitHeight: Constants.dp(50)

    property string imgSourceBlack: ""
    property string imgSourceWhite: ""
    property bool inverted: false
    property string nodeId: ""

    background: Rectangle {
        id: fond
        anchors.fill: parent
        radius: control.width / 2
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop {position: 0.0; color: "black" }
            GradientStop {position: 1.0; color: "white"}
        }

        border.width: 0
        anchors.verticalCenter: parent.verticalCenter
        opacity: 0.5
        rotation: control.inverted ? 180 : 0

    }

    Rectangle {
        width: fond.width - 2 * Constants.scaleFactor
        height: fond.height - 2 * Constants.scaleFactor
        radius: height / 2
        border.width: 0
        anchors.centerIn: parent
        color: control.inverted ?
                   control.pressed ? appTheme.bodyText : Qt.lighter(appTheme.gradientMid, 1.4)
                   : !control.pressed ? appTheme.bodyText : Qt.lighter(appTheme.gradientMid, 1.4)

    }


    Image {
        anchors.centerIn: parent
        width: fond.width - 8 * Constants.scaleFactor
        height: fond.height - 8 * Constants.scaleFactor
        source: control.imgSourceBlack === "" ?
                    control.inverted
                        ? !control.pressed ? "../Images/MENU_systeme.svg" : "../Images/Engrenage.svg"
                        : control.pressed ? "../Images/MENU_systeme.svg" : "../Images/Engrenage.svg"
                    : control.inverted ?
                        !control.pressed ? control.imgSourceWhite : control.imgSourceBlack
                        : control.pressed ? control.imgSourceWhite : control.imgSourceBlack
    }

    onPressed: {
        if (opcuaLoader.item) {
            opcuaLoader.item.setValue(true)
            console.log("DEBUG\t" + control.nodeId + " is pressed")
        }
    }
    onReleased: {
        if (opcuaLoader.item) {
            opcuaLoader.item.setValue(false)
            console.log("DEBUG\t" + control.nodeId + " is released")
        }
    }

    Loader {
        id: opcuaLoader
        active: control.nodeId !== ""
        sourceComponent: opcuaNodeComponent
    }

    Component {
        id: opcuaNodeComponent
        OpcUaMonitoredNode {
            monitored: control.visible
            id: opcuaNode
            nodeId: control.nodeId
        }
    }


}
