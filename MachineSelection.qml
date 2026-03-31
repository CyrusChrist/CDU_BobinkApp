import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Bobink
import "Resources/Components"
import "utils.js" as Utils

Item {
    id: root

    property bool pageActive: true

    Component.onCompleted: pageActive = true

    OpcUaAuth {
        id: auth
        mode: OpcUaAuth.UserPass
        username: "admin"
        password: "CSe4hKr4"
        certPath: Bobink.certFile
        keyPath: Bobink.keyFile
    }

    Connections {
        target: Bobink

        function onConnectedChanged() {
            console.log("Connected: " + Bobink.connected);
            if (Bobink.connected) {
                root.pageActive = false
                stack.push(mainComponent)
            } else {
                stack.pop(null);
            }
        }
        function onConnectionError(message) {
            console.log("Connection error: " + message);
        }

        function onCertificateTrustRequested() {
            console.log("Certificate Trust Requested")
            Bobink.acceptCertificate()
        }

    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: appTheme.backgroundColor
    }

    Label {
        id: versionLabel
        x: 20
        y: 10
        text: "HMI version " + Constants.version
        font.pixelSize: 15
        color: appTheme.bodyText
    }

    ColumnLayout {
        id: mainColumn
        anchors.fill: parent
        spacing: Constants.dp(10)
        anchors.margins: Constants.dp(50)

        RowLayout {
            id: bobinkRow
            Layout.alignment: Qt.AlignHCenter
            spacing: Constants.dp(20)

            Image {
                id: bobinkLogo
                source: "Resources/Images/BobinkLogo.svg"
                Layout.preferredHeight: 150 * Constants.scaleFactor
                Layout.preferredWidth: 150 * Constants.scaleFactor
                fillMode: Image.PreserveAspectFit

            }

            Image {
                id: bobinkTitle
                source: "Resources/Images/BobinkTitle.svg"
                Layout.preferredHeight: 150 * Constants.scaleFactor
                Layout.preferredWidth: 500 * Constants.scaleFactor
                fillMode: Image.PreserveAspectFit
            }
        }

        Label {
            id: subtitle
            font.bold: true
            font.pixelSize: Constants.sp(45)
            text: qsTr("Colorful innovation")
            font.italic: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: appTheme.bodyText
        }

        Label {
            id: labelMachine
            font.bold: true
            font.pixelSize: Constants.sp(33)
            text: qsTr("Choisir une machine")
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: appTheme.bodyText
        }

        ColumnLayout {
            id: machineColumn
            Layout.fillWidth: true
            spacing: Constants.dp(30)

            property real frameHeight: (
                                           root.height -
                                           (bobinkRow.implicitHeight
                                            + subtitle.implicitHeight
                                            + labelMachine.implicitHeight
                                            + mainColumn.spacing * 3
                                            + Constants.dp(50) * 2
                                            + machineColumn.spacing * (listModel.count - 1))
                                        ) / listModel.count

            ListModel {
                id: listModel
                ListElement { title: "BOBINK 1"; ip: "172.30.7.253"; connected: false }
                ListElement { title: "BOBINK 2"; ip: "192.168.1.1"; connected: true }
                // ListElement { title: "BOBINK 3"; connected: true }
            }

            Repeater {
                model: listModel

                Item {
                    id: machineItem
                    Layout.fillWidth: true
                    Layout.preferredHeight: machineColumn.frameHeight //Constants.dp(300)

                    StyledFrame {
                        id: machineFrame
                        style: "shadowed"
                        padding: Constants.dp(25)
                        anchors.fill: parent

                        Item {
                            id: imageFond
                            clip: true
                            anchors.fill: parent

                            Image {
                                id: schemaImage
                                source: "Resources/Images/Schema3D.svg"
                                anchors.verticalCenter: parent.verticalCenter
                                height: machineFrame.height * 1.5
                                width: 2009 * height / 390

                            }

                            Rectangle {
                                id: degradéGauche
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                height: parent.height
                                width: Constants.dp(1000)

                                gradient: Gradient {
                                    orientation: Gradient.Horizontal
                                    GradientStop { position : 0.0; color: Qt.lighter(appTheme.backgroundColor, 1.1) }
                                    GradientStop { position : 0.25; color: Qt.lighter(appTheme.backgroundColor, 1.1)}
                                    GradientStop { position : 1.0; color: "transparent" }
                                }
                            }

                            Rectangle {
                                id: degradéDroit
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                height: parent.height
                                width: Constants.dp(200)

                                gradient: Gradient {
                                    orientation: Gradient.Horizontal
                                    GradientStop { position : 0.0; color: "transparent" }
                                    GradientStop { position : 0.85; color: Qt.lighter(appTheme.backgroundColor, 1.1) }
                                    GradientStop { position : 1.0; color: Qt.lighter(appTheme.backgroundColor, 1.1)}
                                }
                            }
                        }

                        Label {
                            font.bold: true
                            font.pixelSize: Constants.sp(30)
                            text: model.title
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            color: appTheme.bodyText
                        }

                    }

                    Rectangle {
                        id: hoverRectangle

                        property bool isHovered: false

                        anchors.fill: parent
                        radius: 15 * Constants.scaleFactor
                        color: !model.connected ? Qt.darker(appTheme.backgroundColor, 1.1) : Qt.lighter(appTheme.backgroundColor, 1.5)
                        opacity: 0.2
                        visible: !model.connected || isHovered

                        ConnexionPopup {
                            id: connexionPopup
                            visible: !model.connected && root.pageActive
                            errorText: "No signal..."
                            radius: 15 * Constants.scaleFactor

                        }
                    }

                    MouseArea {
                        id: mouseAreaMachine
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            Bobink.auth = auth
                            Bobink.serverUrl = "opc.tcp://" + model.ip
                            Bobink.connectDirect(Bobink.Basic256Sha256, Bobink.SignAndEncrypt)
                        }

                        onEntered: {
                            hoverRectangle.isHovered = true
                        }

                        onExited: {
                            hoverRectangle.isHovered = false
                        }
                    }
                }
            }

        }

        // ListView {
        //     model: QBobinkModel
        //     delegate: ItemDelegate {
        //         text: "Machine ID = " + machineId + " loaded !"
        //         onClicked: root.visible = false
        //     }
        // }
    }

}
