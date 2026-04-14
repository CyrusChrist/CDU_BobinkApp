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

    property int emIndex: 2
    property int cmInactiveMask: Constants.cmInactiveMasks[emIndex]

    function toggleCM(emIndex, cmIndex) {
        var currentMask = Constants.cmInactiveMasks[emIndex]
        var newMask
        var isEnabled = (currentMask & (1 << cmIndex)) === 0
        if (isEnabled) {
            newMask = currentMask | (1 << cmIndex)
        } else {
            newMask = currentMask & ~(1 << cmIndex)
        }
        opcuaNodeInactiveMasks.writeValue(Number(newMask))
        var newMasks = Constants.cmInactiveMasks.slice()
        newMasks[emIndex] = newMask
        Constants.cmInactiveMasks = newMasks
    }

    OpcUaMonitoredNode {
        id: opcuaNodeInactiveMasks
        monitored: rootApp.visible

        nodeId: "ns=6;s=Arp.Plc.Eclr/UN00_Modules.EM[" + root.emIndex + "].CM_InactiveMask"
        onValueChanged: {
            if (value !== undefined) {
                var newMasks = Constants.cmInactiveMasks.slice()
                newMasks[emIndex] = value
                Constants.cmInactiveMasks = newMasks
            }
        }
        onWriteCompleted: (success, message, writtenValue) => {
                              console.log(nodeId + ": " + message);
                          }
    }

    onCmInactiveMaskChanged: {
        // update status for PLASMA : cmIndex = 0
        if ((root.cmInactiveMask & (1 << 0)) === 0) {
            checkboxPlasma.checked = true
        } else {
            checkboxPlasma.checked = false
        }

        // update status for SPRAYING : cmIndex = 1
        if ((root.cmInactiveMask & (1 << 1)) === 0) {
            checkboxSpraying.checked = true
        } else {
            checkboxSpraying.checked = false
        }

        // update status for PURGE SOUFFLERIE : cmIndex = 2
        if ((root.cmInactiveMask & (1 << 2)) === 0) {
            purgeCheckbox.checked = true
        } else {
            purgeCheckbox.checked = false
        }
    }

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

                MouseArea {
                    anchors.fill: parent

                    onClicked: home.onPlayPauseChecked(home.manualModeButton)
                }

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
                        sourceSize: Qt.size(width, height)
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
                        toggleCM(root.emIndex, 0)
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
                        sourceSize: Qt.size(width, height)
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
                        toggleCM(root.emIndex, 1)
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
                Layout.alignment: Qt.AlignTop

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
                            enabled: false
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
                            id: purgeCheckbox
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            Layout.preferredWidth: implicitWidth * 1.33 * Constants.scaleFactor
                            Layout.preferredHeight: implicitHeight * 1.33 * Constants.scaleFactor
                            visible: !manuelPreTraitementButton.checked

                            onClicked: {
                                toggleCM(root.emIndex, 2)
                            }
                        }

                        CustomSwitch {
                            id: manuelSoufflerie
                            visible: manuelPreTraitementButton.checked
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            nodeId: ""
                            Layout.preferredWidth: implicitWidth * 1.2 * Constants.scaleFactor
                            Layout.preferredHeight: implicitHeight * 1.2 * Constants.scaleFactor

                            onClicked: {
                                toggleCM(root.emIndex, 2)
                            }
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
                            nodeId: "ns=6;s=Arp.Plc.Eclr/purgeAirComprimePreTraitement.Duree"
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
                            nodeId: "ns=6;s=Arp.Plc.Eclr/purgeAirComprimePreTraitement.Frequence"
                            offset: 0.001
                        }
                    }

                    ColumnLayout {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        spacing: Constants.dp(10)
                        visible: false

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

                            onCheckedChanged: {
                                toggleCM(root.emIndex, 0)
                            }
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
                                checked: listModelPlasmaNozzleSelection.get(index).value

                                MouseArea {
                                    anchors.fill: parent
                                    property bool checked: parent.checked
                                    onClicked: {
                                        plasmaSelector(!checked)
                                    }
                                }
                            }

                            function plasmaSelector(value) {
                                if (!value) {
                                    let n = 0
                                    for (var i=0; i < listModelPlasmaNozzleSelection.count; i++) {
                                        if (listModelPlasmaNozzleSelection.get(i).value) {
                                            n++
                                        }
                                    }
                                    if (n <= 2) {
                                        notificationPopup.text = "Minimum 2 buses plasma"
                                        notificationPopup.subText = ""
                                        notificationPopup.importance = 2
                                        notificationPopup.warningColor = "#555"
                                        notificationPopup.open()
                                    } else {
                                        listModelPlasmaNozzleSelection.setProperty(index,"value",value)
                                        opcuaNodePlasmaNozzle.writeValue(value)
                                    }
                                } else {
                                    listModelPlasmaNozzleSelection.setProperty(index,"value",value)
                                    opcuaNodePlasmaNozzle.writeValue(value)
                                }
                            }

                            OpcUaMonitoredNode {
                                monitored: root.visible
                                id: opcuaNodePlasmaNozzle
                                nodeId: model.nodeId
                                onValueChanged: {
                                    listModelPlasmaNozzleSelection.setProperty(index,"value",value)
                                }
                            }
                        }
                    }

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
                            Layout.preferredWidth: implicitWidth * 1.2 * Constants.scaleFactor
                            Layout.preferredHeight: implicitHeight * 1.2 * Constants.scaleFactor

                            onCheckedChanged: {
                                toggleCM(root.emIndex, 1)
                            }


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
                            nodeId: "ns=6;s=Arp.Plc.Eclr/pompePreTraitement.Cmd.Pct"
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
                                unit: "s"
                                min: 0
                                max: 10000
                                offset: 0.001
                                readOnly: true
                                nodeId: "ns=6;s=Arp.Plc.Eclr/pompePreTraitement.Filtre.UsingTime"
                                nodeIdReset: "ns=6;s=Arp.Plc.Eclr/pompePreTraitement.Filtre.RaZ"
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


    ListModel{
        id: listModelPlasmaNozzleSelection
        ListElement{
            number: 1
            value: false
            nodeId: "ns=6;s=Arp.Plc.Eclr/plasma.Buses[1].Enable"
        }
        ListElement{
            number: 2
            value: false
            nodeId: "ns=6;s=Arp.Plc.Eclr/plasma.Buses[2].Enable"
        }
        ListElement{
            number: 3
            value: false
            nodeId: "ns=6;s=Arp.Plc.Eclr/plasma.Buses[3].Enable"
        }
        ListElement{
            number: 4
            value: false
            nodeId: "ns=6;s=Arp.Plc.Eclr/plasma.Buses[4].Enable"
        }
    }

}
