import QtQuick
import QtQuick.Controls
import Bobink
import QtQuick.Layouts
import QtQuick.Effects
import "../"
import "../Resources/Components"


Item {
    id: root

    property alias manuelIRButton: manuelIRButton

    QtObject {
        id: internal

        property int selectedEM: -1
        property int selectedCM: -1

        // Masques d'inactivité (pour configuration)
        property int emInactiveMask: 0xFFFF
        property var cmInactiveMasks: [
            0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF,
            0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF,
            0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF,
            0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF
        ]

        // Status actifs (lecture depuis PLC)
        property int emsActive: 0x0000
        property var cmsActive: [
            0x0000, 0x0000, 0x0000, 0x0000,
            0x0000, 0x0000, 0x0000, 0x0000,
            0x0000, 0x0000, 0x0000, 0x0000,
            0x0000, 0x0000, 0x0000, 0x0000
        ]

        // Status NotDone (lecture depuis PLC)
        property int emsNotDone: 0x0000
        property var cmsNotDone: [
            0x0000, 0x0000, 0x0000, 0x0000,
            0x0000, 0x0000, 0x0000, 0x0000,
            0x0000, 0x0000, 0x0000, 0x0000,
            0x0000, 0x0000, 0x0000, 0x0000
        ]
    }

    function toggleCM(emIndex, cmIndex) {
        var currentMask = internal.cmInactiveMasks[emIndex]
        var newMask
        var isEnabled = (currentMask & (1 << cmIndex)) === 0
        if (isEnabled) {
            newMask = currentMask | (1 << cmIndex)
        } else {
            newMask = currentMask & ~(1 << cmIndex)
        }
        opcuaNodeChauffeIRs.writeValue(Number(newMask))
        var newMasks = internal.cmInactiveMasks.slice()
        newMasks[emIndex] = newMask
        internal.cmInactiveMasks = newMasks
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

                text: qsTr("Fours IR")
                font.pixelSize: Math.max(35, parent.width * 0.037)
                font.bold: true
                color: appTheme.bodyText
            }

            Item { Layout.fillWidth: true }

            ManuelSwitch {
                id: manuelIRButton
            }

            // StatusIndicatorTricolor {
            //     id: iRGlobalStatus
            //     Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            //     Layout.preferredWidth: Constants.dp(45)
            //     Layout.preferredHeight: width
            //     nodeIdRed: "Arp.Plc.Eclr/tricolorRougeFourIR"
            //     nodeIdYellow: "Arp.Plc.Eclr/tricolorOrangeFourIR"
            //     nodeIdGreen: "Arp.Plc.Eclr/tricolorVertFourIR"
            // }

        }

        GridLayout {
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            columnSpacing: Constants.dp(25)
            rowSpacing: Constants.dp(5)

            StyledFrame {
                id: chauffeIRFrameBtn
                style: "shadowed"
                Layout.preferredHeight: Constants.dp(110)
                Layout.preferredWidth: Constants.dp(350)
                padding: 0
                Layout.row: 1
                Layout.column: 1

                shadowColor: manuelIRButton.checked ? "#deae2a" : checkboxChauffeIR.checked ? "#35a646" : "black"

                Label {
                    text: "Chauffe"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.centerIn: parent
                    font.bold: true
                    font.pixelSize: Constants.sp(30)
                    color: appTheme.bodyText
                }

                Rectangle {
                    id: checkboxChauffeIR
                    property bool checked: false

                    width: Constants.dp(25)
                    height: width
                    x: parent.width - width - Constants.dp(20)
                    y: Constants.dp(20)
                    radius: height/2
                    color: manuelIRButton.checked ? "#deae2a" : checked ? "#35a646" : "transparent"
                    border.width: 1
                    border.color: (checked || manuelIRButton.checked) ? "transparent" : appTheme.bodyText

                    Image {
                        anchors.centerIn: parent
                        width: parent.height * 0.6
                        height: width
                        visible: checkboxChauffeIR.checked && !manuelIRButton.checked
                        source: "../Resources/Images/Check.svg"
                        fillMode: Image.PreserveAspectFit
                    }

                    Rectangle {
                        anchors.centerIn: parent
                        width: parent.height * 0.55
                        radius: 0.5
                        height: 3
                        color: "white"
                        visible: manuelIRButton.checked
                    }

                }

                MouseArea {
                    anchors.fill: parent
                    visible: !manuelIRButton.checked
                    onClicked: {
                        checkboxChauffeIR.checked = !checkboxChauffeIR.checked
                        // opcuaNodeChauffeIRs.writeValue(checkboxChauffeIR.checked)
                        toggleCM(4, 6)
                    }

                    OpcUaMonitoredNode {
                        id: opcuaNodeChauffeIRs
                        monitored: root.visible
                        nodeId: "ns=6;s=Arp.Plc.Eclr/UN00_Modules.EM[4].CM_InactiveMask"
                        onValueChanged: {
                            // checkboxChauffeIR.checked = value
                            if (value !== undefined) {
                                var newMasks = internal.cmInactiveMasks.slice()
                                newMasks[4] = value
                                internal.cmInactiveMasks = newMasks
                            }
                        }
                        onWriteCompleted: (success, message) => {
                            console.log(nodeId + ": " + message);
                        }
                    }
                }

            }

            StyledFrame {
                id: capteurFrameBtn
                style: "shadowed"
                Layout.preferredHeight: Constants.dp(110)
                Layout.preferredWidth: Constants.dp(350)
                padding: 0
                Layout.row: 1
                Layout.column: 2

                shadowColor: manuelIRButton.checked ? "#deae2a" : checkboxCapteur.checked ? "#35a646" : "black"

                Label {
                    text: "Asservissement\nCapteur"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.centerIn: parent
                    font.bold: true
                    font.pixelSize: Constants.sp(30)
                    color: appTheme.bodyText
                }

                Rectangle {
                    id: checkboxCapteur
                    property bool checked: false

                    width: Constants.dp(25)
                    height: width
                    x: parent.width - width - Constants.dp(20)
                    y: Constants.dp(20)
                    radius: height/2
                    color: manuelIRButton.checked ? "#deae2a" : checked ? "#35a646" : "transparent"
                    border.width: 1
                    border.color: (checked || manuelIRButton.checked) ? "transparent" : appTheme.bodyText

                    Image {
                        anchors.centerIn: parent
                        width: parent.height * 0.6
                        height: width
                        visible: checkboxCapteur.checked && !manuelIRButton.checked
                        source: "../Resources/Images/Check.svg"
                        fillMode: Image.PreserveAspectFit
                    }

                    Rectangle {
                        anchors.centerIn: parent
                        width: parent.height * 0.55
                        radius: 0.5
                        height: 3
                        color: "white"
                        visible: manuelIRButton.checked
                    }

                }

                MouseArea {
                    anchors.fill: parent
                    visible: !manuelIRButton.checked
                    onClicked: {
                        checkboxCapteur.checked = !checkboxCapteur.checked
                        opcuaNodeAsservissementCapteur.setValue(checkboxCapteur.checked)
                    }

                    OpcUaMonitoredNode {
                        monitored: root.visible
                        id: opcuaNodeAsservissementCapteur
                        nodeId: "Arp.Plc.Eclr/enableAsservissementFoursIR"
                        onValueChanged: {
                            checkboxCapteur.checked = value
                        }
                    }
                }

            }

            StyledFrame {
                id: prealFrameBtn
                style: "shadowed"
                Layout.preferredHeight: Constants.dp(110)
                Layout.preferredWidth: Constants.dp(350)
                padding: 0
                Layout.row: 1
                Layout.column: 3

                shadowColor: manuelIRButton.checked ? "#deae2a" : checkboxPreal.checked ? "#35a646" : "black"

                Label {
                    text: "Pré-Alimenteur"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.centerIn: parent
                    font.bold: true
                    font.pixelSize: Constants.sp(30)
                    color: appTheme.bodyText
                }

                Rectangle {
                    id: checkboxPreal
                    property bool checked: false

                    width: Constants.dp(25)
                    height: width
                    x: parent.width - width - Constants.dp(20)
                    y: Constants.dp(20)
                    radius: height/2
                    color: manuelIRButton.checked ? "#deae2a" : checked ? "#35a646" : "transparent"
                    border.width: 1
                    border.color: (checked || manuelIRButton.checked) ? "transparent" : appTheme.bodyText

                    Image {
                        anchors.centerIn: parent
                        width: parent.height * 0.6
                        height: width
                        visible: checkboxPreal.checked && !manuelIRButton.checked
                        source: "../Resources/Images/Check.svg"
                        fillMode: Image.PreserveAspectFit
                    }

                    Rectangle {
                        anchors.centerIn: parent
                        width: parent.height * 0.55
                        radius: 0.5
                        height: 3
                        color: "white"
                        visible: manuelIRButton.checked
                    }

                }

                MouseArea {
                    anchors.fill: parent
                    visible: !manuelIRButton.checked
                    onClicked: {
                        checkboxPreal.checked = !checkboxPreal.checked
                        opcuaNodePreal.setValue(checkboxPreal.checked)
                    }

                    OpcUaMonitoredNode {
                        monitored: root.visible
                        id: opcuaNodePreal
                        nodeId: "Arp.Plc.Eclr/chauffeIRsAutomatiqueEnable"
                        onValueChanged: {
                            checkboxPreal.checked = value
                        }
                    }
                }

            }

            StyledFrame {
                id: chauffeIRDetails
                style: "thin"
                Layout.preferredWidth: chauffeIRFrameBtn.width
                padding: Constants.dp(20)
                Layout.row: 2
                Layout.column: 1
                visible: checkboxChauffeIR.checked || manuelIRButton.checked
                Layout.alignment: Qt.AlignTop

                ColumnLayout {
                    spacing: Constants.dp(10)
                    width: parent.width

                    RowLayout {
                        Layout.fillWidth: true
                        visible: manuelIRButton.checked

                        Label {
                            text: qsTr("Chauffe IR")
                            horizontalAlignment: Text.AlignLeft
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            color: appTheme.bodyText
                            font.pixelSize: Constants.sp(18)
                        }

                        Item {Layout.fillWidth: true}

                        CustomSwitch {
                            id: manuelChauffeIR
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            nodeId: "Arp.Plc.Eclr/manuelChauffeIRs"
                            Layout.preferredWidth: implicitWidth * 1.2 * Constants.scaleFactor
                            Layout.preferredHeight: implicitHeight * 1.2 * Constants.scaleFactor
                        }

                    }

                    RowLayout {
                        Layout.fillWidth: true

                        Label {
                            text: qsTr("Température IR 1")
                            color: appTheme.bodyText
                            font.pixelSize: Constants.sp(18)
                            horizontalAlignment: Text.AlignLeft
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        }

                        Item { Layout.fillWidth: true }

                        NumericInput {
                            readOnly: true
                            horizontalAlignment: Text.AlignHCenter
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            unit: "°C"
                            min:0
                            max:0
                            nodeId: "Arp.Plc.Eclr/temperaturePT100_Four1IR"
                        }


                    }

                    RowLayout {
                        Layout.fillWidth: true

                        Label {
                            text: qsTr("Température IR 2")
                            color: appTheme.bodyText
                            font.pixelSize: Constants.sp(18)
                            horizontalAlignment: Text.AlignLeft
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        }

                        Item { Layout.fillWidth: true }

                        NumericInput {
                            readOnly: true
                            horizontalAlignment: Text.AlignHCenter
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            unit: "°C"
                            min:0
                            max:0
                            nodeId: "Arp.Plc.Eclr/temperaturePT100_Four2IR"
                        }


                    }

                    RowLayout {
                        Layout.fillWidth: true

                        Label {
                            text: qsTr("Sélection des barres")
                            color: appTheme.bodyText
                            font.pixelSize: Constants.sp(18)
                            horizontalAlignment: Text.AlignLeft
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        }

                        Item { Layout.fillWidth: true }

                        OptionButton {
                            id: iRDeep
                            Layout.preferredWidth: Constants.dp(35)
                            Layout.preferredHeight: width
                            onClicked: popupIRs.open()
                        }


                    }

                }

            }

            StyledFrame {
                id: capteurDetails
                style: "thin"
                Layout.preferredWidth: chauffeIRFrameBtn.width
                padding: Constants.dp(20)
                Layout.row: 2
                Layout.column: 2
                visible: checkboxCapteur.checked || manuelIRButton.checked
                Layout.alignment: Qt.AlignTop

                ColumnLayout {
                    spacing: Constants.dp(10)
                    width: parent.width

                    RowLayout {
                        Layout.fillWidth: true

                        Label {
                            text: qsTr("Consigne")
                            color: appTheme.bodyText
                            font.pixelSize: Constants.sp(18)
                            horizontalAlignment: Text.AlignLeft
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        }

                        Item { Layout.fillWidth: true }

                        NumericInput {
                            horizontalAlignment: Text.AlignHCenter
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            min:0
                            max: 10000
                            nodeId: "Arp.Plc.Eclr/consigneCapteurTensionManuelRouleauFourIR"
                        }


                    }

                    RowLayout {
                        Layout.fillWidth: true

                        Label {
                            text: qsTr("Erreur")
                            color: appTheme.bodyText
                            font.pixelSize: Constants.sp(18)
                            horizontalAlignment: Text.AlignLeft
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        }

                        Item { Layout.fillWidth: true }

                        NumericInput {
                            readOnly: true
                            horizontalAlignment: Text.AlignHCenter
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            min:0
                            max: 10000
                            nodeId: "Arp.Plc.Eclr/erreurAsservissementFoursIR"
                        }


                    }

                    ModuleButton {
                        Layout.alignment: Qt.AlignHCenter
                        labelText: "Calibrer"
                        Layout.preferredWidth: parent.width * 0.35
                        Layout.preferredHeight: Constants.dp(40)
                        maxFontSize: width * 0.15
                        nodeId: "Arp.Plc.Eclr/capteurRouleauFourIR_CounterVal_Set"
                    }

                    RowLayout {
                        Layout.fillWidth: true

                        Label {
                            text: qsTr("Paramètres avancés")
                            color: appTheme.bodyText
                            font.pixelSize: Constants.sp(18)
                            horizontalAlignment: Text.AlignLeft
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        }

                        Item { Layout.fillWidth: true }

                        OptionButton {
                            Layout.preferredWidth: Constants.dp(35)
                            Layout.preferredHeight: width
                            onClicked: deepCapteurPopup.open()
                        }


                    }

                }

            }

            StyledFrame {
                id: prealDetails
                style: "thin"
                Layout.preferredWidth: chauffeIRFrameBtn.width
                padding: Constants.dp(20)
                Layout.row: 2
                Layout.column: 3
                visible: checkboxPreal.checked || manuelIRButton.checked
                Layout.alignment: Qt.AlignTop

                ColumnLayout {
                    spacing: Constants.dp(10)
                    width: parent.width

                    RowLayout {
                        Layout.fillWidth: true
                        visible: manuelIRButton.checked

                        Label {
                            text: qsTr("Pré-alimenteur")
                            horizontalAlignment: Text.AlignLeft
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            color: appTheme.bodyText
                            font.pixelSize: Constants.sp(18)
                        }

                        Item {Layout.fillWidth: true}

                        CustomSwitch {
                            id: manuelPreal
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            nodeId: "Arp.Plc.Eclr/"
                            Layout.preferredWidth: implicitWidth * 1.2 * Constants.scaleFactor
                            Layout.preferredHeight: implicitHeight * 1.2 * Constants.scaleFactor
                        }

                    }

                    RowLayout {
                        Layout.fillWidth: true

                        Label {
                            text: qsTr("Consigne")
                            color: appTheme.bodyText
                            font.pixelSize: Constants.sp(18)
                            horizontalAlignment: Text.AlignLeft
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        }

                        Item { Layout.fillWidth: true }

                        NumericInput {
                            horizontalAlignment: Text.AlignHCenter
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            unit: "‰"
                            min:0
                            max: 2000
                            nodeId: "Arp.Plc.Eclr/ratioPreAlImpressionFoursIR"
                        }
                    }

                }

            }

            StyledFrame {
                id: pneumatiqueDetail
                style: "shadowed"
                padding: Constants.dp(20)
                Layout.row: 3
                Layout.column: 3
                visible: manuelIRButton.checked
                Layout.alignment: Qt.AlignTop
                shadowColor: "#deae2a"

                ColumnLayout {
                    spacing: Constants.spacing * 3

                    Label {
                        text: qsTr("Autres options")
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        font.pixelSize: Constants.sp(30)
                        font.bold: true
                        color: appTheme.bodyText
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: Constants.dp(10)

                        StyledFrame {
                            style: "thin"
                            Layout.alignment: Qt.AlignHCenter
                            Layout.fillWidth: true

                            GridLayout {
                                // Layout.alignment: Qt.AlignHCenter
                                anchors.centerIn: parent
                                rowSpacing: 20 * Constants.scaleFactor
                                Layout.fillWidth: true
                                columnSpacing: 15 * Constants.scaleFactor
                                columns: 2

                                Label {
                                    text: qsTr("Remplir IR 1")
                                    color: appTheme.bodyText
                                    horizontalAlignment: Text.AlignHCenter
                                    Layout.alignment: Qt.AlignHCenter
                                    font.pixelSize: 20 * Constants.scaleFactor
                                }
                                CustomSwitch {
                                    id: switchA_RIR1
                                    Layout.preferredWidth: pneumatiqueDetail.width * 0.15
                                    Layout.preferredHeight: width / 2
                                    nodeId: "Arp.Plc.Eclr/manuelVerrins1FoursIR"
                                }

                                Label {
                                    text: qsTr("Remplir IR 2")
                                    color: appTheme.bodyText
                                    horizontalAlignment: Text.AlignHCenter
                                    Layout.alignment: Qt.AlignHCenter
                                    font.pixelSize: 20 * Constants.scaleFactor
                                }
                                CustomSwitch {
                                    id: switchA_RIR2
                                    Layout.preferredWidth: pneumatiqueDetail.width * 0.15
                                    Layout.preferredHeight: width / 2
                                    nodeId: "Arp.Plc.Eclr/manuelVerrins2FoursIR"
                                    // OPCUANode{
                                    //     nodeId:"Arp.Plc.Eclr/reverseManuelRouleauFour2"
                                    // }
                                    // enabled: manuelVerrinButton.checked ? true : false
                                }

                            }

                        }

                        Rectangle {
                            Layout.preferredHeight: parent.height
                            Layout.preferredWidth: 1 * Constants.scaleFactor
                            gradient: Gradient {

                                GradientStop {position: 0.0; color: appTheme.backgroundColor}
                                GradientStop {position: 0.25; color: appTheme.bodyText}
                                GradientStop {position: 0.75; color: appTheme.bodyText}
                                GradientStop {position: 1.0; color: appTheme.backgroundColor}
                            }
                        }

                        StyledFrame {
                            Layout.alignment: Qt.AlignHCenter
                            Layout.fillWidth: true
                            style: "thin"
                            GridLayout {
                                anchors.centerIn: parent
                                // Layout.alignment: Qt.AlignHCenter
                                rowSpacing: 20 * Constants.scaleFactor
                                columnSpacing: 15 * Constants.scaleFactor
                                columns: 2

                                Label {
                                    text: qsTr("Vérin rouleau IRs")
                                    horizontalAlignment: Text.AlignHCenter
                                    Layout.alignment: Qt.AlignHCenter
                                    color: appTheme.bodyText
                                    font.pixelSize: 20 * Constants.scaleFactor
                                }
                                CustomSwitch {
                                    id: switchRouleauImpression
                                    Layout.preferredWidth: pneumatiqueDetail.width * 0.15
                                    Layout.preferredHeight: width / 2
                                    nodeId:"Arp.Plc.Eclr/manuelRouleauPresseurFoursIR"
                                }

                                Label {
                                    text: qsTr("Rouleau IRs")
                                    horizontalAlignment: Text.AlignHCenter
                                    Layout.alignment: Qt.AlignHCenter
                                    color: appTheme.bodyText
                                    font.pixelSize: 20 * Constants.scaleFactor
                                }
                                CustomSwitch {
                                    Layout.preferredWidth: pneumatiqueDetail.width * 0.15
                                    Layout.preferredHeight: width / 2
                                    nodeId:"Arp.Plc.Eclr/startManuRouleauFoursIR"
                                }


                            }

                        }
                    }

                }
            }
        }

        Item { Layout.fillHeight: true }

    }

    Rectangle {
        id: manualAvertissement
        visible: manuelIRButton.checked
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

    Popup {
        id: popupIRs
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: height * 0.8 + padding * 2 + popupIRs.height * 0.26 * 0.22 + Constants.spacing * 2
        height: parent.height * 0.95
        modal: true
        focus: true
        padding: 50 * Constants.scaleFactor
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        background: Rectangle {
            color: appTheme.backgroundColor
            border.width: 2 * Constants.scaleFactor
            border.color: "#F0F0F0"
            radius: 45 * Constants.scaleFactor
        }

        OpcUaMonitoredNode {
            id: nodeSelectionIRs
            nodeId: "ns=6;s=Arp.Plc.Eclr/IRs.Cmd.Enable"
            monitored: popupIRs.opened
            onWriteCompleted: (success, message) => {
                console.log(nodeId + ": " + message);
            }
            onValueChanged: {
                for (var i = 0; i < 6; i++) {
                    listModelIR1Selection.setProperty(i, "value", value[i])
                }
            }
        }

        ListModel{
            id: listModelIR1Selection
            ListElement{
                value: false
            }
            ListElement{
                value: false
            }
            ListElement{
                value: false
            }
            ListElement{
                value: false
            }
            ListElement{
                value: false
            }
            ListElement{
                value: false
            }
        }

        ColumnLayout {
            anchors.centerIn: parent
            spacing: Constants.dp(20)

            RowLayout {
                spacing: Constants.dp(35)

                ColumnLayout {
                    spacing: 20 * Constants.scaleFactor

                    Label {
                        text: qsTr("Four IR 1")
                        color: appTheme.bodyText
                        font.bold: true
                        font.pixelSize: 30 * Constants.scaleFactor
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0

                        Repeater {
                            model: listModelIR1Selection

                            RowLayout {
                                visible: index < 3
                                Layout.fillWidth: true
                                spacing: Constants.spacing / 2

                                Item {
                                    Layout.alignment: Qt.AlignLeft| Qt.AlignVCenter
                                    Layout.preferredHeight: popupIRs.height * 0.26
                                    Layout.preferredWidth: popupIRs.height * 0.26
                                    Image {
                                        source: "../Resources/Images/IR_Fond.svg"
                                        height: parent.height
                                        width: parent.height
                                    }
                                    Image {
                                        source: "../Resources/Images/IR_Off.svg"
                                        height: parent.height
                                        width: parent.height
                                    }
                                    Image {
                                        id: imgIR
                                        source: "../Resources/Images/IR_On.svg"
                                        height: parent.height
                                        width: parent.height
                                        opacity: listModelIR1Selection.get(index).value ? 1 : 0

                                        Behavior on opacity {
                                            NumberAnimation { duration: 1300; easing.type: Easing.InOutQuad }
                                        }
                                    }

                                    MultiEffect {
                                        anchors.fill: source
                                        source: imgIR
                                        shadowEnabled: true
                                        shadowColor: "red"
                                        shadowBlur: 1
                                        opacity: listModelIR1Selection.get(index).value ? 1 : 0
                                        Behavior on opacity {
                                            NumberAnimation { duration: 1300; easing.type: Easing.InOutQuad }
                                        }
                                    }

                                }

                                CustomSwitch {
                                    Layout.alignment: Qt.AlignVCenter
                                    Layout.preferredHeight: popupIRs.height * 0.26 * 0.22
                                    Layout.preferredWidth:  height * 2
                                    nodeId:""

                                    checked: listModelIR1Selection.get(index).value

                                    onClicked: {
                                        nodeSelectionIRs.writeValueAtRange(checked, index)
                                    }
                                }

                            }
                        }

                    }

                }

                Rectangle {
                    Layout.preferredHeight: parent.height
                    Layout.preferredWidth: 1 * Constants.scaleFactor
                    visible: index === 1
                    gradient: Gradient {

                        GradientStop {position: 0.0; color: appTheme.backgroundColor}
                        GradientStop {position: 0.25; color: appTheme.bodyText}
                        GradientStop {position: 0.75; color: appTheme.bodyText}
                        GradientStop {position: 1.0; color: appTheme.backgroundColor}
                    }
                }

                ColumnLayout {
                    spacing: 20 * Constants.scaleFactor

                    Label {
                        text: qsTr("Four IR 2")
                        color: appTheme.bodyText
                        font.bold: true
                        font.pixelSize: 30 * Constants.scaleFactor
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0

                        Repeater {
                            model: listModelIR1Selection

                            RowLayout {
                                visible: index > 2
                                Layout.fillWidth: true
                                spacing: Constants.spacing / 2

                                Item {
                                    Layout.alignment: Qt.AlignLeft| Qt.AlignVCenter
                                    Layout.preferredHeight: popupIRs.height * 0.26
                                    Layout.preferredWidth: popupIRs.height * 0.26
                                    Image {
                                        source: "../Resources/Images/IR_Fond.svg"
                                        height: parent.height
                                        width: parent.height
                                    }
                                    Image {
                                        source: "../Resources/Images/IR_Off.svg"
                                        height: parent.height
                                        width: parent.height
                                    }
                                    Image {
                                        id: imgIR2
                                        source: "../Resources/Images/IR_On.svg"
                                        height: parent.height
                                        width: parent.height
                                        opacity: listModelIR1Selection.get(index).value ? 1 : 0

                                        Behavior on opacity {
                                            NumberAnimation { duration: 1300; easing.type: Easing.InOutQuad }
                                        }
                                    }

                                    MultiEffect {
                                        anchors.fill: source
                                        source: imgIR2
                                        shadowEnabled: true
                                        shadowColor: "red"
                                        shadowBlur: 1
                                        opacity: listModelIR1Selection.get(index).value ? 1 : 0
                                        Behavior on opacity {
                                            NumberAnimation { duration: 1300; easing.type: Easing.InOutQuad }
                                        }
                                    }

                                }

                                CustomSwitch {
                                    Layout.alignment: Qt.AlignVCenter
                                    Layout.preferredHeight: popupIRs.height * 0.26 * 0.22
                                    Layout.preferredWidth:  height * 2
                                    nodeId:""

                                    checked: listModelIR1Selection.get(index).value

                                    onClicked: {
                                        nodeSelectionIRs.writeValueAtRange(checked, index)
                                    }
                                }

                            }
                        }

                    }

                }



            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                spacing: Constants.dp(22)

                ModuleButton {
                    id: deepIRallOffbtn
                    Layout.alignment: Qt.AlignHCenter
                    labelText: qsTr("All Off")
                    Layout.preferredWidth: Constants.dp(120)
                    Layout.preferredHeight: Constants.dp(50)
                    maxFontSize: Constants.sp(28)
                    bordered: false

                    onClicked: {
                        for (var i = 0; i < 6; i++) {
                            nodeSelectionIRs.writeValueAtRange(false, i)
                        }
                    }

                }

                ModuleButton {
                    id: deepIRAllOnbtn
                    Layout.alignment: Qt.AlignHCenter
                    labelText: qsTr("All On")
                    Layout.preferredWidth: Constants.dp(120)
                    Layout.preferredHeight: Constants.dp(50)
                    maxFontSize: Constants.sp(28)
                    bordered: true

                    onClicked: {
                        for (var i = 0; i < 6; i++) {
                            nodeSelectionIRs.writeValueAtRange(true, i)
                        }
                    }
                }
            }
        }
    }

    Popup {
        id: deepCapteurPopup
        modal: true
        focus: false
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        anchors.centerIn: parent
        height: 600 * Constants.scaleFactor
        width: 500 * Constants.scaleFactor

        background: Rectangle{
            color: appTheme.backgroundColor
            border.width: 2
            border.color: appTheme.bodyText
            radius: 20 * Constants.scaleFactor
        }

        GroupBox {
            anchors.fill: parent
            id: groupBoxCapteur
            // visible: (Authentification.currentUserType > 1 ) ? true : false
            ColumnLayout {
                anchors.fill: parent
                spacing: Constants.spacing * 3

                Label {
                    text: qsTr("Paramètres Capteur IR")
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    font.pixelSize: 28 * Constants.scaleFactor
                    font.bold: true
                    color: appTheme.bodyText
                }

                RowLayout {
                    spacing: Constants.spacing * 2
                    GridLayout {
                        id: gridLayoutConsigne
                        rowSpacing: Constants.spacing
                        columnSpacing: Constants.spacing
                        columns: 2
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter | Qt.AlignTop
                        Label {
                            parent: gridLayoutConsigne
                            color: appTheme.bodyText
                            text: qsTr("Consigne")
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            Layout.alignment: /*Qt.AlignRight |*/ Qt.AlignVCenter
                        }
                        NumericInput {
                            parent: gridLayoutConsigne
                            Layout.alignment: Qt.AlignVCenter // Qt.AlignRight| Qt.AlignTop
                            Layout.preferredWidth: 100
                            min:0
                            max: 10000
                            nodeId: "Arp.Plc.Eclr/consigneCapteurTensionManuelRouleauFourIR"
                        }
                        Label {
                            parent: gridLayoutConsigne
                            color: appTheme.bodyText
                            text: qsTr("Valeur")
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            Layout.alignment: /*Qt.AlignRight |*/ Qt.AlignVCenter
                        }
                        NumericInput {
                            readOnly: true
                            parent: gridLayoutConsigne
                            Layout.alignment: Qt.AlignVCenter // Qt.AlignRight| Qt.AlignTop
                            Layout.preferredWidth: 100
                            min:0
                            max: 10000
                            nodeId: "Arp.Plc.Eclr/capteurRouleauFourIR_CounterValue"
                        }
                        Label {
                            parent: gridLayoutConsigne
                            color: appTheme.bodyText
                            text: qsTr("Periode\nEchantillonage")
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            Layout.alignment: /*Qt.AlignRight |*/ Qt.AlignVCenter
                        }
                        NumericInput {
                            parent: gridLayoutConsigne
                            Layout.alignment: Qt.AlignVCenter // Qt.AlignRight| Qt.AlignTop
                            Layout.preferredWidth: 100
                            min:1
                            max: 10000
                            unit: "ms"
                            nodeId: "Arp.Plc.Eclr/periodeEchantillonageRouleauFourIR"
                        }
                        Label {
                            parent: gridLayoutConsigne
                            color: appTheme.bodyText
                            text: qsTr("Kp")
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            Layout.alignment: /*Qt.AlignRight |*/ Qt.AlignVCenter
                        }
                        NumericInput {
                            parent: gridLayoutConsigne
                            Layout.alignment: Qt.AlignVCenter // Qt.AlignRight| Qt.AlignTop
                            Layout.preferredWidth: 100
                            min:0
                            max: 10000
                            nodeId: "Arp.Plc.Eclr/KpRouleauFourIR"
                            digit: 5
                        }
                        Label {
                            parent: gridLayoutConsigne
                            color: appTheme.bodyText
                            text: qsTr("Ti")
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            Layout.alignment: /*Qt.AlignRight |*/ Qt.AlignVCenter
                        }
                        NumericInput {
                            parent: gridLayoutConsigne
                            Layout.alignment: Qt.AlignVCenter // Qt.AlignRight| Qt.AlignTop
                            Layout.preferredWidth: 100
                            min:0
                            max: 10000
                            nodeId: "Arp.Plc.Eclr/TiRouleauFourIR"
                        }
                        Label {
                            parent: gridLayoutConsigne
                            color: appTheme.bodyText
                            text: qsTr("Kd")
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            Layout.alignment: /*Qt.AlignRight |*/ Qt.AlignVCenter
                        }
                        NumericInput {
                            parent: gridLayoutConsigne
                            Layout.alignment: Qt.AlignVCenter // Qt.AlignRight| Qt.AlignTop
                            Layout.preferredWidth: 100
                            min:0
                            max: 10000
                            nodeId: "Arp.Plc.Eclr/KdRouleauFourIR"
                        }
                        Label {
                            parent: gridLayoutConsigne
                            color: appTheme.bodyText
                            text: qsTr("Correction\nMaximum")
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            Layout.alignment: /*Qt.AlignRight |*/ Qt.AlignVCenter
                        }
                        NumericInput {
                            parent: gridLayoutConsigne
                            Layout.alignment: Qt.AlignVCenter // Qt.AlignRight| Qt.AlignTop
                            Layout.preferredWidth: 100
                            min:0
                            max: 10000
                            nodeId: "Arp.Plc.Eclr/correctionMaximumRouleauFourIR"
                        }
                        Label {
                            parent: gridLayoutConsigne
                            color: appTheme.bodyText
                            text: qsTr("Correction\nMinimum")
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            Layout.alignment: /*Qt.AlignRight |*/ Qt.AlignVCenter
                        }
                        NumericInput {
                            parent: gridLayoutConsigne
                            Layout.alignment: Qt.AlignVCenter // Qt.AlignRight| Qt.AlignTop
                            Layout.preferredWidth: 100
                            min:0
                            max: 10000
                            nodeId: "Arp.Plc.Eclr/correctionMinimumRouleauFourIR"
                        }
                    }

                    GridLayout {
                        id: gridLayoutCorrection
                        rowSpacing: Constants.spacing
                        columnSpacing: Constants.spacing
                        columns: 2
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter | Qt.AlignTop

                        Label {
                            text: qsTr("Asservissement")
                            color: appTheme.bodyText
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                        }
                        StatusIndicator {
                            text: qsTr("+")
                            id: statusIndicatorButtonAsservissementPopup
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            nodeId: "Arp.Plc.Eclr/readyAsservissementFourIR"
                        }

                        Label {
                            text: qsTr("Signal")
                            color: appTheme.bodyText
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignRight
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        }
                        StatusIndicator{
                            text: qsTr("+")
                            id: statusIndicatorButtonSignalPopup
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        }


                        Label {
                            text: qsTr("Erreur")
                            color: appTheme.bodyText
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        }
                        NumericInput {
                            readOnly: true
                            Layout.alignment: Qt.AlignVCenter // Qt.AlignRight| Qt.AlignTop
                            Layout.preferredWidth: 100
                            min:0
                            max: 10000
                            nodeId: "Arp.Plc.Eclr/erreurAsservissementFoursIR"
                        }

                        Label {
                            text: qsTr("Correction")
                            color: appTheme.bodyText
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        }
                        NumericInput {
                            readOnly: true
                            Layout.alignment: Qt.AlignVCenter // Qt.AlignRight| Qt.AlignTop
                            Layout.preferredWidth: 100
                            min:0
                            max: 10000
                            nodeId: "Arp.Plc.Eclr/correctionRouleauFourIR"
                            digit: 3
                        }

                        Label {
                            text: qsTr("P")
                            color: appTheme.bodyText
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        }
                        NumericInput {
                            readOnly: true
                            Layout.alignment: Qt.AlignVCenter // Qt.AlignRight| Qt.AlignTop
                            Layout.preferredWidth: 100
                            min:0
                            max: 10000
                            digit: 3
                            nodeId: "Arp.Plc.Eclr/pAsservissementFoursIR"
                        }

                        Label {
                            text: qsTr("I ")
                            color: appTheme.bodyText
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        }
                        NumericInput {
                            readOnly: true
                            Layout.alignment: Qt.AlignVCenter // Qt.AlignRight| Qt.AlignTop
                            Layout.preferredWidth: 100
                            min:0
                            max: 10000
                            digit: 3
                            nodeId: "Arp.Plc.Eclr/iAsservissementFoursIR"
                        }

                        Label {
                            text: qsTr("D")
                            color: appTheme.bodyText
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        }
                        NumericInput {
                            readOnly: true
                            Layout.alignment: Qt.AlignVCenter // Qt.AlignRight| Qt.AlignTop
                            Layout.preferredWidth: 100
                            min:0
                            max: 10000
                            digit: 3
                            nodeId: "Arp.Plc.Eclr/dAsservissementFoursIR"
                        }
                    }
                }
            }

            background: Rectangle {color: "transparent" }
        }



    }

}
