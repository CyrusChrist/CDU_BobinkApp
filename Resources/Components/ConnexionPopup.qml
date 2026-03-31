import QtQuick
import QtQuick.Controls
import Bobink
import QtQuick.Effects
import QtQuick.Layouts
import "../.."

Popup {
    id: root

    modal: false
    focus: false
    closePolicy: Popup.CloseOnEscape
    height: parent.height
    width: parent.width
    anchors.centerIn: parent

    property string errorText: qsTr("Signal perdu...\nReconnectez vous au réseau")
    property string btnText: qsTr("Start")
    property real radius: 0
    property int btnState: -1 // 0 : Button not clicked, 1 : Button clicked, -1 : No button

    ColumnLayout {
        anchors.centerIn: parent
        spacing: Math.min(root.height - (connexionErrorLogo.height + txt.height + Constants.dp(5)), Constants.dp(30))

        Image {
	sourceSize: Qt.size(width, height) 
            id: connexionErrorLogo
            source: "../Images/ConnexionError.svg"
            fillMode: Image.PreserveAspectFit
            opacity: 1
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredHeight: Math.min(Constants.dp(139), root.height * 0.45)
            Layout.preferredWidth: height * 200/139

            SequentialAnimation {
                running: true
                loops: Animation.Infinite

                PropertyAnimation {
                    target: connexionErrorLogo
                    property: "opacity"
                    from: 1
                    to: 0.2
                    duration: 1000
                    easing.type: Easing.InOutQuad
                }

                PauseAnimation { duration: 80 }

                PropertyAnimation {
                    target: connexionErrorLogo
                    property: "opacity"
                    from: 0.2
                    to: 1
                    duration: 1000
                    easing.type: Easing.InOutQuad
                }

                PauseAnimation { duration: 80 }

            }

        }

        Text {
            id: txt
            color: "#F0F0F0"
            text: errorText
            visible: errorText !== ""
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            font.pixelSize: Math.min(root.width * 0.12, Constants.sp(28))
            wrapMode: Text.Wrap
            font.bold: true
        }

        ModuleButton {
            id: closeBtn
            visible: root.btnState !== -1
            Layout.alignment: Qt.AlignHCenter
            labelText: root.btnText
            bordered: true
            Layout.preferredHeight: Constants.dp(65)
            Layout.preferredWidth: Constants.dp(130)
            onClicked: root.btnState = 1
            onReleased: root.btnState = 0
        }

    }

    background: Rectangle {
        color: "black"
        opacity: 0.4
        radius: root.radius
    }
}
