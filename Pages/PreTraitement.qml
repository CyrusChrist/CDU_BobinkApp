import QtQuick
import QtQuick.Controls
import Bobink
import QtQuick.Layouts
import "../Resources/Components"
import "../"

Item {

    id: root

    property alias manuelPreTraitementButton: manuelPreTraitementButton
    property alias switchAspirationPlasma: switchAspirationPlasma

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40 * Constants.scaleFactor
        spacing: 40 * Constants.scaleFactor

        RowLayout {
            Layout.fillWidth: true
            spacing: Constants.dp(15)

            Text {
                Layout.fillWidth: true

                text: qsTr("Pré-traitement")
                font.pixelSize: Math.max(35, parent.width * 0.037)
                font.bold: true
                color: appTheme.bodyText
            }

            Item { Layout.fillWidth: true }

            ManuelSwitch {
                id: manuelPreTraitementButton
            }

            // StatusIndicatorTricolor {
            //     id: iRGlobalStatus
            //     Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            //     Layout.preferredWidth: Constants.dp(45)
            //     Layout.preferredHeight: width
            //     nodeIdRed: "Arp.Plc.Eclr/tricolorRougePreTraitement"
            //     nodeIdYellow: "Arp.Plc.Eclr/tricolorOrangePreTraitement"
            //     nodeIdGreen: "Arp.Plc.Eclr/tricolorVertPreTraitement"
            // }
        }

        GridLayout {
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            columnSpacing: Constants.dp(25)
            rowSpacing: Constants.dp(5)

            StyledFrame {
                id: plasmaFrameBtn
                style: "shadowed"
                Layout.preferredHeight: Constants.dp(110)
                Layout.preferredWidth: Constants.dp(350)
                padding: 0
                Layout.row: 1
                Layout.column: 1
                Layout.alignment: Qt.AlignTop

                shadowColor: manuelPreTraitementButton.checked ? "#deae2a" : checkboxPlasma.checked ? "#35a646" : "black"

                Label {
                    text: "Plasma"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.centerIn: parent
                    font.bold: true
                    font.pixelSize: Constants.sp(30)
                    color: appTheme.bodyText
                }

                Rectangle {
                    id: checkboxPlasma
                    property bool checked: false

                    width: Constants.dp(25)
                    height: width
                    x: parent.width - width - Constants.dp(20)
                    y: Constants.dp(20)
                    radius: height/2
                    color: manuelPreTraitementButton.checked ? "#deae2a" : checked ? "#35a646" : "transparent"
                    border.width: 1
                    border.color: (checked || manuelPreTraitementButton.checked) ? "transparent" : appTheme.bodyText

                    Image {
                        anchors.centerIn: parent
                        width: parent.height * 0.6
                        height: width
                        visible: checkboxPlasma.checked && !manuelPreTraitementButton.checked
                        source: "../Resources/Images/Check.svg"
                        fillMode: Image.PreserveAspectFit
                    }

                    Rectangle {
                        anchors.centerIn: parent
                        width: parent.height * 0.55
                        radius: 0.5
                        height: 3
                        color: "white"
                        visible: manuelPreTraitementButton.checked
                    }

                }

                MouseArea {
                    anchors.fill: parent
                    visible: !manuelPreTraitementButton.checked
                    onClicked: {
                        checkboxPlasma.checked = !checkboxPlasma.checked
                        opcuaNodePlasma.setValue(checkboxPlasma.checked)
                    }

                    OpcUaMonitoredNode {
                        monitored: root.visible
                        id: opcuaNodePlasma
                        nodeId: "Arp.Plc.Eclr/plasmaEnable"
                        onValueChanged: checkboxPlasma.checked = value
                    }
                }

            }

            StyledFrame {
                id: sprayingFrameBtn
                style: "shadowed"
                Layout.preferredHeight: plasmaFrameBtn.height
                Layout.preferredWidth: plasmaFrameBtn.width
                padding: 0
                Layout.row: 1
                Layout.column: 2
                Layout.alignment: Qt.AlignTop

               shadowColor: manuelPreTraitementButton.checked ? "#deae2a" : checkboxSpraying.checked ? "#35a646" : "black"

                Label {
                    text: "Spraying"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.centerIn: parent
                    font.bold: true
                    font.pixelSize: Constants.sp(30)
                    color: appTheme.bodyText
                }

                Rectangle {
                    id: checkboxSpraying
                    property bool checked: false

                    width: Constants.dp(25)
                    height: width
                    x: parent.width - width - Constants.dp(20)
                    y: Constants.dp(20)
                    radius: height/2
                    color: manuelPreTraitementButton.checked ? "#deae2a" : checked ? "#35a646" : "transparent"
                    border.width: 1
                    border.color: (checked || manuelPreTraitementButton.checked) ? "transparent" : appTheme.bodyText

                    Image {
                        anchors.centerIn: parent
                        width: parent.height * 0.6
                        height: width
                        visible: checkboxSpraying.checked && !manuelPreTraitementButton.checked
                        source: "../Resources/Images/Check.svg"
                        fillMode: Image.PreserveAspectFit
                    }

                    Rectangle {
                        anchors.centerIn: parent
                        width: parent.height * 0.55
                        radius: 0.5
                        height: 3
                        color: "white"
                        visible: manuelPreTraitementButton.checked
                    }

                }

                MouseArea {
                    anchors.fill: parent
                    visible: !manuelPreTraitementButton.checked
                    onClicked: {
                        checkboxSpraying.checked = !checkboxSpraying.checked
                        opcuaNodeSpraying.setValue(checkboxSpraying.checked)
                    }

                    OpcUaMonitoredNode {
                        monitored: root.visible
                        id: opcuaNodeSpraying
                        nodeId: "Arp.Plc.Eclr/pompePreTraitementEnable"
                        onValueChanged: checkboxSpraying.checked = value
                    }
                }

            }

            StyledFrame {
                id: soufflerieFrameBtn
                style: "shadowed"
                Layout.preferredWidth: plasmaFrameBtn.width
                padding: Constants.dp(15)
                Layout.row: 1
                Layout.column: 3
                Layout.rowSpan: 3

                shadowColor: manuelPreTraitementButton.checked ? "#deae2a" : "black"

                ColumnLayout {
                    spacing: Constants.dp(15)
                    width: parent.width

                    Label {
                        text: "Soufflerie"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        Layout.alignment: Qt.AlignHCenter
                        font.bold: true
                        font.pixelSize: Constants.sp(30)
                        color: appTheme.bodyText
                    }

                    RowLayout {
                        Layout.fillWidth: true

                        Label {
                            text: qsTr("Dépoussièrage")
                            horizontalAlignment: Text.AlignLeft
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            color: appTheme.bodyText
                            font.pixelSize: Constants.sp(18)
                        }

                        Item {Layout.fillWidth: true}

                        CustomCheckbox {
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            Layout.preferredWidth: implicitWidth * 1.33 * Constants.scaleFactor
                            Layout.preferredHeight: implicitHeight * 1.33 * Constants.scaleFactor
                            nodeId: ""
                            enabled: false
                            visible: !manuelPreTraitementButton.checked
                        }

                        CustomSwitch {
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            disactivated: true
                            visible: manuelPreTraitementButton.checked
                            enabled: false
                            nodeId: ""
                            Layout.preferredWidth: implicitWidth * 1.2 * Constants.scaleFactor
                            Layout.preferredHeight: implicitHeight * 1.2 * Constants.scaleFactor
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true

                        Label {
                            text: qsTr("Dépoussièrage plasma")
                            horizontalAlignment: Text.AlignLeft
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            color: appTheme.bodyText
                            font.pixelSize: Constants.sp(18)
                        }

                        Item {Layout.fillWidth: true}

                        CustomSwitch {
                            id: switchAspirationPlasma
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            nodeId: "Arp.Plc.Eclr/enableAspirationFranceAir"
                            Layout.preferredWidth: implicitWidth * 1.2 * Constants.scaleFactor
                            Layout.preferredHeight: implicitHeight * 1.2 * Constants.scaleFactor
                            visible: manuelPreTraitementButton.checked
                        }

                        CustomCheckbox {
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            Layout.preferredWidth: implicitWidth * 1.33 * Constants.scaleFactor
                            Layout.preferredHeight: implicitHeight * 1.33 * Constants.scaleFactor
                            nodeId: "Arp.Plc.Eclr/enableAspirationFranceAir"
                            visible: !manuelPreTraitementButton.checked
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true

                        Label {
                            text: qsTr("Purge")
                            horizontalAlignment: Text.AlignLeft
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            color: appTheme.bodyText
                            font.pixelSize: Constants.sp(20)
                            font.bold: true
                        }

                        Item {Layout.fillWidth: true}

                        CustomCheckbox {
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            Layout.preferredWidth: implicitWidth * 1.33 * Constants.scaleFactor
                            Layout.preferredHeight: implicitHeight * 1.33 * Constants.scaleFactor
                            nodeId: "Arp.Plc.Eclr/enablePurgeAnneauxDePouyesPreTraitement"
                            visible: !manuelPreTraitementButton.checked
                        }

                        CustomSwitch {
                            id: manuelSoufflerie
                            visible: manuelPreTraitementButton.checked
                            enabled: false
                            disactivated: true
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            nodeId: ""
                            Layout.preferredWidth: implicitWidth * 1.2 * Constants.scaleFactor
                            Layout.preferredHeight: implicitHeight * 1.2 * Constants.scaleFactor
                        }

                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        spacing: Constants.dp(15)
                        Layout.fillWidth: true
                        Label {
                            text: qsTr("Durée")
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            color: appTheme.bodyText
                            horizontalAlignment: Text.AlignLeft
                            font.pixelSize: Constants.sp(18)
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        NumericInput {
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            unit: qsTr("ms")
                            min: 50
                            max: 100000
                            nodeId: "Arp.Plc.Eclr/dureePurgeAnneauxDePouyesPreTraitement"
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        spacing: Constants.dp(15)
                        Label {
                            text: qsTr("Fréquence")
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            color: appTheme.bodyText
                            horizontalAlignment: Text.AlignLeft
                            font.pixelSize: Constants.sp(18)
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        NumericInput {
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            unit: qsTr("s")
                            min: 0.1
                            max: 3600
                            nodeId: "Arp.Plc.Eclr/frequencePurgeAnneauxDePouyesPreTraitement"
                            offset: 0.001
                        }
                    }

                    ColumnLayout {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        spacing: Constants.dp(10)

                        Label {
                            text: qsTr("Temps d'utilisation du sac à poussière")
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            color: appTheme.bodyText
                            font.pixelSize: Constants.sp(18)
                        }

                        RowLayout {
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            spacing: Constants.dp(15)

                            NumericInput {
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.preferredWidth: Constants.dp(125)
                                leftPadding: Constants.dp(10)
                                unit: ""
                                min: 0
                                max: 10000
                                readOnly: true
                                nodeId: ""
                                nodeIdReset: "hjkl"
                            }

                            Label {
                                text: qsTr("/ 15h")
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                color: appTheme.bodyText
                                font.pixelSize: Constants.sp(18)
                            }
                        }
                    }

                }
            }

            StyledFrame {
                id: plasmaDetails
                style: "thin"
                Layout.preferredWidth: plasmaFrameBtn.width
                padding: Constants.dp(20)
                Layout.row: 2
                Layout.column: 1
                visible: checkboxPlasma.checked || manuelPreTraitementButton.checked
                Layout.alignment: Qt.AlignTop

                ColumnLayout {
                    spacing: Constants.dp(10)
                    width: parent.width

                    RowLayout {
                        Layout.fillWidth: true
                        visible: manuelPreTraitementButton.checked

                        Label {
                            text: qsTr("Plasma")
                            horizontalAlignment: Text.AlignLeft
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            color: appTheme.bodyText
                            font.pixelSize: Constants.sp(18)
                        }

                        Item {Layout.fillWidth: true}

                        CustomSwitch {
                            id: manuelPlasma
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            nodeId: "Arp.Plc.Eclr/startManuPlasmaPreTraitement"
                            Layout.preferredWidth: implicitWidth * 1.2 * Constants.scaleFactor
                            Layout.preferredHeight: implicitHeight * 1.2 * Constants.scaleFactor
                        }

                    }

                    Label {
                        text: qsTr("Activation des buses")
                        color: appTheme.bodyText
                        font.pixelSize: Constants.sp(20)
                        font.bold: true
                        horizontalAlignment: Text.AlignLeft
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    }

                    Repeater {
                        id: repeaterPlasmaNozzle
                        model: listModelPlasmaNozzleSelection
                        delegate: RowLayout {
                            Layout.fillWidth: true
                            Label {
                                text: qsTr("Buse ") + number
                                color: appTheme.bodyText
                                font.pixelSize: Constants.sp(18)
                                horizontalAlignment: Text.AlignLeft
                                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            }

                            Item {
                                Layout.fillWidth: true
                            }

                            CustomCheckbox {
                                id: switchPlasmaNozzle
                                Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                                Layout.preferredWidth: implicitWidth * 1.33 * Constants.scaleFactor
                                Layout.preferredHeight: implicitHeight * 1.33 * Constants.scaleFactor
                                checked: !!value
                                onClicked: {
                                    console.log("Changing value buse : " + index + " to " + checked)
                                    opcuaNodePlasmaNozzle.setValueArray(index, checked)
                                }
                            }
                        }
                    }

                    // Label {
                    //     text: qsTr("Temps d'utilisation du filtre")
                    //     Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    //     color: appTheme.bodyText
                    //     font.pixelSize: Constants.sp(18)
                    // }

                    // RowLayout {
                    //     Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    //     spacing: Constants.dp(15)

                    //     NumericInput {
                    //         horizontalAlignment: Text.AlignLeft
                    //         verticalAlignment: Text.AlignVCenter
                    //         Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    //         Layout.preferredWidth: Constants.dp(125)
                    //         leftPadding: Constants.dp(10)
                    //         unit: ""
                    //         min: 0
                    //         max: 10000
                    //         readOnly: true
                    //         nodeId: "Arp.Plc.Eclr/tempsStringFiltreAspirationPlasmaPreTraitement"
                    //         nodeIdReset: "Arp.Plc.Eclr/resetTempsAspirationPlasmaPreTraitement"
                    //     }

                    //     Label {
                    //         text: qsTr("/ 20h")
                    //         Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    //         color: appTheme.bodyText
                    //         font.pixelSize: Constants.sp(18)
                    //     }
                    // }

                }

            }

            StyledFrame {
                id: sprayingDetails
                style: "thin"
                Layout.preferredWidth: sprayingFrameBtn.width
                Layout.alignment: Qt.AlignTop
                padding: Constants.dp(20)
                Layout.row: 2
                Layout.column: 2
                visible: checkboxSpraying.checked || manuelPreTraitementButton.checked

                ColumnLayout {
                    spacing: Constants.dp(15)
                    width: parent.width

                    RowLayout {
                        Layout.fillWidth: true
                        visible: manuelPreTraitementButton.checked

                        Label {
                            text: qsTr("Spraying")
                            horizontalAlignment: Text.AlignLeft
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            color: appTheme.bodyText
                            font.pixelSize: Constants.sp(18)
                        }

                        Item {Layout.fillWidth: true}

                        CustomSwitch {
                            id: manuelSpraying
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            nodeId: "Arp.Plc.Eclr/startManuSprayingPreTraitement"
                            Layout.preferredWidth: implicitWidth * 1.2 * Constants.scaleFactor
                            Layout.preferredHeight: implicitHeight * 1.2 * Constants.scaleFactor
                        }

                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        spacing: Constants.dp(15)
                        Layout.fillWidth: true

                        Label {
                            text: qsTr("Recette")
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            color: appTheme.bodyText
                            font.pixelSize: Constants.sp(18)
                        }

                        Item { Layout.fillWidth: true }

                        ComboBox {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                            model: [qsTr("Cotton"), qsTr("Synthetic"), qsTr("Yarn")]
                        }
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        spacing: Constants.dp(15)
                        Layout.fillWidth: true

                        Label {
                            text: qsTr("Puissance")
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            color: appTheme.bodyText
                            horizontalAlignment: Text.AlignLeft
                            font.pixelSize: Constants.sp(18)
                        }

                        Item { Layout.fillWidth: true }

                        NumericInput {
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            unit: "%"
                            min: 15
                            max: 100
                            nodeId: "Arp.Plc.Eclr/consignePompePreTraitement"
                        }
                    }

                    ColumnLayout {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        spacing: Constants.dp(10)
                        Label {
                            text: qsTr("Temps d'utilisation du filtre")
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            color: appTheme.bodyText
                            font.pixelSize: Constants.sp(18)
                        }
                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            spacing: Constants.dp(15)

                            NumericInput {
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.preferredWidth: Constants.dp(125)
                                leftPadding: Constants.dp(10)
                                unit: ""
                                min: 0
                                max: 10000
                                readOnly: true
                                nodeId: "Arp.Plc.Eclr/tempsStringFiltrePreTraitement"
                                nodeIdReset: "Arp.Plc.Eclr/resetFiltrePreTraitement"
                            }

                            Label {
                                text: qsTr("/ 4h")
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                color: appTheme.bodyText
                                font.pixelSize: Constants.sp(18)
                            }
                        }
                    }


                }
            }


        }


    }

    Rectangle {
        id: manualAvertissement
        visible: manuelPreTraitementButton.checked
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

    OpcUaMonitoredNode {
        monitored: root.visible
        id: opcuaNodePlasmaNozzle
        nodeId: "Arp.Plc.Eclr/busesPlasmaPreTraitement"
        onValueChanged: {
            for(var i = 0 ; i < listModelPlasmaNozzleSelection.count ; i++ ){
                listModelPlasmaNozzleSelection.setProperty(i,"value",value[i])
            }
        }
    }
    ListModel{
        id: listModelPlasmaNozzleSelection
        ListElement{
            number: 1
            value: false
        }
        ListElement{
            number: 2
            value: false
        }
        ListElement{
            number: 3
            value: false
        }
        ListElement{
            number: 4
            value: false
        }
    }

}
