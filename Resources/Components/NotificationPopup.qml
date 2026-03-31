import QtQuick
import QtQuick.Controls
import Bobink
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Effects
import QtQuick.Layouts
import "../.."

Popup {
    id: root

    property color warningColor: /*"#fdff2700" //  */"#FFF100"
    property string text: "Casse fil IR (C305)"
    property string subText: "Repasser le fil dans la machine depuis l'IR"
    property int importance: 1

    modal: importance === 1
    focus: importance === 1
    closePolicy: Popup.NoAutoClose
    height: importance === 1 ? parent.height : Constants.dp(100)
    width: importance === 1 ? parent.width : Constants.dp(400)
    padding: 0

    x: importance === 1 ? 0 : parent.width - width - Constants.dp(10)
    y: importance === 1 ? 0 : parent.height - parent.height * 0.15 - height - Constants.dp(10)

    background: Rectangle {
        visible: root.importance === 1
        anchors.fill: parent
        opacity: 0.25
        color: "black"
    }

    onOpened: importance === 1 ? null : closeTimer.restart()

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 250 }
    }

    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 250 }
    }

    Item {
        id: lvl1Notif
        anchors.centerIn: parent
        width: parent.width * 0.75
        height: parent.height * 0.45

        visible: root.importance === 1

        Rectangle {
            id: background
            anchors.fill: parent
            radius: 35 * Constants.scaleFactor
            color: "black"
            border.color: root.warningColor
            border.width: 5 * Constants.scaleFactor

            ColumnLayout {
                anchors.fill: parent

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 30 * Constants.scaleFactor

                    Rectangle {
                        id: imageNotif
                        Layout.preferredHeight: background.height * 0.8
                        Layout.preferredWidth: height
                        radius: Constants.dp(30)
                        color: appTheme.backgroundColor
                        border.color: "white"
                        border.width: 2 * Constants.scaleFactor
                    }

                    ColumnLayout {
                        Layout.bottomMargin: (background.height - imageNotif.height) / 2
                        Layout.topMargin: Layout.bottomMargin

                        RowLayout {
                            Layout.preferredWidth: parent.width

                            Label {
                                id: dateText
                                color: "white"
                                property var currentDate: new Date()
                                text: Qt.formatDateTime(currentDate, "dd/MM hh:mm:ss")
                                font.family: "Object Sans"
                                font.pixelSize: 20 * Constants.scaleFactor
                                Layout.alignment: Qt.AlignLeft
                            }

                            // Item {Layout.fillWidth: true}

                            Label {
                                id: notifIndex
                                color: "white"
                                text: "1/5"
                                font.family: "Object Sans"
                                font.pixelSize: 20 * Constants.scaleFactor
                                Layout.alignment: Qt.AlignRight
                            }
                        }

                        Label {
                            color: "white"
                            text: root.text
                            font.pixelSize: 60 * Constants.scaleFactor
                            horizontalAlignment: Text.AlignLeft
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            font.bold: true
                            font.family: "Object Sans"
                        }

                        Label {
                            color: "white"
                            text: root.subText
                            wrapMode: Text.Wrap
                            font.pixelSize: 40 * Constants.scaleFactor
                            horizontalAlignment: Text.AlignLeft
                            font.italic: true
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            font.bold: true
                            font.family: "Object Sans"

                        }

                        Item {Layout.fillHeight: true}

                        Button {
                            Layout.preferredHeight: 90 * Constants.scaleFactor
                            Layout.preferredWidth: 210 * Constants.scaleFactor
                            Layout.alignment: Qt.AlignHCenter

                            onClicked: root.close()

                            contentItem: Text {
                                color: "white"
                                text: "ACQUITTER"
                                font.pixelSize: 25 * Constants.scaleFactor
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                anchors.centerIn: parent
                                font.bold: true
                                font.family: "Object Sans"

                            }

                            background: Rectangle {
                                anchors.fill: parent
                                radius: 20 * Constants.scaleFactor
                                color: appTheme.backgroundColor
                                border.color: "white"
                                border.width: 2 * Constants.scaleFactor
                            }
                        }

                    }
                }

            }

        }
    }

    Item {
        id: lvl2Notif
        anchors.fill: parent

        visible: root.importance === 2

        Rectangle {
            id: rectangleLvl2
            anchors.fill: parent
            radius: 35 * Constants.scaleFactor
            color: Qt.darker(appTheme.backgroundColor, 1.5)
            border.color: root.warningColor
            border.width: 0 * Constants.scaleFactor

            ModuleButton {
                labelText: "X"
                width: Constants.dp(20)
                height: Constants.dp(20)
                bordered: true
                x: parent.width - width - Constants.dp(10)
                y: Constants.dp(10)

                onClicked: root.close()
            }

            RowLayout {
                anchors.fill: parent
                spacing: Constants.dp(10)

                Rectangle {
                    Layout.leftMargin: Constants.dp(10)
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                    Layout.preferredHeight: parent.height * 0.8
                    Layout.preferredWidth: height
                    color: "#AC7BBE"
                    border.color: root.warningColor
                    border.width: 2 * Constants.scaleFactor
                    radius: height / 2
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: Constants.dp(10)

                    Item { Layout.preferredHeight: Constants.dp(1) }

                    Label {
                        id: dateText2
                        color: "white"
                        property var currentDate: new Date()
                        text: Qt.formatDateTime(currentDate, "dd/MM hh:mm:ss")
                        font.family: "Object Sans"
                        font.pixelSize: Constants.sp(16)
                        Layout.alignment: Qt.AlignLeft
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: Constants.dp(5)

                        Label {
                            Layout.alignment: Qt.AlignLeft
                            color: appTheme.bodyText
                            font.pixelSize: Constants.sp(22)
                            text: root.text
                            font.bold: true
                        }

                        Label {
                            Layout.alignment: Qt.AlignLeft
                            color: appTheme.bodyText
                            font.pixelSize: Constants.sp(16)
                            text: root.subText
                        }

                    }

                    Item { Layout.fillHeight: true }
                }

                Item { Layout.fillWidth: true }

            }
        }

        MultiEffect {
             id: blackShadow
             anchors.fill: source
             source: rectangleLvl2
             shadowEnabled: true
             shadowColor: "black"
             opacity: 0.5
        }

        Timer {
            id: closeTimer
            interval: 4000
            running: false
            repeat: false
            onTriggered: root.close()
        }
    }
}
