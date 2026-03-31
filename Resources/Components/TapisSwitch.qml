import QtQuick
import QtQuick.Controls
import Bobink
import QtQuick.Controls.Basic
import QtQuick.Effects
import "../../"

Switch {
    id: control
    text: qsTr("")
    implicitWidth: 110 * Constants.scaleFactor
    implicitHeight: 37.5 * Constants.scaleFactor

    property bool onOffText: true
    property bool disactivated: false
    property bool locked: false
    required property var nodeIdForward
    required property var nodeIdBackward

    onLockedChanged: {
        leftArea.checked = false
        rightArea.checked = false
        control.checked = false
    }

    OpcUaMonitoredNode {
        monitored: control.visible
        id: forwardId
        nodeId: control.nodeIdForward
    }
    OpcUaMonitoredNode {
        monitored: control.visible
        id: backwardId
        nodeId: control.nodeIdBackward
        // onValueChanged: {
        //     if(value === 0){
        //         control.checked = false
        //     }
        // }
    }

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
                    GradientStop {position: 0.0; color: control.rotation === 0 ? "black" : "white" }
                    GradientStop {position: 1.0; color: control.rotation === 0 ? "white" : "black" }
                }


            border.width: 0
            anchors.verticalCenter: parent.verticalCenter
            opacity: 0.5
        }

        Rectangle {
            id: innerRectangle
            width: rectangle.width - 2 * Constants.scaleFactor
            height: rectangle.height - 2 * Constants.scaleFactor
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

        Image {
	sourceSize: Qt.size(width, height) 
            id: arrowRight
            source: rightArea.checked ? "../Images/TapisDroitWhite.svg" : "../Images/TapisGreen.svg"
            anchors.verticalCenter: parent.verticalCenter
            x: rightArea.checked ? x : parent.width - width - 5 * Constants.scaleFactor
            verticalAlignment: Text.AlignVCenter
            opacity: rightArea.checked ? 1 : 0.6
            visible: onOffText && !leftArea.checked
            height: parent.height - 15
            width: height

            SequentialAnimation {
                id: arrowAnimRight
                running: rightArea.checked
                loops: Animation.Infinite

                PropertyAnimation {
                    target: arrowRight
                    properties: "x"
                    from: 5 * Constants.scaleFactor
                    to: control.width - arrowRight.width - 5 * Constants.scaleFactor
                    duration: 1000
                    easing.type: Easing.InOutQuad
                }
                PauseAnimation { duration: 80 }
            }

        }

        Image {
	sourceSize: Qt.size(width, height) 
            id: arrowLeft
            source: leftArea.checked ? "../Images/TapisDroitWhite.svg" : "../Images/TapisRed.svg"
            anchors.verticalCenter: parent.verticalCenter
            x: leftArea.checked ? x : 5 * Constants.scaleFactor
            verticalAlignment: Text.AlignVCenter
            opacity: leftArea.checked ? 1 : 0.6
            visible: onOffText && !rightArea.checked
            height: parent.height - 15
            width: height
            rotation: leftArea.checked ? 180 : 0

            SequentialAnimation {
                id: arrowAnimLeft
                running: leftArea.checked
                loops: Animation.Infinite

                PropertyAnimation {
                    target: arrowLeft
                    properties: "x"
                    from: control.width - arrowLeft.width - 5 * Constants.scaleFactor
                    to: 5 * Constants.scaleFactor
                    duration: 1000
                    easing.type: Easing.InOutQuad
                }
                PauseAnimation { duration: 80 }
            }

        }

        Rectangle {
            id: circleToggle
            x: !control.checked ? parent.width / 2 - width / 2
                                 : rightArea.checked ? parent.width - width - 5 * Constants.scaleFactor
                                                     : 5 * Constants.scaleFactor
            width: control.height * 0.8
            height: width
            radius: height / 2
            color: control.down ? "#cccccc"
                                  : control.toggleState === 1 ? "#cccccc"
                                  : "#f0f0f0"
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
             opacity: control.down | control.checked ? 0.9 : 0.6
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

    MouseArea {
        id: leftArea
        property bool checked: false

        anchors.left: control.left
        height: control.height
        width: control.width / 2

        onCheckedChanged: {
            if (checked) {
                backwardId.setValue(true)
            } else {
                backwardId.setValue(false)
            }
        }

        onPressedChanged: {
            if (pressed) {
                if (checked) {
                    checked = false
                    control.checked = false
                } else {
                    checked = true
                    control.checked = true
                    rightArea.checked = false

                }
            } else if (!control.locked) {
                checked = false
                control.checked = false

            }
        }
    }

    MouseArea {
        id: rightArea
        property bool checked: false

        anchors.right: control.right
        height: control.height
        width: control.width / 2

        onCheckedChanged: {
            if (checked) {
                forwardId.setValue(true)
            } else {
                forwardId.setValue(false)
            }
        }

        onPressedChanged: {
            if (pressed) {
                if (checked) {
                    checked = false
                    control.checked = false

                } else {
                    checked = true
                    leftArea.checked = false
                    control.checked = true

                }
            } else if (!control.locked) {
                checked = false
                control.checked = false

            }
        }
    }

}
