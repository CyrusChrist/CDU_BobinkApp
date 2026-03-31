import QtQuick
import QtQuick.Controls
import Bobink
import QtQuick.Effects
import "../.."

Button{
    id: button

    property alias labelText: label.text
    property alias buttonImage: buttonImage.source
    property bool extendable: false
    property bool ishovered: false
    property bool mainBtn: false
    property real labelFontSize: Constants.sp(10)
    property color btnColor: appTheme.gradientLight2
    property real backgroundOpacity: 0
    property bool slideBehavior: true
    property bool manuelOn: false

    width: 130
    height: 70
    checkable: true

    Item {
        anchors.centerIn: parent

        Rectangle {
            id: fond
            width: button.width
            height: button.height
            anchors.centerIn: parent
            radius: button.height * 0.1
            gradient: Gradient {
                GradientStop { position: 0.0; color: button.checked ? "#A1A1A1" : "transparent"}
                GradientStop { position: 0.8; color: "transparent" }
            }
            visible: !button.mainBtn
            border.color: button.manuelOn ? "#deae2a" : "transparent"
            border.width: 2
        }

        Rectangle {
            width: button.width - button.height * 0.035
            height: button.height - button.height * 0.035
            radius: button.height * 0.1
            anchors.centerIn: parent
            color: button.mainBtn ?
                    button.labelText === "Usine"
                   ? "#B65151"
                   : Qt.lighter(button.btnColor , button.checked ? 1.4 : 1.2)
                   : button.checked
                   ? button.btnColor
                   : button.ishovered
                   ? Qt.lighter(button.btnColor ,1.2)
                   : button.backgroundOpacity !== 0
                   ? Qt.lighter(button.btnColor, 1.1)
                   : "transparent"
        }
    }

    Image {
        id: buttonImage

        width: button.height * 0.75
        height: width

        anchors.verticalCenter: parent.verticalCenter
        anchors.centerIn: !slideMenuActive && button.slideBehavior ? button : undefined
        anchors.left: !slideMenuActive && button.slideBehavior ? undefined : parent.left
        anchors.topMargin: 2
        anchors.leftMargin: !slideMenuActive && button.slideBehavior ? 0 : button.width * 0.05
        fillMode: Image.PreserveAspectFit
        smooth: true
        antialiasing: false
        visible: buttonImage.source !== ""

    }

    Text {
        id: label
        color: appTheme.moduleText
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: buttonImage.width + button.width * 0.08
        font.bold: true
        font.pointSize: button.labelFontSize
        visible: slideMenuActive || !button.slideBehavior
    }

    Text {
        id: extendableLabel
        color: appTheme.moduleText
        text: button.checked ? "⮝" : "⮟"
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: button.width * 0.08
        font.bold: true
        font.pointSize: button.labelFontSize
        visible: button.extendable
    }

    background: Rectangle{
        color: "transparent"
    }

    MouseArea{
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            if (button.extendable) {
                button.checked = !button.checked
                button.clicked()
            } else {
                button.checked = true
                button.clicked()
            }
        }

        onEntered: button.ishovered = true

        onExited: button.ishovered = false
    }

}
