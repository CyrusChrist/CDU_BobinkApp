import QtQuick
import QtQuick.Controls
import Bobink
import QtQuick.Layouts
import "../Resources/Components"
import "../"

Item {
    id: root
    width: Constants.width
    height: Constants.height

    property alias buttonAddNotif: buttonAddNotif
    property int errorID: -1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40 * Constants.scaleFactor
        spacing: 40 * Constants.scaleFactor


        Text {
            Layout.fillWidth: true

            text: qsTr("Centre des notifications")
            font.pixelSize: Math.max(35, parent.width * 0.037)
            font.bold: true
            color: appTheme.bodyText
        }

        ScrollView {
            id: notifScroll
            Layout.fillHeight: true
            Layout.fillWidth: true
            ScrollBar.vertical.policy: ScrollBar.AsNeeded

            ListModel {
                id: notifModel
                ListElement {code: "C120"; date: "16/07 09:38:15"; acquitted: true}
                ListElement {code: "C120"; date: "16/07 09:38:15"; acquitted: true}
                ListElement {code: "C120"; date: "16/07 09:38:15"; acquitted: true}
                ListElement {code: "C120"; date: "16/07 09:38:15"; acquitted: true}
                ListElement {code: "New"; date: ""; acquitted: true}
            }

            ListView {
                id: listView
                anchors.fill: parent
                model: notifModel

                delegate: Rectangle {
                    id: notifDelegate
                    required property int index
                    required property string code
                    required property string date
                    required property bool acquitted
                    property int newNotifCount: listView.count - notifDelegate.index - 1

                    height: code === "New" ? 60 * Constants.scaleFactor : 110 * Constants.scaleFactor
                    width: listView.width
                    color: code === "New" ? "transparent" : "#AC7BBE"
                    radius: 25 * Constants.scaleFactor
                    border.width: 6 * Constants.scaleFactor
                    border.color: appTheme.backgroundColor

                    RowLayout {
                        width: parent.width
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 10 * Constants.scaleFactor
                        visible: code != "New"

                        Item { Layout.preferredWidth: 10 * Constants.scaleFactor}

                        Rectangle {
                            Layout.preferredHeight: parent.height
                            Layout.preferredWidth: height
                            radius: 15 * Constants.scaleFactor
                            color: "#8E0801"
                            border.width: 2 * Constants.scaleFactor
                            border.color: appTheme.bodyText
                        }

                        ColumnLayout {
                            spacing: 8 * Constants.scaleFactor

                            Text {
                                text: notifDelegate.date
                                font.pixelSize: 20 * Constants.scaleFactor
                                font.family: "Object Sans"
                                color: appTheme.bodyText
                            }

                            Text {
                                text: " (" + notifDelegate.code + ") " + "Casse Fil IR"
                                font.pixelSize: 28 * Constants.scaleFactor
                                font.family: "Object Sans"
                                font.bold: true
                                color: appTheme.bodyText
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        Button {
                            id: infoButton
                            Layout.preferredHeight: parent.height * 0.8
                            Layout.preferredWidth: height

                            onClicked: notificationPopup.open()

                            background: Image {
                                source: "../Resources/Images/Info.svg"
                            }

                        }

                        Item { Layout.preferredWidth: 10 * Constants.scaleFactor}
                    }

                    RowLayout {
                        visible: code === "New"
                        anchors.horizontalCenter: parent.horizontalCenter
                        // width: parent.width
                        // height: parent.height
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 15 * Constants.scaleFactor
                        Canvas {
                            width: root.width / 2 - newNotifText.width / 2 - parent.spacing * 2
                            height: 20
                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.clearRect(0, 0, width, height)

                                ctx.strokeStyle = appTheme.bodyText
                                ctx.lineWidth = 2 * Constants.scaleFactor

                                var amplitude = parent.height * 0.2
                                var frequency = 2 * Math.PI / width * 7   // 12 cycles across width
                                var centerY = height / 2

                                ctx.beginPath()
                                for (var x = 0; x <= width; x++) {
                                    var y = centerY + amplitude * Math.sin(frequency * x)
                                    if (x === 0)
                                        ctx.moveTo(x, y)
                                    else
                                        ctx.lineTo(x, y)
                                }
                                ctx.stroke()

                            }
                            onWidthChanged: requestPaint()
                            onHeightChanged: requestPaint()
                        }

                        Text {
                            id: newNotifText
                            text: notifDelegate.newNotifCount > 1 ? notifDelegate.newNotifCount + " new notifications" :
                                                      notifDelegate.newNotifCount + " new notification"
                            font.pixelSize: 28 * Constants.scaleFactor
                            font.family: "Object Sans"
                            color: appTheme.bodyText
                        }

                        Canvas {
                            width: root.width / 2 - newNotifText.width / 2 - parent.spacing * 2
                            height: 20
                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.clearRect(0, 0, width, height)

                                ctx.strokeStyle = appTheme.bodyText
                                ctx.lineWidth = 2 * Constants.scaleFactor

                                var amplitude = parent.height * 0.2
                                var frequency = 2 * Math.PI / width * 7   // 12 cycles across width
                                var centerY = height / 2

                                ctx.beginPath()
                                for (var x = 0; x <= width; x++) {
                                    var y = centerY + amplitude * Math.sin(frequency * x)
                                    if (x === 0)
                                        ctx.moveTo(x, y)
                                    else
                                        ctx.lineTo(x, y)
                                }
                                ctx.stroke()
                            }

                            onWidthChanged: requestPaint()
                            onHeightChanged: requestPaint()
                        }
                    }


                }
            }

            // Dégradé haut
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 80 * Constants.scaleFactor
                opacity: listView.contentY > 0 ? 1 : 0
                z: 10
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.darker(appTheme.backgroundColor, 1.5) }
                    GradientStop { position: 0.1; color: "transparent" }
                }

                Behavior on opacity {
                    NumberAnimation { duration: 200 }
                }
            }

            // Dégradé bas
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 80 * Constants.scaleFactor
                opacity: listView.contentY < listView.contentHeight - notifScroll.height - 1 ? 1 : 0
                z: 10
                gradient: Gradient {
                    GradientStop { position: 0.90; color: "transparent" }
                    GradientStop { position: 1.0; color: Qt.darker(appTheme.backgroundColor, 1.5) }
                }

                Behavior on opacity {
                    NumberAnimation { duration: 200 }
                }
            }

        }

        RowLayout {
            Button {
                id: buttonAddNotif
                Layout.preferredHeight: 60
                Layout.preferredWidth: 120
                contentItem: Text {horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter; text: "New notif"; color: appTheme.bodyText}
                background: Rectangle {
                    color: Qt.darker(appTheme.backgroundColor, 1.5)
                    radius: 25
                }

                onClicked: {
                    notifModel.append({code: "M230", date: "16/07 09:46:55", acquitted: false})
                    listView.positionViewAtEnd()
                    notificationPopup.open()
                }
            }

        }

    }

    OpcUaMonitoredNode {
        monitored: root.visible
        id: opcuaNodeError
        nodeId: "Arp.Plc.Eclr/bobinkErreur"
        onValueChanged: {
            root.errorID = value
        }
    }
}
