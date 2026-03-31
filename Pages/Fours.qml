import QtQuick
import QtQuick.Controls
import Bobink
import QtQuick.Layouts
import "../Resources/Components"
import "../"

Item {
    id: root

    property int textfieldwidth: 100

    property alias manualModeButton: manualModeButton

    ColumnLayout {
        id: columnlayout

        anchors.fill: parent
        anchors.margins: 40 * Constants.scaleFactor
        spacing: 40 * Constants.scaleFactor

        RowLayout {
            Layout.fillWidth: true
            spacing: Constants.dp(15)

            Text {
                Layout.fillWidth: true

                text: qsTr("Fours")
                font.pixelSize: Math.max(35, parent.width * 0.037)
                font.bold: true
                color: appTheme.bodyText
            }

            Item {
                Layout.fillWidth: true
            }

            OptionButton {
                id: deepVentilationBtn
                Layout.preferredWidth: manualModeButton.height
                Layout.preferredHeight: width
                onClicked: stackLayoutPage.currentIndex = 9
            }

            ManuelSwitch {
                id: manualModeButton
                Layout.alignment: Qt.AlignRight
                // OPCUANode {
                //     nodeId: "Arp.Plc.Eclr/modeAutomatiqueFour1"
                //     onValueChanged: manualModeButton.checked = value
                // }
            }
        }


        RowLayout {
            id: fours1_2Page
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 50 * Constants.scaleFactor

            StyledFrame {
                id: frameFour1
                Layout.fillHeight: true
                Layout.fillWidth: true
                style: "shadowed"
                padding: Constants.dp(15)
                shadowColor: manualModeButton.checked ? "#deae2a" : switchChauffeFour1.checked ? "#35a646" : "black"

                ColumnLayout {
                    anchors.fill: parent
                    spacing: Constants.dp(20)

                    RowLayout {
                        spacing: 20 * Constants.scaleFactor

                        Item {
                            Layout.preferredWidth:  manualModeButton.checked ? frameFour1.width * 0.12 + lumiereLayout.width + parent.spacing
                                                                             : frameFour1.width * 0.12
                        }

                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: "Four 1"
                            font.pixelSize: Constants.sp(45)
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            color: appTheme.bodyText
                            Layout.fillWidth: true
                        }

                        ColumnLayout {
                            id: lumiereLayout
                            spacing: Constants.dp(5)
                            visible: manualModeButton.checked
                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: "Manuel\nLumière 1"
                                font.pixelSize: Constants.sp(14)
                                horizontalAlignment: Text.AlignHCenter
                                color: appTheme.bodyText
                            }

                            CustomSwitch {
                                Layout.alignment: Qt.AlignHCenter
                                nodeId: "Arp.Plc.Eclr/manuelEclairageCognexFour1"
                            }

                        }

                        StyledFrame {
                            id: congnex1Btn
                            style: "shadowed"
                            Layout.preferredWidth: frameFour1.width * 0.12
                            Layout.preferredHeight: width

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 0

                                Label {
                                    text: "Caméra 1"
                                    color: appTheme.bodyText
                                    Layout.alignment: Qt.AlignHCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: Constants.sp(14)
                                    font.bold: true
                                }

                                Image {
                                    source: "../Resources/Images/Camera.svg"
                                    Layout.preferredWidth: congnex1Btn.width * 0.5
                                    Layout.preferredHeight: width
                                    Layout.alignment: Qt.AlignHCenter

                                }

                            }

                            MouseArea {
                                anchors.fill: parent

                                onClicked: {
                                    cognexLoader.source = "../Maintenance/WebEngine.qml"
                                    cognexPage.visible = true
                                    columnlayout.visible = false
                                    stackLayoutPage.numeroCognex = 1
                                    // stackLayoutPage.currentIndex = 11
                                }
                            }
                        }

                    }

                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: parent.width / 1.5
                        height: 1
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop { position : 0.0; color: "transparent" }
                            GradientStop { position : 0.25; color: appTheme.bodyText }
                            GradientStop { position : 0.75; color: appTheme.bodyText}
                            GradientStop { position : 1.0; color: "transparent" }
                        }
                    }

                    RowLayout {
                        spacing: Constants.dp(20)
                        Layout.alignment: Qt.AlignHCenter | Qt.alignTop

                        ColumnLayout {
                            Label {
                                text: qsTr("Consigne")
                                font.pixelSize: 22 * Constants.scaleFactor
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                color: appTheme.bodyText
                            }

                            NumericInput {
                                id: consigneFour1
                                horizontalAlignment: Text.AlignHCenter
                                unit: qsTr("°C")
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.preferredHeight: 60 * Constants.scaleFactor
                                Layout.preferredWidth: 175 * Constants.scaleFactor
                                min: 0
                                max: 300
                                nodeId: "Arp.Plc.Eclr/consigneTemperatureFour1"
                                enabled: switchChauffeFour1.checked
                            }
                        }

                        ColumnLayout {
                            Label {
                                text: qsTr("Chauffe")
                                font.pixelSize: 22 * Constants.scaleFactor
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                color: appTheme.bodyText
                            }
                            CustomSwitch {
                                id: switchChauffeFour1
                                text: qsTr("")
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.preferredHeight: 50 * Constants.scaleFactor
                                Layout.preferredWidth: 100 * Constants.scaleFactor
                                nodeId: "Arp.Plc.Eclr/chauffeBCGeneral"

                                onCheckedChanged: {
                                    if (!switchChauffeFour1.checked) {
                                        consigneFour1.numericPart = ""
                                    }
                                }
                            }

                        }
                    }

                    StyledFrame {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                        ColumnLayout {
                            anchors.fill: parent

                            Label {
                                text: qsTr("Ratios Vitesse")
                                font.pixelSize: 24 * Constants.scaleFactor
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                font.bold: true
                                color: appTheme.bodyText
                            }

                            RowLayout {
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                spacing: Constants.dp(20)

                                ColumnLayout {
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                                    Label {
                                        text: qsTr("Dépose Fil")
                                        font.pixelSize: 22 * Constants.scaleFactor
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        color: appTheme.bodyText
                                    }
                                    NumericInput {
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("‰")
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        Layout.preferredHeight: 60 * Constants.scaleFactor
                                        Layout.preferredWidth: 175 * Constants.scaleFactor
                                        min: 0
                                        max: 10000
                                        nodeId: "Arp.Plc.Eclr/ratioDeposeFilsFour1"
                                    }

                                }

                                ColumnLayout {
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                                    Label {
                                        text: qsTr("Tapis")
                                        font.pixelSize: 22 * Constants.scaleFactor
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        color: appTheme.bodyText
                                    }
                                    NumericInput {
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("‰")
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        Layout.preferredHeight: 60 * Constants.scaleFactor
                                        Layout.preferredWidth: 175 * Constants.scaleFactor
                                        min: 0
                                        max: 10000
                                        nodeId: "Arp.Plc.Eclr/ratioTapisFour1"

                                    }

                                }
                            }
                        }
                    }

                    RowLayout {
                        id: temperaturesFour1
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        visible: !manualModeButton.checked

                        ColumnLayout {
                            id: tempMoyenneLayout
                            spacing: Constants.dp(5)

                            Label {
                                text: qsTr("T° Moyenne")
                                font.pixelSize: 22 * Constants.scaleFactor
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                color: appTheme.bodyText
                            }

                            GaugeProgress {
                                id: gaugeTempMoyenneFour1
                                Layout.alignment: Qt.AlignHCenter
                                // Layout.fillHeight: true       // ----> semble créer des récursivités, donc des crashs
                                Layout.preferredHeight: Constants.dp(115) // ----> pas responsive mais efficace
                                Layout.preferredWidth: height
                                nodeId: "Arp.Plc.Eclr/temperatureFour1"
                                fontSize: Constants.sp(29)
                                unit: "°C"
                                max: 300
                                alert: true
                            }

                        }

                        ColumnLayout {
                            spacing: Constants.dp(1)

                            RowLayout {
                                spacing: Constants.dp(5)

                                GaugeProgress {
                                    id: gaugeTempBCFour1
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.preferredHeight: tempMoyenneLayout.height / 3
                                    Layout.preferredWidth: height
                                    nodeId: "Arp.Plc.Eclr/temperatureBCFour1"
                                    fontSize: 0
                                    unit: "°C"
                                    max: 300
                                    alert: true
                                }

                                Label {
                                    font.pixelSize: 22 * Constants.scaleFactor
                                    font.bold: true
                                    color: appTheme.bodyText
                                    OpcUaMonitoredNode {
                                        monitored: root.visible
                                        nodeId: "Arp.Plc.Eclr/temperatureBCFour1"
                                        onValueChanged: parent.text = value.toFixed(1) + "°C"
                                    }
                                }

                                Label {
                                    text: qsTr(" T° BC")
                                    font.pixelSize: 22 * Constants.scaleFactor
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    color: appTheme.bodyText
                                }

                            }

                            RowLayout {
                                spacing: Constants.dp(5)

                                GaugeProgress {
                                    id: gaugeTempINFour1
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.preferredHeight: gaugeTempBCFour1.height
                                    Layout.preferredWidth: height
                                    nodeId: "Arp.Plc.Eclr/pt100_IN_Four1" // pt100_IN_Four1 ne marche pas
                                    offset: 0.1
                                    fontSize: 0
                                    unit: "°C"
                                    max: 300
                                    alert: true
                                }

                                Label {
                                    font.pixelSize: 22 * Constants.scaleFactor
                                    font.bold: true
                                    color: appTheme.bodyText
                                    OpcUaMonitoredNode {
                                        monitored: root.visible
                                        nodeId: "Arp.Plc.Eclr/pt100_IN_Four1"
                                        onValueChanged: parent.text = (value * gaugeTempINFour1.offset).toFixed(1) + "°C"
                                    }
                                }

                                Label {
                                    text: qsTr(" T° Entrée")
                                    font.pixelSize: 22 * Constants.scaleFactor
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    color: appTheme.bodyText
                                }

                            }

                            RowLayout {
                                spacing: Constants.dp(5)

                                GaugeProgress {
                                    id: gaugeTempOUTFour1
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.preferredHeight: gaugeTempBCFour1.height
                                    Layout.preferredWidth: height
                                    nodeId: "Arp.Plc.Eclr/pt100_OUT_Four1"
                                    offset: 0.1
                                    fontSize: 0
                                    unit: "°C"
                                    max: 300
                                    alert: true
                                }

                                Label {
                                    font.pixelSize: 22 * Constants.scaleFactor
                                    font.bold: true
                                    color: appTheme.bodyText
                                    OpcUaMonitoredNode {
                                        monitored: root.visible
                                        nodeId: "Arp.Plc.Eclr/pt100_OUT_Four1"
                                        onValueChanged: parent.text = (value * gaugeTempINFour1.offset).toFixed(1) + "°C"
                                    }
                                }

                                Label {
                                    text: qsTr(" T° Sortie")
                                    font.pixelSize: 22 * Constants.scaleFactor
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    color: appTheme.bodyText
                                }

                            }
                        }
                    }

                    GridLayout {
                        id: gridManuelFour1
                        rowSpacing: Constants.spacing * 1.5
                        columnSpacing: Constants.spacing
                        columns: 2
                        Layout.alignment: Qt.AlignHCenter | Qt.alignVCenter
                        visible: manualModeButton.checked

                        Label {
                            text: qsTr("Vérin rouleau four 1")
                            font.pixelSize: 22 * Constants.scaleFactor
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: appTheme.bodyText
                        }
                        CustomSwitch {
                            id: switchVerinRouleauFour1
                            text: qsTr("")
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            Layout.preferredHeight: 50 * Constants.scaleFactor
                            Layout.preferredWidth: 100 * Constants.scaleFactor
                            nodeId: "Arp.Plc.Eclr/manuelRouleauPresseurFour1"
                        }

                        Label {
                            text: qsTr("Tapis 1")
                            font.pixelSize: 22 * Constants.scaleFactor
                            color: appTheme.bodyText
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                        }

                        TapisSwitch {
                            id: sliderTapis1
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            Layout.preferredHeight: 50 * Constants.scaleFactor
                            Layout.preferredWidth: switchVerinRouleauFour1.width * 1.5
                            locked: true
                            nodeIdForward: "Arp.Plc.Eclr/startManuTapisFour1"
                            nodeIdBackward: "Arp.Plc.Eclr/reverseManuelTapisFour1"
                        }

                        Label {
                            text: qsTr("Dépose fil 1")
                            font.pixelSize: 22 * Constants.scaleFactor
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: appTheme.bodyText
                        }

                        CustomSwitch {
                            id: switchCoiler1
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            Layout.preferredHeight: 50 * Constants.scaleFactor
                            Layout.preferredWidth: 100 * Constants.scaleFactor
                            nodeId: "Arp.Plc.Eclr/startManuDeposeFilsFour1"

                        }

                        Label {
                            text: qsTr("Rouleau four 1")
                            font.pixelSize: 22 * Constants.scaleFactor
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: appTheme.bodyText
                        }
                        CustomSwitch {
                            id: switchMoteurFour1
                            text: qsTr("")
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            Layout.preferredHeight: 50 * Constants.scaleFactor
                            Layout.preferredWidth: 100 * Constants.scaleFactor
                            nodeId: "Arp.Plc.Eclr/startManuRouleauFour1"
                        }
                    }

                }
            }

            StyledFrame {
                id: frameFour2
                Layout.fillHeight: true
                Layout.fillWidth: true
                style: "shadowed"
                padding: Constants.dp(15)

                shadowColor: manualModeButton.checked ? "#deae2a" : switchChauffeFour2.checked ? "#35a646" : "black"

                ColumnLayout {
                    anchors.fill: parent
                    spacing: Constants.dp(20)

                    RowLayout {
                        spacing: 20 * Constants.scaleFactor

                        Item {
                            Layout.preferredWidth: manualModeButton.checked ? frameFour1.width * 0.12 + lumiereLayout.width + parent.spacing
                                                                            : frameFour1.width * 0.12
                        }

                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: "Four 2"
                            font.pixelSize: Constants.sp(45)
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            color: appTheme.bodyText
                            Layout.fillWidth: true
                        }

                        ColumnLayout {
                            spacing: Constants.dp(5)
                            visible: manualModeButton.checked
                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: "Manuel\nLumière 2"
                                font.pixelSize: Constants.sp(14)
                                horizontalAlignment: Text.AlignHCenter
                                color: appTheme.bodyText
                            }

                            CustomSwitch {
                                Layout.alignment: Qt.AlignHCenter
                                nodeId: "Arp.Plc.Eclr/manuelEclairageCognexFour2"
                            }

                        }

                        StyledFrame {
                            id: congnex2Btn
                            style: "shadowed"
                            Layout.preferredWidth: frameFour2.width * 0.12
                            Layout.preferredHeight: width

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 0

                                Label {
                                    text: "Caméra 2"
                                    color: appTheme.bodyText
                                    Layout.alignment: Qt.AlignHCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: Constants.sp(14)
                                    font.bold: true
                                }

                                Image {
                                    source: "../Resources/Images/Camera.svg"
                                    Layout.preferredWidth: congnex2Btn.width * 0.5
                                    Layout.preferredHeight: width
                                    Layout.alignment: Qt.AlignHCenter

                                }

                            }

                            MouseArea {
                                anchors.fill: parent

                                onClicked: {
                                    cognexLoader.source = "../Maintenance/WebEngine.qml"
                                    cognexPage.visible = true
                                    columnlayout.visible = false
                                    stackLayoutPage.numeroCognex = 2
                                }
                            }
                        }

                    }

                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: parent.width / 1.5
                        height: 1
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop { position : 0.0; color: "transparent" }
                            GradientStop { position : 0.25; color: appTheme.bodyText }
                            GradientStop { position : 0.75; color: appTheme.bodyText}
                            GradientStop { position : 1.0; color: "transparent" }
                        }
                    }

                    RowLayout {
                        spacing: Constants.dp(20)
                        Layout.alignment: Qt.AlignHCenter | Qt.alignTop

                        ColumnLayout {
                            Label {
                                text: qsTr("Consigne")
                                font.pixelSize: 22 * Constants.scaleFactor
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                color: appTheme.bodyText
                            }

                            NumericInput {
                                id: consigneFour2
                                horizontalAlignment: Text.AlignHCenter
                                unit: qsTr("°C")
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.preferredHeight: 60 * Constants.scaleFactor
                                Layout.preferredWidth: 175 * Constants.scaleFactor
                                min: 0
                                max: 300
                                nodeId: "Arp.Plc.Eclr/consigneTemperatureFour2"
                                enabled: switchChauffeFour2.checked
                            }
                        }

                        ColumnLayout {
                            Label {
                                text: qsTr("Chauffe")
                                font.pixelSize: 22 * Constants.scaleFactor
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                color: appTheme.bodyText
                            }
                            CustomSwitch {
                                id: switchChauffeFour2
                                text: qsTr("")
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.preferredHeight: 50 * Constants.scaleFactor
                                Layout.preferredWidth: 100 * Constants.scaleFactor
                                nodeId: "Arp.Plc.Eclr/chauffeBCGeneral"

                                onCheckedChanged: {
                                    if (!switchChauffeFour2.checked) {
                                        consigneFour2.numericPart = ""
                                    }
                                }
                            }

                        }
                    }

                    StyledFrame {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                        ColumnLayout {
                            anchors.fill: parent

                            Label {
                                text: qsTr("Ratios Vitesse")
                                font.pixelSize: 24 * Constants.scaleFactor
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                font.bold: true
                                color: appTheme.bodyText
                            }

                            RowLayout {
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                spacing: Constants.dp(20)

                                ColumnLayout {
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                                    Label {
                                        text: qsTr("Dépose Fil")
                                        font.pixelSize: 22 * Constants.scaleFactor
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        color: appTheme.bodyText
                                    }
                                    NumericInput {
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("‰")
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        Layout.preferredHeight: 60 * Constants.scaleFactor
                                        Layout.preferredWidth: 175 * Constants.scaleFactor
                                        min: 0
                                        max: 10000
                                        nodeId: "Arp.Plc.Eclr/ratioDeposeFilsFour2"
                                    }

                                }

                                ColumnLayout {
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                                    Label {
                                        text: qsTr("Tapis")
                                        font.pixelSize: 22 * Constants.scaleFactor
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        color: appTheme.bodyText
                                    }
                                    NumericInput {
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("‰")
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        Layout.preferredHeight: 60 * Constants.scaleFactor
                                        Layout.preferredWidth: 175 * Constants.scaleFactor
                                        min: 0
                                        max: 10000
                                        nodeId: "Arp.Plc.Eclr/ratioTapisFour2"

                                    }

                                }
                            }
                        }
                    }


                    RowLayout {
                        id: temperaturesFour2
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        visible: !manualModeButton.checked

                        ColumnLayout {
                            spacing: Constants.dp(5)

                            Label {
                                text: qsTr("T° Moyenne")
                                font.pixelSize: 22 * Constants.scaleFactor
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                color: appTheme.bodyText
                            }

                            GaugeProgress {
                                id: gaugeTempMoyenneFour2
                                Layout.alignment: Qt.AlignHCenter
                                // Layout.fillHeight: true       // ----> semble créer des récursivités, donc des crashs
                                Layout.preferredHeight: Constants.dp(115) // ----> pas responsive mais efficace
                                Layout.preferredWidth: height
                                nodeId: "Arp.Plc.Eclr/temperatureFour2"
                                fontSize: Constants.sp(29)
                                unit: "°C"
                                max: 300
                                alert: true
                            }

                        }

                        ColumnLayout {
                            spacing: Constants.dp(1)

                            RowLayout {
                                spacing: Constants.dp(5)

                                GaugeProgress {
                                    id: gaugeTempBCFour2
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.preferredHeight: tempMoyenneLayout.height / 3
                                    Layout.preferredWidth: height
                                    nodeId: "Arp.Plc.Eclr/temperatureBCFour2"
                                    fontSize: 0
                                    unit: "°C"
                                    max: 300
                                    alert: true
                                }

                                Label {
                                    font.pixelSize: 22 * Constants.scaleFactor
                                    font.bold: true
                                    color: appTheme.bodyText
                                    OpcUaMonitoredNode {
                                        monitored: root.visible
                                        nodeId: "Arp.Plc.Eclr/temperatureBCFour2"
                                        onValueChanged: parent.text = value.toFixed(1) + "°C"
                                    }
                                }

                                Label {
                                    text: qsTr(" T° BC")
                                    font.pixelSize: 22 * Constants.scaleFactor
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    color: appTheme.bodyText
                                }

                            }

                            RowLayout {
                                spacing: Constants.dp(5)

                                GaugeProgress {
                                    id: gaugeTempINFour2
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.preferredHeight: gaugeTempBCFour1.height
                                    Layout.preferredWidth: height
                                    nodeId: "Arp.Plc.Eclr/pt100_IN_Four2" // pt100_IN_Four1 ne marche pas
                                    offset: 0.1
                                    fontSize: 0
                                    unit: "°C"
                                    max: 300
                                    alert: true
                                }

                                Label {
                                    font.pixelSize: 22 * Constants.scaleFactor
                                    font.bold: true
                                    color: appTheme.bodyText
                                    OpcUaMonitoredNode {
                                        monitored: root.visible
                                        nodeId: "Arp.Plc.Eclr/pt100_IN_Four2"
                                        onValueChanged: parent.text = (value * gaugeTempINFour2.offset).toFixed(1) + "°C"
                                    }
                                }

                                Label {
                                    text: qsTr(" T° Entrée")
                                    font.pixelSize: 22 * Constants.scaleFactor
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    color: appTheme.bodyText
                                }

                            }

                            RowLayout {
                                spacing: Constants.dp(5)

                                GaugeProgress {
                                    id: gaugeTempOUTFour2
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.preferredHeight: gaugeTempBCFour1.height
                                    Layout.preferredWidth: height
                                    nodeId: "Arp.Plc.Eclr/pt100_OUT_Four2"
                                    offset: 0.1
                                    fontSize: 0
                                    unit: "°C"
                                    max: 300
                                    alert: true
                                }

                                Label {
                                    font.pixelSize: 22 * Constants.scaleFactor
                                    font.bold: true
                                    color: appTheme.bodyText
                                    OpcUaMonitoredNode {
                                        monitored: root.visible
                                        nodeId: "Arp.Plc.Eclr/pt100_OUT_Four2"
                                        onValueChanged: parent.text = (value * gaugeTempINFour2.offset).toFixed(1) + "°C"
                                    }
                                }

                                Label {
                                    text: qsTr(" T° Sortie")
                                    font.pixelSize: 22 * Constants.scaleFactor
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    color: appTheme.bodyText
                                }

                            }
                        }
                    }

                    GridLayout {
                        id: gridManuelFour2
                        rowSpacing: Constants.spacing * 1.5
                        columnSpacing: Constants.spacing
                        columns: 2
                        Layout.alignment: Qt.AlignHCenter | Qt.alignVCenter
                        visible: manualModeButton.checked

                        Label {
                            text: qsTr("Vérin rouleau four 2")
                            font.pixelSize: 22 * Constants.scaleFactor
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: appTheme.bodyText
                        }
                        CustomSwitch {
                            id: switchVerinRouleauFour2
                            text: qsTr("")
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            Layout.preferredHeight: 50 * Constants.scaleFactor
                            Layout.preferredWidth: 100 * Constants.scaleFactor
                            nodeId: "Arp.Plc.Eclr/manuelRouleauPresseurFour2"
                        }

                        Label {
                            text: qsTr("Tapis 2")
                            font.pixelSize: 22 * Constants.scaleFactor
                            color: appTheme.bodyText
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                        }

                        TapisSwitch {
                            id: sliderTapis2
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            Layout.preferredHeight: 50 * Constants.scaleFactor
                            Layout.preferredWidth: switchVerinRouleauFour2.width * 1.5
                            locked: true
                            nodeIdForward: "Arp.Plc.Eclr/startManuTapisFour2"
                            nodeIdBackward: "Arp.Plc.Eclr/reverseManuelTapisFour2"
                        }

                        Label {
                            text: qsTr("Dépose fil 2")
                            font.pixelSize: 22 * Constants.scaleFactor
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: appTheme.bodyText
                        }

                        CustomSwitch {
                            id: switchCoiler2
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            Layout.preferredHeight: 50 * Constants.scaleFactor
                            Layout.preferredWidth: 100 * Constants.scaleFactor
                            nodeId: "Arp.Plc.Eclr/startManuDeposeFilsFour2"

                        }

                        Label {
                            text: qsTr("Rouleau four 2")
                            font.pixelSize: 22 * Constants.scaleFactor
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: appTheme.bodyText
                        }
                        CustomSwitch {
                            id: switchMoteurFour2
                            text: qsTr("")
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            Layout.preferredHeight: 50 * Constants.scaleFactor
                            Layout.preferredWidth: 100 * Constants.scaleFactor
                            nodeId: "Arp.Plc.Eclr/startManuRouleauFour2"
                        }
                    }


                }
            }
        }


    }

    Rectangle {
        id: manualAvertissement
        visible: manualModeButton.checked
        width: parent.width
        height: Constants.dp(30)
        color: "#deae2a"
        y: parent.height - height - 20

        Label {
            anchors.centerIn: parent
            text: qsTr("Mode Manuel Actif...")
            font.pixelSize: Constants.sp(18)
        }
    }

    Item {
        id: cognexPage
        anchors.fill: parent
        visible: false

        property bool pageLoaded: stackLayoutPage.currentIndex === 3

        onPageLoadedChanged: if (visible) {
                                 visible = false
                                 columnlayout.visible = true
                                 cognexLoader.source = ""
                             }

        ColumnLayout {
            anchors.fill: parent

            ModuleButton {
                id: closeCognexBtn
                Layout.preferredHeight: Constants.dp(40)
                Layout.preferredWidth: Constants.dp(100)
                labelText: "Fermer"
                Layout.alignment: Qt.AlignRight

                onClicked: {
                    columnlayout.visible = true
                    cognexPage.visible = false
                    cognexLoader.source = ""
                }
            }

            Loader {
                id: cognexLoader
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
        }
    }
}
