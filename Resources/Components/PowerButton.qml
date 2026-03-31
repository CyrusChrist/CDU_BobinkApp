import QtQuick
import QtQuick.Controls
import Bobink
import QtQuick.Controls.Basic
import QtQuick.Effects
import QtQuick.Layouts
import "../.."

Item {
    id: root

    implicitHeight: 100
    implicitWidth: 100

    property int angle: 0
    property bool checked: false

    // onCheckedChanged: if (!checked) {
    //                       area.checked = false
    //                       glowCircle.height = parent.height * 0.3
    //                       glowCircle.width = parent.width * 0.3
    //                   }

    Rectangle {
        id: glowCircle

        anchors.centerIn: area.checked ? parent : null

        height: parent.height * 0.3
        width: parent.width * 0.3
        radius: height / 2

        x: root.width / 2 + (background.radius - width * 0.51) * Math.cos(root.angle * 0.01745) - width / 2
        y: root.height / 2 +  (background.radius - height * 0.51) * Math.sin(root.angle * 0.01745) - height / 2


        PropertyAnimation {
            id: checkAnimation
            target: glowCircle
            properties: "height, width"
            to: root.height * 0.9
            duration: 300
            easing.type: Easing.InOutQuad
            onStopped: {
                root.checked = true
                unCheckPositionAnimation.start()
            }
        }

        PropertyAnimation {
            id: unCheckAnimation
            target: glowCircle
            properties: "height, width"
            to: root.height * 0.3
            duration: 300
            easing.type: Easing.InOutQuad
            onStopped: root.checked = false
        }

        PropertyAnimation {
            id: checkPositionAnimation
            target: glowCircle
            properties: "x, y"
            to: root
            duration: 150
            easing.type: Easing.InOutQuad
            onStopped: checkAnimation.start()
        }

        PropertyAnimation {
            id: unCheckPositionAnimation
            target: glowCircle
            properties: "x, y"
            to: root.height / 2 +  (background.radius - height * 0.51) * Math.sin(root.angle * 0.01745) - height / 2
            duration: 200
            easing.type: Easing.InOutQuad
            onStopped: unCheckAnimation.start()
        }
    }

    MultiEffect {
        anchors.fill: source
        source: glowCircle
        shadowEnabled: true
        shadowColor: "white"
        blurMax: 40
        shadowBlur: 1
    }

    NumberAnimation on angle {
        id: angleAnimation
        from: 0
        to: 360
        duration: 5000
        loops: Animation.Infinite
        easing.type: Easing.Linear
        running: !area.checked
    }

    Rectangle {
        id: background
        anchors.fill: parent
        radius: parent.width / 2
        color: appTheme.backgroundColor
        border.color: "transparent"

        Rectangle {
            id: border
            height: parent.height + 1.5
            width: parent.width + 1.5
            radius: parent.width / 2
            color: "transparent"
            border.color: "white"
            border.width: 1.5
            opacity: 0.3
        }

        Image {
	sourceSize: Qt.size(width, height)
            anchors.centerIn: parent
            width: parent.width * 0.6
            height: parent.height * 0.65
            fillMode: Image.PreserveAspectCrop
            source: "../Images/PowerWhite.svg"
        }

    }

    MouseArea {
        id: area
        anchors.fill: parent

        property bool checked: false

        onClicked: {
            checkPositionAnimation.start()
            checked = true
        }

        transitions: Transition {
            from: "*"
            to: "pressed"
            reversible: true
            NumberAnimation {
                properties: "scale"
                duration: 100
            }
        }
    }

    states: state

    State {
        id: state
        name: "pressed"
        when: area.pressed
        PropertyChanges {
            target: root
            scale: 0.95
        }
    }


}
