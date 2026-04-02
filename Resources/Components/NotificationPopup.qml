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

    property color warningColor: "#FFF100"
    property string text: "Message d'erreur"
    property string subText: "Description"
    property int importance: 1
    property string em
    property string cm
    property string date: ""
    property string time: ""
    property bool autoClose: false
    property string srcImg: ""

    modal: importance === 1
    focus: importance === 1
    closePolicy: Popup.NoAutoClose
    height: importance === 1 ? parent.height : Constants.dp(100)
    width: importance === 1 ? parent.width : Math.max(Constants.dp(400), subTextLvl2.width + lvlImg.width + Constants.dp(40) )
    padding: 0

    x: importance === 1 ? 0 : parent.width - width - Constants.dp(10)
    y: importance === 1 ? 0 : parent.height - parent.height * 0.15 - height - Constants.dp(10)

    background: Rectangle {
        visible: root.importance === 1
        anchors.fill: parent
        opacity: 0.25
        color: "black"
    }

    onOpened: autoClose ? closeTimer.restart() : null

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
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    spacing: 30 * Constants.scaleFactor
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Layout.margins: Constants.dp(35)

                    Rectangle {
                        id: imageNotif
                        Layout.preferredHeight: background.height * 0.8
                        Layout.preferredWidth: height
                        radius: Constants.dp(30)
                        color: appTheme.backgroundColor
                        border.color: "white"
                        border.width: 2 * Constants.scaleFactor

                        Image {
                            anchors.centerIn: parent
                            height: parent.height * 0.8
                            width: height
                            source: !isNaN(root.em) && !isNaN(root.cm) ?
                                        "../Images/" + Constants.cmImages[root.em][root.cm] + ".svg" :
                                        "../Images/Info.svg"
                            fillMode: Image.PreserveAspectCrop
                            sourceSize: Qt.size(width, height)
                        }
                    }

                    ColumnLayout {
                        Layout.bottomMargin: (background.height - imageNotif.height) / 8
                        Layout.topMargin: Layout.bottomMargin
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        RowLayout {
                            Layout.preferredWidth: parent.width

                            Label {
                                id: emCmText
                                color: "white"
                                text: Constants.emNames[root.em] + " | " + Constants.cmNames[root.em][root.cm]
                                font.family: "Object Sans"
                                font.pixelSize: Constants.sp(24)
                                Layout.alignment: Qt.AlignLeft
                            }

                            Label {
                                id: dateText
                                color: "white"
                                text: root.date + " - " + root.time
                                font.family: "Object Sans"
                                font.pixelSize: Constants.sp(18)
                                Layout.alignment: Qt.AlignRight
                            }
                        }

                        Label {
                            color: "white"
                            text: root.text
                            wrapMode: Text.Wrap
                            font.pixelSize: Constants.sp(40)
                            horizontalAlignment: Text.AlignLeft
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            Layout.fillWidth: true
                            font.bold: true
                            font.family: "Object Sans"
                        }

                        Label {
                            color: "white"
                            text: root.subText
                            wrapMode: Text.Wrap
                            font.pixelSize: Constants.sp(30)
                            horizontalAlignment: Text.AlignLeft
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            font.family: "Object Sans"
                            Layout.fillHeight: true

                        }

                        Item {Layout.fillHeight: true}

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            spacing: Constants.dp(35)

                            Button {
                                id: redirectBtn
                                Layout.preferredHeight: 90 * Constants.scaleFactor
                                Layout.preferredWidth: 210 * Constants.scaleFactor
                                Layout.alignment: Qt.AlignHCenter

                                onClicked: {
                                    stackLayoutPage.currentIndex = 13
                                    root.close()
                                }

                                contentItem: Text {
                                    color: "white"
                                    text: "VOIR"
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


                            Button {
                                id: closeBtn
                                Layout.preferredHeight: 90 * Constants.scaleFactor
                                Layout.preferredWidth: 210 * Constants.scaleFactor
                                Layout.alignment: Qt.AlignHCenter

                                onClicked: root.close()

                                contentItem: Text {
                                    color: "white"
                                    text: "FERMER"
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
    }

    Item {
        id: lvl2Notif
        anchors.fill: parent

        visible: root.importance === 2

        Rectangle {
            id: rectangleLvl2
            anchors.fill: parent
            radius: 28 * Constants.scaleFactor
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
                    id: lvlImg
                    Layout.leftMargin: Constants.dp(10)
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                    Layout.preferredHeight: parent.height * 0.8
                    Layout.preferredWidth: height
                    color: "#AC7BBE"
                    border.color: root.warningColor
                    border.width: 2 * Constants.scaleFactor
                    radius: height / 2

                    Image {
                        sourceSize: Qt.size(width, height)
                        anchors.centerIn: parent
                        height: parent.height * 0.65
                        width: height
                        source: {
                            if (root.srcImg !== "") {
                                return root.srcImg
                            } else if (!isNaN(root.em) && !isNaN(root.cm)) {
                                return "../Images/" + Constants.cmImages[root.em][root.cm] + ".svg"
                            } else {
                                return "../Images/Info.svg"
                            }
                        }
                        fillMode: Image.PreserveAspectCrop
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: Constants.dp(10)

                    Item { Layout.preferredHeight: Constants.dp(1) }

                    Label {
                        id: dateText2
                        color: "white"
                        text: root.date + " - " + root.time
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
                            id: subTextLvl2
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
