import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Resources/Components"
import Bobink
import "ventilationData.js" as Data
import "../"
Item {
    repeaterChauffe.model: Data.chauffe
    repeaterVentilation.model: Data.ventilation

    id: root
    width: 1600
    height: 800

    ////    ALIAS    ////
    property alias repeaterChauffe: repeaterChauffe
    property alias repeaterVentilation: repeaterVentilation
    /////////////////////

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Constants.dp(10)

        RowLayout {
            Layout.fillWidth: true

            Text {
                Layout.leftMargin: 40 * Constants.scaleFactor
                Layout.topMargin: 0 * Constants.scaleFactor
                text: qsTr("Paramètres avancés fours")
                font.pixelSize: Math.max(30, root.width * 0.03)
                font.bold: true
                color: appTheme.bodyText
            }

            Item { Layout.fillWidth: true }

            ModuleButton {
                labelText: qsTr("Retour")
                Layout.preferredHeight: parent.height * 0.8
                Layout.preferredWidth: Constants.dp(80)

                onClicked: stackLayoutPage.currentIndex = 3
            }
        }

        StyledFrame {//  GOUPBOX VENTILATION  \\
            id: groupBoxVentilation
            style: "shadowed"
            padding: Constants.dp(10)
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            ColumnLayout {
                spacing: 0
                Layout.fillWidth: true

                Button {
                    id: ventilBtn
                    checkable: true
                    Layout.preferredWidth: groupBoxVentilation.width
                    Layout.preferredHeight: Constants.dp(50)

                    background: Rectangle {
                        color: "transparent"
                    }

                    Label {
                        anchors.verticalCenter: ventilBtn.verticalCenter
                        text: qsTr("Ventilation")
                        font.pixelSize: Constants.sp(30)
                        color: appTheme.bodyText
                        font.bold: true
                    }

                    Text {
                        id: extendableLabel
                        color: appTheme.moduleText
                        text: ventilBtn.checked ? "⮝" : "⮟"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: Constants.dp(30)
                        font.bold: true
                        font.pixelSize: Constants.sp(30)
                    }

                    onCheckedChanged: {
                        layoutVentilation.visible = checked
                        if (checked && chauffeBtn.checked) { chauffeBtn.checked = false }
                    }
                }

                RowLayout { //  LAYOUT VENTILLATION  \\
                    id: layoutVentilation
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    visible: false

                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                    Repeater {
                        id: repeaterVentilation

                        delegate: StyledFrame {
                            style: "thin"
                            spacing: 0
                            padding: 0
                            ColumnLayout {//  LAYOUT VENTILLATION FOUR \\
                                spacing: 0
                                Label {
                                    text: modelData.motor
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    font.bold: true
                                    font.pointSize: 12
                                    color: appTheme.bodyText
                                    padding: 10
                                }

                                RowLayout {//  LAYOUT VENTILLATION FOUR \\
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    StyledFrame {// LEFT COLUMN VENTILATION  \\
                                        style: "thin"
                                        contentItem: ColumnLayout {
                                            spacing: 0
                                            Label {
                                                text: "sts"
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                                font.bold: true
                                                font.pointSize: 12
                                                color: appTheme.bodyText
                                            }
                                            GridLayout {
                                                Layout.fillHeight: true
                                                Layout.fillWidth: true
                                                rowSpacing: Constants.spacing / 2
                                                columnSpacing: Constants.spacing
                                                columns: 2
                                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                                Label {
                                                    text: qsTr("xRunning")
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter
                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignVCenter
                                                    color: appTheme.bodyText
                                                }
                                                StatusIndicator {
                                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                                    nodeId: modelData.xRunning
                                                }

                                                Label {
                                                    text: qsTr("xError")
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter
                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignVCenter
                                                    color: appTheme.bodyText
                                                }
                                                StatusIndicator {
                                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                                    nodeId: modelData.xError
                                                }

                                                Label {
                                                    text: qsTr("ActualVelo")
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter
                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignVCenter
                                                    color: appTheme.bodyText
                                                }
                                                NumericInput {
                                                    readOnly: true
                                                    unit: qsTr("rpm")
                                                    Layout.preferredWidth: 75
                                                    min:350
                                                    max:2000
                                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignVCenter
                                                    nodeId: modelData.ActualVelo
                                                }

                                                Label {
                                                    text: qsTr("sState")
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter
                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignVCenter
                                                    color: appTheme.bodyText
                                                }
                                                NumericInput {
                                                    readOnly: true
                                                    unit: qsTr("rpm")
                                                    Layout.preferredWidth: 75
                                                    min:350
                                                    max:2000
                                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignVCenter
                                                    nodeId: modelData.sState
                                                }

                                                Label {
                                                    text: qsTr("xReadyToSwitchOn")
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter
                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignVCenter
                                                    color: appTheme.bodyText
                                                }
                                                StatusIndicator {
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter
                                                    nodeId: modelData.xReadyToSwitchOn
                                                }

                                                Label {
                                                    text: qsTr("xSwitchedOn")
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter
                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignVCenter
                                                    color: appTheme.bodyText
                                                }
                                                StatusIndicator {
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter
                                                    nodeId: modelData.xSwitchedOn
                                                }

                                                Label {
                                                    text: qsTr("xOperationEnabled")
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter
                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignVCenter
                                                    color: appTheme.bodyText
                                                }
                                                StatusIndicator {
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter
                                                    nodeId: modelData.xOperationEnabled
                                                }

                                                Label {
                                                    text: qsTr("xFault")
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter
                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignVCenter
                                                    color: appTheme.bodyText
                                                }
                                                StatusIndicator {
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter
                                                    nodeId: modelData.xFault
                                                }

                                                Label {
                                                    text: qsTr(
                                                              "xVoltageEnabled")
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter
                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignVCenter
                                                    color: appTheme.bodyText
                                                }
                                                StatusIndicator {
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter
                                                    nodeId: modelData.xVoltageEnabled
                                                }

                                                Label {
                                                    text: qsTr("xQuickStop")
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter
                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignVCenter
                                                    color: appTheme.bodyText
                                                }
                                                StatusIndicator {
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter
                                                    nodeId: modelData.xQuickStop
                                                }

                                                Label {
                                                    text: qsTr("xSwitchOnDisabled")
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter
                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignVCenter
                                                    color: appTheme.bodyText
                                                }
                                                StatusIndicator {
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter
                                                    nodeId: modelData.xSwitchOnDisabled
                                                }

                                                Label {
                                                    text: qsTr("xWarning")
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter
                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignVCenter
                                                    color: appTheme.bodyText
                                                }
                                                StatusIndicator {
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter
                                                    nodeId: modelData.xWarning
                                                }

                                                Label {
                                                    text: qsTr("xAtVelo")
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter
                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignVCenter
                                                    color: appTheme.bodyText
                                                }
                                                StatusIndicator {
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter
                                                    nodeId: modelData.xAtVelo
                                                }

                                                Label {
                                                    text: qsTr("xRemote")
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter
                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignVCenter
                                                    color: appTheme.bodyText
                                                }
                                                StatusIndicator {
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter
                                                    nodeId: modelData.xRemote
                                                }
                                            }
                                        }
                                    }

                                    ColumnLayout {// RIGHT COLUMN VENTILATION  \\
                                        Layout.alignment: Qt.AlignTop
                                        Layout.fillWidth: true
                                        StyledFrame {// CMD  \\
                                            style: "thin"
                                            Layout.alignment: Qt.AlignTop
                                            Layout.fillWidth: true
                                            ColumnLayout {
                                                Layout.fillWidth: true
                                                Label {
                                                    text: "cmd"
                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignVCenter
                                                    font.bold: true
                                                    font.pointSize: 12
                                                    color: appTheme.bodyText
                                                }
                                                GridLayout {
                                                    Layout.fillHeight: true
                                                    Layout.fillWidth: true
                                                    rowSpacing: Constants.spacing / 2
                                                    columnSpacing: Constants.spacing
                                                    columns: 2
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter
                                                    Label {
                                                        text: qsTr("xRun")
                                                        Layout.alignment: Qt.AlignHCenter
                                                                          | Qt.AlignVCenter
                                                        horizontalAlignment: Text.AlignHCenter
                                                        verticalAlignment: Text.AlignVCenter
                                                        color: appTheme.bodyText
                                                    }
                                                    StatusIndicator {
                                                        Layout.alignment: Qt.AlignHCenter
                                                                          | Qt.AlignVCenter
                                                        nodeId: modelData.xRun
                                                    }

                                                    Label {
                                                        text: qsTr("xClear")
                                                        Layout.alignment: Qt.AlignHCenter
                                                                          | Qt.AlignVCenter
                                                        horizontalAlignment: Text.AlignHCenter
                                                        verticalAlignment: Text.AlignVCenter
                                                        color: appTheme.bodyText
                                                    }
                                                    StatusIndicator {
                                                        Layout.alignment: Qt.AlignHCenter
                                                                          | Qt.AlignVCenter
                                                        nodeId: modelData.xClear
                                                    }

                                                    Label {
                                                        text: qsTr("Velo")
                                                        Layout.alignment: Qt.AlignHCenter
                                                                          | Qt.AlignVCenter
                                                        horizontalAlignment: Text.AlignHCenter
                                                        verticalAlignment: Text.AlignVCenter
                                                        color: appTheme.bodyText
                                                    }
                                                    NumericInput {
                                                        unit: qsTr("rpm")
                                                        Layout.preferredWidth: 75
                                                        min:350
                                                        max:2000
                                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                                        horizontalAlignment: Text.AlignHCenter
                                                        verticalAlignment: Text.AlignVCenter
                                                        nodeId: modelData.cmdVelo
                                                    }
                                                }
                                            }
                                        }
                                        StyledFrame {//  In  \\
                                            style: "thin"
                                            Layout.fillWidth: true
                                            Layout.alignment: Qt.AlignTop
                                            contentItem: ColumnLayout {
                                                Label {
                                                    text: "In"
                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignVCenter
                                                    font.bold: true
                                                    font.pointSize: 12
                                                    color: appTheme.bodyText
                                                }
                                                GridLayout {
                                                    Layout.fillHeight: true
                                                    Layout.fillWidth: true
                                                    rowSpacing: Constants.spacing / 2
                                                    columnSpacing: Constants.spacing
                                                    columns: 2
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter

                                                    Label {
                                                        text: qsTr("StsWord")
                                                        Layout.alignment: Qt.AlignHCenter
                                                                          | Qt.AlignVCenter
                                                        horizontalAlignment: Text.AlignHCenter
                                                        verticalAlignment: Text.AlignVCenter
                                                        color: appTheme.bodyText
                                                    }
                                                    NumericInput {
                                                        Layout.preferredWidth: 75
                                                        min:0
                                                        max:65535
                                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                                        horizontalAlignment: Text.AlignHCenter
                                                        verticalAlignment: Text.AlignVCenter
                                                        nodeId: modelData.StsWord
                                                    }

                                                    Label {
                                                        text: qsTr("VlControlEffort")
                                                        Layout.alignment: Qt.AlignHCenter
                                                                          | Qt.AlignVCenter
                                                        horizontalAlignment: Text.AlignHCenter
                                                        verticalAlignment: Text.AlignVCenter
                                                        color: appTheme.bodyText
                                                    }
                                                    NumericInput {
                                                        unit: qsTr("rpm")
                                                        Layout.preferredWidth: 75
                                                        min:350
                                                        max:2000
                                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                                        horizontalAlignment: Text.AlignHCenter
                                                        verticalAlignment: Text.AlignVCenter
                                                        nodeId: modelData.VlControlEffort
                                                    }
                                                }
                                            }
                                        }
                                        StyledFrame {//  Out  \\
                                            style: "thin"
                                            Layout.fillWidth: true
                                            Layout.alignment: Qt.AlignTop
                                            contentItem: ColumnLayout {
                                                Label {
                                                    text: "Out"
                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignVCenter
                                                    font.bold: true
                                                    font.pointSize: 12
                                                    color: appTheme.bodyText
                                                }
                                                GridLayout {
                                                    Layout.fillHeight: true
                                                    Layout.fillWidth: true
                                                    rowSpacing: Constants.spacing / 2
                                                    columnSpacing: Constants.spacing
                                                    columns: 2
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter

                                                    Label {
                                                        text: qsTr("CtrlWord")
                                                        Layout.alignment: Qt.AlignHCenter
                                                                          | Qt.AlignVCenter
                                                        horizontalAlignment: Text.AlignHCenter
                                                        verticalAlignment: Text.AlignVCenter
                                                        color: appTheme.bodyText
                                                    }
                                                    NumericInput {
                                                        readOnly: true
                                                        Layout.preferredWidth: 75
                                                        min:350
                                                        max:2000
                                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                                        horizontalAlignment: Text.AlignHCenter
                                                        verticalAlignment: Text.AlignVCenter
                                                        nodeId: modelData.CtrlWord
                                                    }

                                                    Label {
                                                        text: qsTr("Velo")
                                                        Layout.alignment: Qt.AlignHCenter
                                                                          | Qt.AlignVCenter
                                                        horizontalAlignment: Text.AlignHCenter
                                                        verticalAlignment: Text.AlignVCenter
                                                        color: appTheme.bodyText
                                                    }
                                                    NumericInput {
                                                        readOnly: true
                                                        unit: qsTr("rpm")
                                                        Layout.preferredWidth: 75
                                                        min:350
                                                        max:2000
                                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                                        horizontalAlignment: Text.AlignHCenter
                                                        verticalAlignment: Text.AlignVCenter
                                                        nodeId: modelData.outVelo
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                        }
                    }
                }
            }
        }

        StyledFrame {//  GROUPBOX CHAUFFE  \\

            id: groupBoxChauffe
            style: "shadowed"
            padding: groupBoxVentilation.padding
            Layout.fillWidth: true

            ColumnLayout {
                spacing: 0
                Layout.fillWidth: true

                Button {
                    id: chauffeBtn
                    checkable: true
                    Layout.preferredWidth: groupBoxChauffe.width
                    Layout.preferredHeight: Constants.dp(50)

                    background: Rectangle {
                        color: "transparent"
                    }

                    Label {
                        anchors.verticalCenter: chauffeBtn.verticalCenter
                        text: qsTr("Chauffe")
                        font.pixelSize: Constants.sp(30)
                        color: appTheme.bodyText
                        font.bold: true
                    }

                    Text {
                        color: appTheme.moduleText
                        text: chauffeBtn.checked ? "⮝" : "⮟"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: Constants.dp(30)
                        font.bold: true
                        font.pixelSize: Constants.sp(30)
                    }

                    onCheckedChanged: {
                        layoutChauffe.visible = checked
                        if (checked && ventilBtn.checked) { ventilBtn.checked = false }
                    }
                }
                RowLayout {
                    id: layoutChauffe
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    visible: false

                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                    Repeater {
                        id: repeaterChauffe

                        delegate: StyledFrame {
                            ColumnLayout {
                                spacing: 0
                                Label {
                                    text: modelData.location
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    font.bold: true
                                    font.pointSize: 12
                                    color: appTheme.bodyText
                                }
                                GridLayout {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    rowSpacing: Constants.spacing / 2
                                    columnSpacing: Constants.spacing
                                    columns: 2
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                                    GridLayout {
                                        id: gridLayout
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                        rowSpacing: Constants.spacing / 2
                                        columnSpacing: Constants.spacing
                                        columns: 2
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                                        Label {
                                            text: qsTr("Enable")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            color: appTheme.bodyText
                                        }
                                        StatusIndicator {
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: modelData.enable
                                        }

                                        Label {
                                            text: qsTr("Relais Statique")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            color: appTheme.bodyText
                                        }
                                        StatusIndicator {
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: modelData.relaisStatique
                                        }

                                        Label {
                                            text: qsTr("Consigne")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            color: appTheme.bodyText
                                        }
                                        NumericInput {
                                            unit: qsTr("°C")
                                            Layout.preferredWidth: 75
                                            min:0
                                            max:200
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            nodeId: modelData.consigne
                                        }

                                        Label {
                                            text: qsTr("Disjoncteur")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            color: appTheme.bodyText
                                        }
                                        StatusIndicator {
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: modelData.disjoncteur
                                        }

                                        Label {
                                            text: qsTr("Retour de Marche\nCommutateur")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            color: appTheme.bodyText
                                        }
                                        StatusIndicator {
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: modelData.RDMCommutateur
                                        }

                                        Label {
                                            text: qsTr("Batterie de Chauffe")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            color: appTheme.bodyText
                                        }
                                        NumericInput {
                                            readOnly: true
                                            unit: qsTr("°C")
                                            Layout.preferredWidth: 75
                                            min:350
                                            max:2000
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            nodeId: modelData.pt100BC
                                        }

                                        Label {
                                            text: qsTr("Sortie Four")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            color: appTheme.bodyText
                                        }
                                        NumericInput {
                                            readOnly: true
                                            unit: qsTr("°C")
                                            Layout.preferredWidth: 75
                                            min:350
                                            max:2000
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            nodeId: modelData.pt100Four
                                        }

                                        Label {
                                            text: qsTr("Status Température")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            color: appTheme.bodyText
                                        }
                                        NumericInput {
                                            readOnly: true
                                            Layout.preferredWidth: 75
                                            min:350
                                            max:2000
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            nodeId: modelData.statusTemperature
                                        }

                                        Label {
                                            text: qsTr("Status Chauffe")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            color: appTheme.bodyText
                                        }
                                        NumericInput {
                                            readOnly: true
                                            Layout.preferredWidth: 75
                                            min:0
                                            max:200
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            nodeId: modelData.statusChauffe
                                        }

                                        Label {
                                            text: qsTr("Temperature OK")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            color: appTheme.bodyText
                                        }
                                        StatusIndicator {
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: modelData.temperatureOK
                                        }

                                        Label {
                                            text: qsTr("Warning")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            color: appTheme.bodyText
                                        }
                                        StatusIndicator {
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: modelData.warning

                                        }
                                        Label {
                                            text: qsTr("Error")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            color: appTheme.bodyText
                                        }
                                        StatusIndicator {
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: modelData.error
                                        }

                                        Label {
                                            text: qsTr("Chauffe")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            color: appTheme.bodyText
                                        }
                                        StatusIndicator {
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: modelData.chauffe
                                        }
                                        Label {
                                            text: qsTr("Commutateur")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            color: appTheme.bodyText
                                        }

                                        StatusIndicator {
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: modelData.commutateur
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }

    }

}
