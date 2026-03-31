import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Bobink
import "../.."

TextField {
    id: root
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    readOnly: false
    cursorVisible: false

    implicitWidth: 120 * Constants.scaleFactor
    implicitHeight:  50 * Constants.scaleFactor

    required property real min
    required property real max
    property string unit: ""
    property string numericPart: ""
    property string numericPartLast: ""
    property string nodeId
    property string nodeIdLinked: ""
    property string nodeIdReset: ""
    property bool okChecked: false
    property bool replaceText: true
    property bool negativeNumber: false //true = the TextField allows negative numbers
    property real offset: 1 // Facteur de différence entre la valeur machine et la valeur affichée
    property int digit: 0

    font.pixelSize: 16 * Constants.scaleFactor

    property real opcuaValue: isNaN(opcuaNode.value) ? "NaN" : opcuaNode.value * offset
    text: nodeId != "" ? digit == 0 ? opcuaValue + " " + unit : Number(opcuaValue).toFixed(digit) + " " + unit
                       : numericPart + " " + unit

    color: root.readOnly === true ? "#F0F0F0" : "black"

    background: Rectangle {
        radius: 20 * Constants.scaleFactor
        color: root.readOnly === true ? "transparent" : "#F0F0F0"
        border.width: 2 * Constants.scaleFactor
        border.color: Qt.darker("#F0F0F0", 1.3)

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            border.width: 0
            color: root.enabled ? "transparent" : "grey"
            opacity: 0.6
        }

        Label {
            visible: root.nodeIdReset !== ""
            anchors.verticalCenter: parent.verticalCenter
            x: parent.width - width - Constants.dp(15)
            text: "⨉"
            opacity: 0.85
            color: appTheme.bodyText
            font.pixelSize: Constants.sp(15)
        }


    }

    Popup {
        id: popup
        width: 500 * Constants.scaleFactor
        height: 600 * Constants.scaleFactor
        anchors.centerIn: Overlay.overlay
        modal: true
        dim: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        padding: 35 * Constants.scaleFactor

        background: Rectangle {
            color: Qt.lighter(appTheme.backgroundColor, 1.2)
            radius: 30 * Constants.scaleFactor
            border.color: Qt.darker(appTheme.backgroundColor, 1.2)
            border.width: 3 * Constants.scaleFactor
        }

        contentItem: ColumnLayout {
            TextField {
                id: txtField
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                readOnly: true
                font.pixelSize: 24 * Constants.scaleFactor
                text: root.numericPart + " " + root.unit
                color: "black"

                background: Rectangle {
                    implicitHeight: 60 * Constants.scaleFactor
                    width: parent.width - 70 * Constants.scaleFactor
                    color: "#F0F0F0"
                    border.width: 2 * Constants.scaleFactor
                    border.color: Qt.darker("#F0F0F0", 1.3)
                    radius: 10 * Constants.scaleFactor
                    anchors.centerIn: parent
                }

                onPressed: replaceText = false
            }

            Label {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.italic: true
                font.pixelSize: 20 * Constants.scaleFactor
                color: "#ec6b6b"
                text: {
                    let value = parseFloat(root.numericPart)
                    if (isNaN(value)) return ""
                    if (value < root.min)
                        qsTr("Valeur inférieure à ") + root.min.toString()
                    else if (value > root.max)
                        qsTr("Valeur supérieure à ") + root.max.toString()
                    else
                        ""
                }
            }

            GridLayout {
                id: gridLayout
                Layout.alignment: Qt.AlignHCenter
                columns: 4
                columnSpacing: 20
                rowSpacing: 20

                Repeater {
                    model: ["1", "2", "3", "x", "4", "5", "6", "←", "7", "8", "9", "OK", root.negativeNumber ? "-" : "00", "0", "."]

                    Button {
                        id: button
                        property real btnWidth: (popup.width - 3 * gridLayout.columnSpacing - 2 * popup.padding) / 4
                        property real btnHeight: (popup.height - 4 * gridLayout.rowSpacing - txtField.height - 1 * popup.padding) / 6

                        text: modelData
                        Layout.preferredWidth: btnWidth
                        Layout.preferredHeight: modelData === "OK" ? btnHeight * 2 + gridLayout.rowSpacing : btnHeight
                        Layout.rowSpan: modelData === "OK" ? 2 : 1

                        opacity: text === "" ? 0.0 : 1.0
                        enabled: text !== ""

                        contentItem: Text {
                            text: parent.text
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: 20 * Constants.scaleFactor
                            color: appTheme.bodyText

                        }

                        background: Item {
                            anchors.fill: parent
                            Rectangle {
                                anchors.fill: parent
                                anchors.verticalCenter: parent.verticalCenter
                                radius: 30 * Constants.scaleFactor
                                gradient: Gradient {
                                        orientation: Gradient.Vertical
                                        GradientStop {position: 0.0; color: button.pressed ? "black" : "white"}
                                        GradientStop {position: button.pressed ? 0.8 : 0.2; color: "grey"}
                                        GradientStop {position: 1.0; color: button.pressed ? "white" : "black"}
                                    }
                                opacity: 0.3

                                border.width: 0
                            }


                            Rectangle {
                                width: parent.width - 2 * Constants.scaleFactor
                                height: parent.height - 2 * Constants.scaleFactor
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                radius: 30 * Constants.scaleFactor
                                color: {
                                    if (modelData === "OK") { "#409c4e" }
                                    else if (modelData === "←") { "#f2d95c" }
                                    else if (modelData === "x") { "#b32e27" }
                                    else { Qt.darker(appTheme.backgroundColor, 1.1) }
                                }
                                border.width: 0
                                opacity: 1

                                Rectangle {
                                    width: parent.width - 10 * Constants.scaleFactor
                                    height: parent.height - 10 * Constants.scaleFactor
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    radius: 25 * Constants.scaleFactor
                                    gradient: Gradient {
                                            orientation: Gradient.Vertical
                                            GradientStop {position: 0.0; color: button.pressed ? "black" : "white"}
                                            GradientStop {position: button.pressed ? 0.8 : 0.2; color: "grey"}
                                            GradientStop {position: 1.0; color: button.pressed ? "white" : "black"}
                                        }
                                    opacity: 0.3

                                    border.width: 0
                                    visible: (["OK", "←", "x"].indexOf(modelData) !== -1) // test si modelData est égal à l'un des str de la liste
                                }

                                Rectangle {
                                    width: parent.width - 12 * Constants.scaleFactor
                                    height: parent.height - 12 * Constants.scaleFactor
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    radius: 25 * Constants.scaleFactor
                                    color: Qt.darker(appTheme.backgroundColor, 1.1)
                                    border.width: 0
                                    opacity: 1
                                    visible: (["OK", "←", "x"].indexOf(modelData) !== -1) // test si modelData est égal à l'un des str de la liste
                                }
                            }


                        }

                        onClicked: {
                            if (modelData === "←") {
                                root.numericPart = root.numericPart.slice(0, -1)
                                root.replaceText = false
                            } else if (modelData === "OK") {
                                let value = parseFloat(root.numericPart)
                                if (!isNaN(value) && value >= root.min && value <= root.max) {
                                    // root.text = parseFloat(root.numericPart).toString() + " " + root.unit
                                    root.okChecked = true
                                    opcuaNode.writeValue(value / root.offset)
                                    if (nodeIdLinked !== "") {
                                        opcuaLoaderLinkedId.item.writeValue(value / root.offset)
                                        console.log("Node " + root.nodeIdLinked + " a changé : " + value)
                                    }
                                    popup.close()
                                }
                            } else if (modelData === "x") {
                                root.numericPart = root.numericPartLast
                                popup.close()
                            } else if (root.replaceText){
                                root.numericPart = modelData
                                root.replaceText = false
                            } else {
                                root.numericPart += modelData
                            }
                            txtField.text = root.numericPart + " " + root.unit

                        }
                    }
                }

            }
        }

        onClosed: {
            if (root.okChecked === false) {
                root.numericPart = root.numericPartLast
            }
        }

        onOpened: {
            root.replaceText = true

            // Extrait la valeur numérique uniquement
            root.numericPart = root.text.split(" ")[0]
            root.numericPartLast = root.numericPart
            txtField.text = root.numericPart + " " + root.unit
        }
    }
    OpcUaMonitoredNode {
        monitored: root.visible
        id: opcuaNode
        nodeId: root.nodeId
        onValueChanged: {
            root.numericPart = value * root.offset
        }
    }

    Loader {
        id: opcuaLoaderLinkedId
        active: root.nodeIdLinked !== ""
        sourceComponent: opcuaNodeComponentLinkedId
    }

    Component {
        id: opcuaNodeComponentLinkedId
        OpcUaMonitoredNode {
            monitored: root.visible
            nodeId: root.nodeIdLinked
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: !root.readOnly ? popup.open() : ""
    }

    MouseArea {
        visible: root.nodeIdReset !== ""
        width: parent.width * 0.33
        height: parent.height
        anchors.verticalCenter: parent.verticalCenter
        x: parent.width - width

        onPressed: {
            console.log("Reset du numericInput")
            if(opcuaLoaderReset.item) {
                opcuaLoaderReset.item.writeValue(true)
            }
        }

        onReleased: {
            if(opcuaLoaderReset.item) {
                opcuaLoaderReset.item.writeValue(false)
            }
        }

        Loader {
            id: opcuaLoaderReset
            active: root.nodeIdReset !== ""
            sourceComponent: opcuaNodeReset
        }

        Component {
            id: opcuaNodeReset
            OpcUaMonitoredNode {
                monitored: root.visible
                nodeId: root.nodeIdReset
            }
        }

    }
}
