import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import Bobink
import QtQuick.Layouts 1.16
import QtQuick.Effects
import "../Resources/Components"
import "../"
Item {
    id: _item


    property bool manuelMode
    property bool automatiqueMode
    property int niveauPreTraitement: 95

    property alias manualModeButton: manualModeButton

    // StyledFrame LGL Buttons
    property alias btnCantre: btnCantre
    property alias btnPT: btnPT
    property alias btnFour1: btnFour1
    property alias btnImpression: btnImpression
    property alias btnIR: btnIR
    property alias btnFour2: btnFour2
    property alias btnBobinoir: btnBob

    property alias automaticModeScrollView: automaticModeScrollView

    // -------------------- MOTION LOGIC ------------------------
    // ----------------------------------------------------------

    property int currentState: 2
    property bool mainStopBtnClicked: false

    OpcUaMonitoredNode {
        nodeId: "ns=6;s=Arp.Plc.Eclr/UN.Status.StateCurrent"
        onValueChanged: _item.currentState = value
    }

    onCurrentStateChanged: {
        if (currentState === 6 | currentState === 3 | currentState === 12) {
            switchStartStopPreTraitement.checked = true
        } else {
            switchStartStopPreTraitement.checked = false
        }

        if (currentState !== 2 && powerButton.checked) {
            powerButton.checked = false
        }

        if (currentState === 15) {
            if (nodeFour1Plein.value) {
                reset()
            } else {
                notificationPopup.warningColor = "#555"
                notificationPopup.text = "Remplir le four"
                notificationPopup.subText = "Pour terminer le resetting"
                notificationPopup.importance = 2
                notificationPopup.em = null
                notificationPopup.open()
            }
        }

        if (currentState === 4) {
            notificationPopup.warningColor = "green"
            notificationPopup.text = "Prêt à démarrer"
            notificationPopup.subText = "Resetting done"
            notificationPopup.importance = 2
            notificationPopup.em = null
            notificationPopup.open()
        }
    }

    onMainStopBtnClickedChanged: {
        onPlayPauseChecked(mainStopButton)
        mainStopBtnClicked = false
    }

    function reset() {
        notificationPopup.warningColor = "#555"
        notificationPopup.text = "Machine pleine"
        notificationPopup.subText = "Resetting en cours..."
        notificationPopup.importance = 2
        notificationPopup.open()
        resetDelay.k = 0
        resetDelay.start()
    }

    Timer {
        id: resetDelay
        interval: [0, 1].includes(k) ? 1000 : 5000
        property int k: 0
        onTriggered: {
            if (_item.currentState === 15) {
                if (k === 2) {
                    k = 0
                }
                if (k === 0) {
                    console.log("Trying to end resetting")
                    writeNode(node_jogDeposeF1, true)
                    k = 1
                    resetDelay.start()
                } else if (k === 1) {
                    console.log("Resetting not done, trying again")
                    writeNode(nodeFour1Done, true)
                    k = 2
                    resetDelay.start()
                }

            }
        }
    }

    function onPlayPauseChecked(btn) {
        let isControlButton = (
            btn === switchStartStopPreTraitement ||
            btn === switchStartStopImpressionFour2 ||
            btn === switchStartStopBobibnoir ||
            btn === playPauseButton ||
            btn === mainStopButton ||
            btn === powerButton
        );

        if (isControlButton) {
            notificationPage.blockingEvents = notificationPage.getBlockingEvents()
            // ====== BTN = PLAYPAUSE ou IMPRESSION ou BOBINOIR ======
            if (btn === playPauseButton | btn === switchStartStopImpressionFour2 | btn === switchStartStopBobibnoir) {
                notificationPopup.warningColor = "#FFF100"
                notificationPopup.importance = 2
                notificationPopup.text = "Commande impossible"
                notificationPopup.subText = "IHM limité à la partie 1"
                notificationPopup.open()
            }
            // ====== BTN = PRETRAIT ======
            else if (btn === switchStartStopPreTraitement) {
                // blockingEvents > 0 : IMPOSSIBLE DE DEMARRER
                if (notificationPage.blockingEvents > 0) {
                    notificationPage.openWarningPopup()
                }
                // currentState = [4] : IDLE --> Start
                else if (_item.currentState === 4) {
                    console.log("==== START ====")
                    writeNode(nodeCmdStart, true)
                }
                // currentState = [11] : HELD --> Unhold
                else if (_item.currentState === 11) {
                    console.log("==== UNHOLD ====")
                    writeNode(nodeCmdUnHold, true)
                }
                // currentState = [5] : Suspend --> Unsuspend
                else if (_item.currentState === 5) {
                    console.log("==== UNSUSPEND ====")
                    writeNode(nodeCmdUnSuspend, true)
                }
                // currentState = [6] : Execute --> Hold
                else if (_item.currentState === 6) {
                    console.log("==== HOLD ====")
                    writeNode(nodeCmdHold, true)
                } else {
                    notificationPopup.warningColor = "#FFF100"
                    notificationPopup.importance = 2
                    notificationPopup.text = "Commande impossible"
                    notificationPopup.subText = "État actuel de l'automate invalide : " + Constants.stateNames[_item.currentState]
                    notificationPopup.open()
                }
            }
            // ====== BTN = MAINSTOP ======
            else if (btn === mainStopButton) {
                // currentState != [8, 9, 1] --> Abort
                if ([2,3,4,5,6,7,10,11,12,13,14,15,16,17].includes(_item.currentState)) {
                    console.log("==== ABORT ====")
                    writeNode(nodeCmdAbort, true)
                }
                // currentState = [9] Aborted --> Clear
                else if (_item.currentState === 9) {
                    console.log("==== CLEAR ====")
                    writeNode(nodeCmdClear, true)
                } else {
                    notificationPopup.warningColor = "#FFF100"
                    notificationPopup.importance = 2
                    notificationPopup.text = "Commande impossible"
                    notificationPopup.subText = "État actuel de l'automate invalide : " + Constants.stateNames[_item.currentState]
                    notificationPopup.open()
                }
            }
            // ====== BTN = POWER ======
            else if (btn === powerButton) {
                // currentState = [2] : Stopped --> Reset
                if (_item.currentState === 2) {
                    console.log("==== RESET ====")
                    writeNode(nodeCmdReset, true)
                }
                // currentState != [8, 9, 1, 7, 2] --> Stop
                if ([3,4,5,6,10,11,12,13,14,15,16,17].includes(_item.currentState)) {
                    console.log("==== STOP ====")
                    writeNode(nodeCmdStop, true)
                }
            }
        }
    }

    // ------------------- OPCUA NODE TOGGLE ------------------------
    // --------------------------------------------------------------

    function toggleModule(module) {
        module.checked = !module.checked;
    }

    function writeNode(node, value) {
        node.writeValue(value)
        if (value) {
            nodeTimer.currentNode = node
            nodeTimer.start()
        }
    }

    Timer {
        id: nodeTimer
        property var currentNode
        interval: 100
        onTriggered: { writeNode(currentNode, false) }
    }

    OpcUaMonitoredNode {
        id: nodeCmdReset
        nodeId: "ns=6;s=Arp.Plc.Eclr/UN.Command.CntrlCmdSet.Reset"
        monitored: false
    }
    OpcUaMonitoredNode {
        id: nodeCmdStart
        nodeId: "ns=6;s=Arp.Plc.Eclr/UN.Command.CntrlCmdSet.Start"
        monitored: false
    }
    OpcUaMonitoredNode {
        id: nodeCmdStop
        nodeId: "ns=6;s=Arp.Plc.Eclr/UN.Command.CntrlCmdSet.Stop"
        monitored: false
    }
    OpcUaMonitoredNode {
        id: nodeCmdHold
        nodeId: "ns=6;s=Arp.Plc.Eclr/UN.Command.CntrlCmdSet.Hold"
        onValueChanged: console.log("hold : " + value)
        monitored: false
    }
    OpcUaMonitoredNode {
        id: nodeCmdUnHold
        nodeId: "ns=6;s=Arp.Plc.Eclr/UN.Command.CntrlCmdSet.UnHold"
        onValueChanged: console.log("unhold : " + value)
        monitored: false
    }
    OpcUaMonitoredNode {
        id: nodeCmdUnSuspend
        nodeId: "ns=6;s=Arp.Plc.Eclr/UN.Command.CntrlCmdSet.UnSuspend"
        monitored: false
    }
    OpcUaMonitoredNode {
        id: nodeCmdAbort
        nodeId: "ns=6;s=Arp.Plc.Eclr/UN.Command.CntrlCmdSet.Abort"
        monitored: false
    }
    OpcUaMonitoredNode {
        id: nodeCmdClear
        nodeId: "ns=6;s=Arp.Plc.Eclr/UN.Command.CntrlCmdSet.Clear"
        monitored: false
    }
    OpcUaMonitoredNode {
        id: nodeFour1Plein;
        nodeId: "ns=6;s=Arp.Plc.Eclr/tapisPleinMBCognexFour1";
        monitored: true
        onValueChanged: { if (value && _item.currentState === 15) { reset() } }
    }
    OpcUaMonitoredNode {
        id: node_jogDeposeF1;
        nodeId: "ns=6;s=Arp.Plc.Eclr/EM3_ModuleControl1.jogDeposeFilsFour1Done";
        monitored: true
    }
    OpcUaMonitoredNode {
        id: nodeFour1Done
        nodeId: "ns=6;s=Arp.Plc.Eclr/EM3_ModuleControl1.remplirFour1Done"
        monitored: true
    }

    // ------------------- CM TOGGLE ------------------------
    // ------------------------------------------------------

    function toggleCM(emIndex, cmIndex) {
        var currentMask = Constants.cmInactiveMasks[emIndex]
        var newMask
        var isEnabled = (currentMask & (1 << cmIndex)) === 0
        if (isEnabled) {
            newMask = currentMask | (1 << cmIndex)
        } else {
            newMask = currentMask & ~(1 << cmIndex)
        }
        if (emIndex === 4) {
            opcuaNodeInactiveMasksIR.writeValue(Number(newMask))
        } else if (emIndex === 2) {
            opcuaNodeInactiveMasksPT.writeValue(Number(newMask))
        }

        var newMasks = Constants.cmInactiveMasks.slice()
        newMasks[emIndex] = newMask
        Constants.cmInactiveMasks = newMasks
    }

    OpcUaMonitoredNode {
        id: opcuaNodeInactiveMasksIR
        monitored: rootApp.visible
        nodeId: "ns=6;s=Arp.Plc.Eclr/UN00_Modules.EM[4].CM_InactiveMask"
        onValueChanged: {
            if (value !== undefined) {
                var newMasks = Constants.cmInactiveMasks.slice()
                newMasks[4] = value
                Constants.cmInactiveMasks = newMasks
            }
        }
        onWriteCompleted: (success, message) => {
            console.log(nodeId + ": " + message);
        }
    }

    OpcUaMonitoredNode {
        id: opcuaNodeInactiveMasksPT
        monitored: rootApp.visible
        nodeId: "ns=6;s=Arp.Plc.Eclr/UN00_Modules.EM[2].CM_InactiveMask"
        onValueChanged: {
            if (value !== undefined) {
                var newMasks = Constants.cmInactiveMasks.slice()
                newMasks[2] = value
                Constants.cmInactiveMasks = newMasks
            }
        }
        onWriteCompleted: (success, message) => {
            console.log(nodeId + ": " + message);
        }
    }

    property int cmInactiveMaskIR: Constants.cmInactiveMasks[4]
    property int cmInactiveMaskPT: Constants.cmInactiveMasks[2]

    onCmInactiveMaskIRChanged: {
        // update status for CHAUFFE IR : emIndex = 4; cmIndex = 6
        console.log("Changement IR")
        if ((_item.cmInactiveMaskIR & (1 << 6)) === 0) {
            switchStartIR.checked = true
        } else {
            switchStartIR.checked = false

        }
    }

    onCmInactiveMaskPTChanged: {
        // update status for SPRAYING : emIndex = 2; cmIndex = 1
        if ((_item.cmInactiveMaskPT & (1 << 1)) === 0) {
            switchSprayingPreTraitement.checked = true
        } else {
            switchSprayingPreTraitement.checked = false
        }

        // update status for PLASMA : emIndex = 2; cmIndex = 0
        if ((_item.cmInactiveMaskPT & (1 << 0)) === 0) {
            switchPlasmaPreTraitement.checked = true
        } else {
            switchPlasmaPreTraitement.checked = false
        }
    }

    ColumnLayout {
        id: mainColumn
        anchors.margins: 40 * Constants.scaleFactor
        anchors.topMargin: 20 * Constants.scaleFactor
        anchors.bottomMargin: 2 * Constants.scaleFactor
        spacing: 20 * Constants.scaleFactor
        anchors.fill: parent

        RowLayout {
            Layout.fillWidth: true
            Text {
                Layout.fillWidth: true

                text: qsTr("Home menu")
                font.pixelSize: Math.max(35, parent.width * 0.037)
                font.bold: true
                color: appTheme.bodyText
            }

            Item {
                Layout.fillWidth: true
            }

            ManuelSwitch {
                id: manualModeButton
                nodeId: ""
            }
        }

        StyledFrame {
            id: styledFrameLGL
            style: "thin"

            RowLayout {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                spacing: 3

                // CANTRE
                Item {
                    id: moduleItem
                    Layout.preferredWidth: (mainColumn.width - 80) / 10.6
                    Layout.preferredHeight: 0.6 * moduleItem.width

                    ModuleButton {
                        id: btnCantre
                        labelText: qsTr("Cantre")
                        anchors.fill: parent
                        bordered: false
                    }

                    StatusIndicatorTricolor {
                        id: statusIndicatorButtonCantre
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.topMargin: 3 * Constants.scaleFactor
                        anchors.rightMargin: 3 * Constants.scaleFactor

                        width: parent.width * 0.2
                        height: width
                        nodeIdRed: "Arp.Plc.Eclr/tricolorRougeCantre"
                        nodeIdYellow: "Arp.Plc.Eclr/tricolorOrangeCantre"
                        nodeIdGreen: "Arp.Plc.Eclr/tricolorVertCantre"
                    }
                }

                SeparatingModuleItem {
                    Layout.preferredWidth: moduleItem.width * 0.6
                    Layout.preferredHeight: 0.42 * width
                    nodeIdEnable: "Arp.Plc.Eclr/LGL_Connect.Enable"
                    nodeIdErreurId: "Arp.Plc.Eclr/LGL_Connect.ErreurID"
                    title: "LGL\n"
                    // lglPopupIndex: 1
                    // //popupRef: lglPopup
                    // OPCUANode {
                    //     nodeId: "Arp.Plc.Eclr/LGL_Connect.Erreur"
                    //     onValueChanged: siCantre.erreurID = value
                    // }
                }

                // PT
                Item {
                    Layout.preferredWidth: moduleItem.width
                    Layout.preferredHeight: moduleItem.height

                    ModuleButton {
                        id: btnPT
                        labelText: qsTr("Pré-traitement")
                        anchors.fill: parent
                        bordered: false
                    }

                    StatusIndicatorTricolor {
                        id: siPT
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.topMargin: 3 * Constants.scaleFactor
                        anchors.rightMargin: 3 * Constants.scaleFactor
                        width: parent.width * 0.2
                        height: width
                        nodeIdRed: "Arp.Plc.Eclr/tricolorRougePreTraitement"
                        nodeIdYellow: "Arp.Plc.Eclr/tricolorOrangePreTraitement"
                        nodeIdGreen: "Arp.Plc.Eclr/tricolorVertPreTraitement"
                    }
                }

                SeparatingModuleItem {
                    Layout.preferredWidth: moduleItem.width * 0.6
                    Layout.preferredHeight: 0.42 * width
                    title: "Rouleau\nFour 1"
                    nodeIdEnable: "Arp.Plc.Eclr/casseFilsRouleauFour1.Enable"
                    nodeIdErreurId: "Arp.Plc.Eclr/casseFilsRouleauFour1.ErreurID"
                    //lglPopupIndex: 2
                    //popupRef: lglPopup
                }

                // FOUR 1
                Item {
                    Layout.preferredWidth: moduleItem.width
                    Layout.preferredHeight: moduleItem.height

                    ModuleButton {
                        id: btnFour1
                        labelText: qsTr("Four 1")
                        anchors.fill: parent
                        bordered: false
                    }

                    StatusIndicatorTricolor {
                        id: siFour1
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.topMargin: 3 * Constants.scaleFactor
                        anchors.rightMargin: 3 * Constants.scaleFactor
                        width: parent.width * 0.2
                        height: width
                        nodeIdRed: "Arp.Plc.Eclr/tricolorRougeFour1"
                        nodeIdYellow: "Arp.Plc.Eclr/tricolorOrangeFour1"
                        nodeIdGreen: "Arp.Plc.Eclr/tricolorVertFour1"
                    }
                }

                SeparatingModuleItem {
                    Layout.preferredWidth: moduleItem.width * 0.6
                    Layout.preferredHeight: 0.42 * width
                    title: "Fours\nIR"
                    nodeIdEnable: "Arp.Plc.Eclr/casseFilsRouleauFoursIR.Enable"
                    nodeIdErreurId: "Arp.Plc.Eclr/casseFilsRouleauFoursIR.ErreurID"
                    //lglPopupIndex: 3
                    //popupRef: lglPopup
                }

                // IMPRESSION
                Item {
                    Layout.preferredWidth: moduleItem.width
                    Layout.preferredHeight: moduleItem.height

                    ModuleButton {
                        id: btnImpression
                        labelText: qsTr("Impression")
                        anchors.fill: parent
                        bordered: false

                    }

                    StatusIndicatorTricolor {
                        id: siImpression
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.topMargin: 3 * Constants.scaleFactor
                        anchors.rightMargin: 3 * Constants.scaleFactor
                        width: parent.width * 0.2
                        height: width
                        nodeIdRed: "Arp.Plc.Eclr/tricolorRougeImpression"
                        nodeIdYellow: "Arp.Plc.Eclr/tricolorOrangeImpression"
                        nodeIdGreen: "Arp.Plc.Eclr/tricolorVertImpression"
                    }
                }

                SeparatingModuleItem {
                    Layout.preferredWidth: moduleItem.width * 0.6
                    Layout.preferredHeight: 0.42 * width

                    nodeIdEnable: "TEST" // "Arp.Plc.Eclr/casseFilsRouleauFour2.Enable"
                    nodeIdErreurId: "TEST" // "Arp.Plc.Eclr/casseFilsRouleauFour2.ErreurID"
                    hasCF: false
                    // hasLgl: false
                }

                // IR
                Item {
                    Layout.preferredWidth: moduleItem.width
                    Layout.preferredHeight: moduleItem.height

                    ModuleButton {
                        id: btnIR
                        labelText: qsTr("IR")
                        anchors.fill: parent
                        bordered: false
                    }

                    StatusIndicatorTricolor {
                        id: siIR
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.topMargin: 3 * Constants.scaleFactor
                        anchors.rightMargin: 3 * Constants.scaleFactor
                        width: parent.width * 0.2
                        height: width
                        nodeIdRed: "Arp.Plc.Eclr/tricolorRougeFourIR"
                        nodeIdYellow: "Arp.Plc.Eclr/tricolorOrangeFourIR"
                        nodeIdGreen: "Arp.Plc.Eclr/tricolorVertFourIR"
                    }
                }

                SeparatingModuleItem {
                    Layout.preferredWidth: moduleItem.width * 0.6
                    Layout.preferredHeight: 0.42 * width
                    title: "Rouleau\nFour 2"
                    nodeIdEnable: "Arp.Plc.Eclr/casseFilsRouleauFour2.Enable"
                    nodeIdErreurId: "Arp.Plc.Eclr/casseFilsRouleauFour2.ErreurID"
                    //glglPopupIndex: 4
                    //popupRef: lglPopup
                }

                // FOUR 2
                Item {
                    Layout.preferredWidth: moduleItem.width
                    Layout.preferredHeight: moduleItem.height

                    ModuleButton {
                        id: btnFour2
                        labelText: qsTr("Four 2")
                        anchors.fill: parent
                        bordered: false
                    }

                    StatusIndicatorTricolor {
                        id: siFour2
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.topMargin: 3 * Constants.scaleFactor
                        anchors.rightMargin: 3 * Constants.scaleFactor
                        width: parent.width * 0.2
                        height: width
                        nodeIdRed: "Arp.Plc.Eclr/tricolorRougeFour2"
                        nodeIdYellow: "Arp.Plc.Eclr/tricolorOrangeFour2"
                        nodeIdGreen: "Arp.Plc.Eclr/tricolorVertFour2"
                    }
                }

                SeparatingModuleItem {
                    Layout.preferredWidth: moduleItem.width * 0.6
                    Layout.preferredHeight: 0.42 * width

                    hasCF: false
                    nodeIdEnable: "TEST" //"Arp.Plc.Eclr/casseFilsBobinoir.Enable"
                    nodeIdErreurId: "TEST" //"Arp.Plc.Eclr/casseFilsBobinoir.ErreurID"
                    // lglPopupIndex: 5
                    // hasLgl: false
                    //popupRef: lglPopup
                }

                // BOB
                Item {
                    Layout.preferredWidth: moduleItem.width
                    Layout.preferredHeight: moduleItem.height

                    ModuleButton {
                        id: btnBob
                        labelText: qsTr("Bobinage")
                        anchors.fill: parent
                        bordered: false
                    }

                    StatusIndicatorTricolor {
                        id: siBob
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.topMargin: 3 * Constants.scaleFactor
                        anchors.rightMargin: 3 * Constants.scaleFactor
                        width: parent.width * 0.2
                        height: width
                        nodeIdRed: "Arp.Plc.Eclr/tricolorRougeBobinoir"
                        nodeIdYellow: "Arp.Plc.Eclr/tricolorOrangeBobinoir"
                        nodeIdGreen: "Arp.Plc.Eclr/tricolorVertBobinoir"
                    }
                }
            }
        }

        RowLayout {
            id: centralRow
            spacing: 10 * Constants.scaleFactor
            Layout.preferredWidth: mainColumn.width
            Layout.fillHeight: true
            visible: true

            property int componentHeight: height * 0.1

            Item {
                id: resettingView
                visible: _item.currentState === 2
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.fillHeight: true
                Layout.fillWidth: true

                ColumnLayout {
                    anchors.fill: parent
                    spacing: Constants.dp(10)

                    Item { Layout.fillHeight: true}

                    Text {
                        Layout.fillWidth: true
                        text: qsTr("Machine à l'arrêt")
                        font.pixelSize: Constants.sp(30)
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        color: appTheme.bodyText
                    }

                    Text {
                        Layout.fillWidth: true
                        text: qsTr("Démarrer")
                        font.pixelSize: Constants.sp(28)
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        color: appTheme.bodyText
                        font.bold: true
                    }

                    PowerButton {
                        id: powerButton
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                        onCheckedChanged: {
                            if (checked) {
                                onPlayPauseChecked(powerButton)
                            }
                        }
                    }

                    Item { Layout.fillHeight: true}
                }

            }

            ScrollView {
                id: automaticModeScrollView
                ScrollBar.vertical.policy: ScrollBar.AsNeeded
                ScrollBar.horizontal.policy: ScrollBar.AsNeeded
                ScrollBar.horizontal.interactive: true
                Layout.fillHeight: true
                Layout.fillWidth: true

                visible: _item.currentState !== 2

                RowLayout {
                    anchors.fill: parent

                    StyledFrame {
                        style: "shadowed"
                        id: groupBoxPreTraitement
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        Layout.fillHeight: true
                        Layout.preferredWidth: groupBoxImpression.width
                        Layout.margins: 10 * Constants.scaleFactor
                        shadowColor: manualModeButton.checked ?
                                         "#deae2a" :
                                         (switchStartStopPreTraitement.checked || (chainAsservissement1.checked && playPauseButton.checked)) ?
                                             "#0FFF35" :
                                             "black"

                        ColumnLayout {
                            anchors.fill: parent
                            spacing: Constants.spacing * 2

                            Label {
                                id: labelTitrePreTraitement
                                text: qsTr("Pre-Traitement")
                                color: appTheme.bodyText
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.bold: true
                                font.pixelSize: 35 * Constants.scaleFactor

                            }

                            CustomPlayPause {
                                id: switchStartStopPreTraitement
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.preferredWidth: groupBoxImpression.width * 0.28
                                Layout.preferredHeight: width
                                nodeId: ""

                                MouseArea {
                                    id: playPreTraitArea
                                    anchors.fill: parent
                                    onClicked: {
                                        onPlayPauseChecked(switchStartStopPreTraitement)
                                    }

                                    onPressed: switchStartStopPreTraitement.down = true
                                    onReleased: switchStartStopPreTraitement.down = false
                                }
                            }

                            GridLayout {
                                id: gridConsignePreTraitement
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                                columns: 2
                                rowSpacing: Constants.spacing * 1.5
                                columnSpacing: Constants.spacing
                                Label {
                                    id: labelConsigneVitessePreTraitement
                                    text: qsTr("Consigne")
                                    font.pixelSize: 18 * Constants.scaleFactor
                                    color: appTheme.bodyText
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    visible: !chainAsservissement1.checked
                                }
                                NumericInput {
                                    id: textFieldConsigneVitessePreTraitement
                                    horizontalAlignment: Text.AlignHCenter
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    placeholderText: qsTr("m/min")
                                    Layout.preferredWidth: groupBoxImpression.width * 0.5
                                    Layout.preferredHeight: centralRow.componentHeight
                                    nodeId: "ns=6;s=Arp.Plc.Eclr/consigneVitesseMaitreFour1"
                                    nodeIdLinked: "ns=6;s=Arp.Plc.Eclr/vitesseRemplissageFour1"
                                    offset: 6/100
                                    enabled: ![3, 12, 14].includes(_item.currentState)
                                    unit: "m/min"
                                    min: 1
                                    max: 400
                                    visible: !chainAsservissement1.checked
                                }
                            }

                            Item {
                                id: placeholderPreTrait
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.preferredHeight: currentHeight
                                visible: true

                                // Hauteur dynamique animée
                                property int currentHeight: 0

                                // Hauteur réelle du bouton
                                property int targetHeight: switchStartStopPreTraitement.height + gridConsignePreTraitement.height + gridConsignePreTraitement.rowSpacing

                                // Pour déclencher le comportement
                                property bool animate: chainAsservissement1.checked

                                onAnimateChanged: {
                                    if (animate) {
                                        // --- CAS "glissement vers le haut" ---
                                        placeholderPreTrait.visible = true;
                                        switchStartStopPreTraitement.visible = false;
                                        gridConsignePreTraitement.visible = false;

                                        // on part de targetHeight → 0
                                        currentHeight = targetHeight;
                                        Qt.callLater(() => {
                                                         heightAnimation.to = 0;
                                                         heightAnimation.start();
                                                     });

                                    } else {
                                        // --- CAS "glissement vers le bas" ---
                                        placeholderPreTrait.visible = true;
                                        currentHeight = 0;

                                        Qt.callLater(() => {
                                                         heightAnimation.to = targetHeight;
                                                         heightAnimation.start();
                                                     });
                                    }
                                }

                                PropertyAnimation {
                                    id: heightAnimation
                                    target: placeholderPreTrait
                                    property: "currentHeight"
                                    duration: 150
                                    easing.type: Easing.InOutQuad

                                    onStopped: {
                                        if (!placeholderPreTrait.animate) {
                                            // On cache le placeholderPreTrait une fois l'animation vers le bas terminée
                                            placeholderPreTrait.visible = false;
                                            switchStartStopPreTraitement.visible = true;
                                            gridConsignePreTraitement.visible = true;
                                        }
                                    }
                                }
                            }

                            Item {

                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                ColumnLayout {
                                    anchors.fill: parent
                                    spacing: Constants.spacing * 2

                                    Rectangle {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: groupBoxImpression.width / 1.5 //groupBoxPreTraitement.width / 1.5
                                        height: 1 * Constants.scaleFactor
                                        gradient: Gradient {
                                            orientation: Gradient.Horizontal
                                            GradientStop { position : 0.0; color: "transparent" }
                                            GradientStop { position : 0.25; color: appTheme.bodyText }
                                            GradientStop { position : 0.75; color: appTheme.bodyText}
                                            GradientStop { position : 1.0; color: "transparent" }
                                        }
                                    }

                                    GridLayout {
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                                        columns: 2
                                        rowSpacing: Constants.spacing * 1.5
                                        columnSpacing: Constants.spacing


                                        Label {
                                            id: labelPlasmaPreTraitement
                                            text: qsTr("Traitement\nPlasma")
                                            font.pixelSize: 18 * Constants.scaleFactor
                                            color: appTheme.bodyText
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                        }
                                        CustomSwitch {
                                            id: switchPlasmaPreTraitement
                                            text: "ON"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            Layout.preferredWidth: height * 2
                                            Layout.preferredHeight: centralRow.componentHeight
                                            onClicked: toggleCM(2, 0)
                                            enabled: ![3, 12, 14].includes(_item.currentState)
                                        }
                                        Label {
                                            text: qsTr("Traitement\nChimique")
                                            font.pixelSize: 18 * Constants.scaleFactor
                                            color: appTheme.bodyText
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                        }
                                        CustomSwitch {
                                            id: switchSprayingPreTraitement
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            Layout.preferredWidth: height * 2
                                            Layout.preferredHeight: centralRow.componentHeight
                                            onClicked: toggleCM(2, 1)
                                            enabled: ![3, 12, 14].includes(_item.currentState)
                                        }


                                        ScenarioButton {
                                            id: scenarioFour1
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            Layout.preferredWidth: scenarioFoursIR.width
                                            Layout.preferredHeight: centralRow.componentHeight
                                            labelText: "Remplir Four 1"
                                            runningText: "Remplissage\nFour 1..."
                                            Layout.columnSpan: 2
                                            nodeIdExec: "ns=6;s=Arp.Plc.Eclr/remplirFour1"
                                            nodeIdEnd: "ns=6;s=Arp.Plc.Eclr/tapisPleinMBCognexFour1"
                                            endValue: 12
                                            enabled: [5, 15].includes(_item.currentState) && !nodeFour1Plein.value

                                            // property bool scenarioOn: false

                                            MouseArea {
                                                id: areaRemplirFour1
                                                width: parent.width * 0.7
                                                height: parent.height
                                                anchors.left: parent.left

                                                onPressed: {
                                                    // blockingEvents > 0 : IMPOSSIBLE DE DEMARRER
                                                    notificationPage.blockingEvents = notificationPage.getBlockingEvents()
                                                    if (notificationPage.blockingEvents > 0) {
                                                        notificationPage.openWarningPopup()
                                                    } else {
                                                        node_jogDeposeF1.writeValue(true)
                                                        // scenarioFour1.scenarioOn = true
                                                    }
                                                }

                                                onReleased: {
                                                    // blockingEvents > 0 : IMPOSSIBLE DE DEMARRER
                                                    if (notificationPage.blockingEvents <= 0) {
                                                        node_jogDeposeF1.writeValue(false)
                                                        jogToRemplirDelay.start()
                                                    }
                                                }

                                                // OpcUaMonitoredNode {
                                                //     nodeId: "ns=6;s=Arp.Plc.Eclr/G7_EM3.RD.Resetting"
                                                //     monitored: _item.visible
                                                //     onValueChanged: {
                                                //         if (scenarioFour1.scenarioOn) {
                                                //             scenarioFour1.startScenario()
                                                //             scenarioFour1.scenarioOn = false
                                                //         }

                                                //     }
                                                // }

                                                Timer {
                                                    id: jogToRemplirDelay
                                                    interval: 500
                                                    onTriggered: scenarioFour1.startScenario()
                                                }

                                            }
                                        }

                                    }
                                }

                            }

                            Item {
                                Layout.preferredHeight: Constants.dp(200)
                                Layout.preferredWidth: 60
                            }
                        }

                    }

                    ColumnLayout {
                        Item {
                            Layout.preferredHeight: groupBoxImpression.height / 4
                        }

                        ChainAsservissement {
                            id: chainAsservissement1
                            Layout.alignment: Qt.AlignTop
                            width: 120 * Constants.scaleFactor
                            height: 60 * Constants.scaleFactor
                            checked: false
                            onCheckedChanged: onPlayPauseChecked(chainAsservissement1)

                        }

                        Item {
                            Layout.fillHeight: true
                        }
                    }

                    StyledFrame {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        style: "shadowed"
                        id: groupBoxImpression
                        Layout.fillHeight: true
                        Layout.margins: 10 * Constants.scaleFactor
                        Layout.preferredWidth: _item.width / 3 - 40 * Constants.scaleFactor - chainAsservissement1.width - centralRow.spacing
                        shadowColor: manualModeButton.checked ?
                                         "#deae2a" :
                                         switchStartStopImpressionFour2.checked || playPauseButton.checked ?
                                             "#0FFF35" :
                                             "black"

                        ColumnLayout {
                            id: layoutImpr
                            spacing: Constants.spacing * 1.5
                            anchors.fill: parent

                            Label {
                                text: qsTr("Impression")
                                color: appTheme.bodyText
                                Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.bold: true
                                font.pixelSize: 35 * Constants.scaleFactor
                            }

                            CustomPlayPause {
                                id: switchStartStopImpressionFour2
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.preferredWidth: groupBoxImpression.width * 0.28
                                Layout.preferredHeight: width
                                nodeId: ""
                                visible: !playPauseButton.visible
                                enabled: false

                                MouseArea {
                                    id: playImpressionArea
                                    anchors.fill: parent
                                    onClicked: {
                                        onPlayPauseChecked(switchStartStopImpressionFour2)
                                    }

                                    onPressed: switchStartStopImpressionFour2.down = true
                                    onReleased: switchStartStopImpressionFour2.down = false
                                    enabled: false
                                }
                            }

                            Button {
                                id: playPauseButton
                                checkable: !mainStopButton.checked
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                visible: chainAsservissement1.checked || chainAsservissement3.checked
                                Layout.preferredWidth: groupBoxImpression.width * 0.28
                                Layout.preferredHeight: width
                                enabled: false

                                MouseArea {
                                    id: playPauseArea
                                    enabled: false
                                    anchors.fill: parent
                                    onClicked: {
                                        onPlayPauseChecked(playPauseButton)
                                    }
                                }

                                property alias currentImage: playPauseIcon.source

                                states: stateplayPauseButton

                                transitions: Transition {
                                    from: "*"
                                    to: "pressed"
                                    reversible: true
                                    NumberAnimation {
                                        properties: "scale,opacity"
                                        duration: 100
                                    }
                                }

                                contentItem: Item {
                                    id: playPauseVisual
                                    anchors.fill: parent
                                    transformOrigin: Item.Center

                                    Image {
	sourceSize: Qt.size(width, height)
                                        id: playPauseIcon
                                        anchors.fill: parent
                                        fillMode: Image.PreserveAspectFit
                                        source: playPauseButton.checked ? "../Resources/Images/ButtonPause.svg" : "../Resources/Images/ButtonPlay.svg"
                                        smooth: true
                                    }

                                    MultiEffect {
                                        anchors.fill: source
                                        source: playPauseIcon
                                        shadowEnabled: true
                                        shadowColor: playPauseButton.checked ? "#65E031" : "#FF9A3D"
                                        shadowBlur: 1
                                    }

                                    Rectangle {
                                        visible: !playPauseButton.enabled
                                        anchors.fill: parent
                                        radius: height / 2
                                        color: "#555"
                                        opacity: 0.5
                                    }

                                }

                                background: Rectangle {
                                    color: "transparent"
                                }

                            }

                            State {
                                id: stateplayPauseButton
                                name: "pressed"
                                when: playPauseArea.pressed
                                PropertyChanges {
                                    target: playPauseVisual
                                    scale: 0.95
                                    opacity: 0.6
                                }
                            }

                            GridLayout {
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                                columns: 2
                                rowSpacing: Constants.spacing * 2
                                columnSpacing: Constants.spacing

                                Label {
                                    text: qsTr("Consigne")
                                    color: appTheme.bodyText
                                    font.pixelSize: 18 * Constants.scaleFactor
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                }
                                NumericInput {
                                    id: textFieldConsigneVitesseFour2
                                    horizontalAlignment: Text.AlignHCenter
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    placeholderText: qsTr("m/min")
                                    Layout.preferredWidth: groupBoxImpression.width * 0.5
                                    Layout.preferredHeight: centralRow.componentHeight
                                    unit: "m/min"
                                    min: 1
                                    max: 400
                                    offset: 6/100 // convertisseur mm/s -> m/min
                                    nodeId: "Arp.Plc.Eclr/vitesseMaitreFour2"
                                    visible: !playPauseButton.visible
                                    enabled: false

                                }

                                NumericInput {
                                    id: textFieldConsigneVitesseFours
                                    horizontalAlignment: Text.AlignHCenter
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    placeholderText: qsTr("m/min")
                                    Layout.preferredWidth: groupBoxImpression.width * 0.5
                                    Layout.preferredHeight: centralRow.componentHeight
                                    unit: "m/min"
                                    min: 1
                                    max: 400
                                    offset: 6/100 // convertisseur mm/s -> m/min
                                    nodeId: "ns=6;s=Arp.Plc.Eclr/consigneVitesseMaitreFours"
                                    visible: playPauseButton.visible
                                    enabled: false

                                }
                            }

                            Rectangle {
                                Layout.alignment: Qt.AlignHCenter
                                Layout.preferredWidth: groupBoxImpression.width / 1.5
                                height: 1 * Constants.scaleFactor
                                gradient: Gradient {
                                    orientation: Gradient.Horizontal
                                    GradientStop { position : 0.0; color: "transparent" }
                                    GradientStop { position : 0.25; color: appTheme.bodyText }
                                    GradientStop { position : 0.75; color: appTheme.bodyText}
                                    GradientStop { position : 1.0; color: "transparent" }
                                }
                            }

                            GridLayout {
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                                columns: 2
                                rowSpacing: Constants.spacing * 2
                                columnSpacing: Constants.spacing

                                Label {
                                    text: qsTr("Séchage IR")
                                    color: appTheme.bodyText
                                    font.pixelSize: 18 * Constants.scaleFactor
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                                }

                                CustomSwitch {
                                    id: switchStartIR
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    Layout.preferredWidth: height * 2
                                    Layout.preferredHeight: centralRow.componentHeight
                                    enabled: false
                                    onClicked: {
                                        toggleCM(4, 6)
                                    }
                                }

                                ScenarioButton {
                                    id: scenarioFoursIR
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    Layout.preferredWidth: textFieldConsigneVitesseFours.width * 1.4
                                    Layout.preferredHeight: centralRow.componentHeight
                                    labelText: "Remplir Fours IR"
                                    runningText: "Remplissage\nFours IR..."
                                    Layout.columnSpan: 2
                                    nodeIdExec: "ns=6;s=Arp.Plc.Eclr/startMonteeVerinsFourIR"
                                    nodeIdEnd: "ns=6;s=Arp.Plc.Eclr/monteeVerinsFourIRDone"
                                    endValue: true
                                    nodeIdReset: "ns=6;s=Arp.Plc.Eclr/razMonteeVerinsFourIR"
                                    razButton: true
                                    enabled: false
                                }

                                ScenarioButton {
                                    id: scenarioFour2
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    Layout.preferredWidth: scenarioFoursIR.width
                                    Layout.preferredHeight: centralRow.componentHeight
                                    labelText: "Remplir Four 2"
                                    runningText: "Remplissage\nFour 2..."
                                    nodeIdExec: "ns=6;s=Arp.Plc.Eclr/remplirFour2"
                                    nodeIdEnd: "ns=6;s=Arp.Plc.Eclr/tapisPleinMBCognexFour2"
                                    endValue: 0
                                    Layout.columnSpan: 2
                                    enabled: false
                                }
                            }

                        }

                    }

                    ColumnLayout {
                        Item {
                            Layout.preferredHeight: groupBoxImpression.height / 4
                        }

                        ChainAsservissement {
                            id: chainAsservissement3
                            Layout.alignment: Qt.AlignTop
                            width: 120 * Constants.scaleFactor
                            height: 60 * Constants.scaleFactor
                            onCheckedChanged: onPlayPauseChecked(chainAsservissement3)
                        }

                        Item {
                            Layout.fillHeight: true
                        }
                    }

                    StyledFrame {
                        style: "shadowed"
                        id: groupBoxBobinoir
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        Layout.margins: 10 * Constants.scaleFactor
                        Layout.preferredWidth: groupBoxImpression.width
                        shadowColor: manualModeButton.checked ?
                                         "#deae2a" :
                                         switchStartStopBobibnoir.checked || (chainAsservissement3.checked && playPauseButton.checked) ?
                                             "#0FFF35" :
                                             "black"

                        ColumnLayout {
                            spacing: Constants.spacing * 2
                            anchors.fill: parent

                            Label {
                                text: qsTr("Bobinage")
                                font.pixelSize: 35 * Constants.scaleFactor
                                color: appTheme.bodyText
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.bold: true
                                font.pointSize: 12
                            }

                            CustomPlayPause {
                                id: switchStartStopBobibnoir
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.preferredWidth: groupBoxImpression.width * 0.28
                                Layout.preferredHeight: width
                                nodeId: ""
                                enabled: false

                                MouseArea {
                                    id: playBobArea
                                    anchors.fill: parent
                                    onClicked: {
                                        onPlayPauseChecked(switchStartStopBobibnoir)
                                    }

                                    onPressed: switchStartStopBobibnoir.down = true
                                    onReleased: switchStartStopBobibnoir.down = false
                                    enabled: false
                                }
                            }

                            GridLayout {
                                id: gridConsigneBobinoir
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                                columns: 2
                                rowSpacing: Constants.spacing * 2
                                columnSpacing: Constants.spacing

                                Label {
                                    text: qsTr("Consigne")
                                    font.pixelSize: 18 * Constants.scaleFactor
                                    color: appTheme.bodyText
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    visible: !chainAsservissement3.checked
                                }
                                NumericInput {
                                    id: consigneTextFieldBobibnoir
                                    horizontalAlignment: Text.AlignHCenter
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    placeholderText: qsTr("m/min")
                                    Layout.preferredWidth: groupBoxImpression.width * 0.5
                                    Layout.preferredHeight: centralRow.componentHeight
                                    unit: "m/min"
                                    min: 1
                                    max: 1000
                                    nodeId: "Arp.Plc.Eclr/vitesseMaitreBobinoir"
                                    visible: !chainAsservissement3.checked
                                    enabled: false

                                }
                            }

                            Item {
                                id: placeholderBobinage
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.preferredHeight: currentHeight
                                visible: true

                                // Hauteur dynamique animée
                                property int currentHeight: 0

                                // Hauteur réelle du bouton
                                property int targetHeight: switchStartStopBobibnoir.height + gridConsigneBobinoir.height + gridConsigneBobinoir.rowSpacing

                                // Pour déclencher le comportement
                                property bool animate: chainAsservissement3.checked

                                onAnimateChanged: {
                                    if (animate) {
                                        // --- CAS "glissement vers le haut" ---
                                        placeholderBobinage.visible = true;
                                        switchStartStopBobibnoir.visible = false;
                                        gridConsigneBobinoir.visible = false;

                                        // on part de targetHeight → 0
                                        currentHeight = targetHeight;
                                        Qt.callLater(() => {
                                                         heightAnimationBob.to = 0;
                                                         heightAnimationBob.start();
                                                     });

                                    } else {
                                        // --- CAS "glissement vers le bas" ---
                                        placeholderBobinage.visible = true;
                                        currentHeight = 0;

                                        Qt.callLater(() => {
                                                         heightAnimationBob.to = targetHeight;
                                                         heightAnimationBob.start();
                                                     });
                                    }
                                }

                                PropertyAnimation {
                                    id: heightAnimationBob
                                    target: placeholderBobinage
                                    property: "currentHeight"
                                    duration: 150
                                    easing.type: Easing.InOutQuad

                                    onStopped: {
                                        if (!placeholderBobinage.animate) {
                                            // On cache le placeholderPreTrait une fois l'animation vers le bas terminée
                                            placeholderBobinage.visible = false;
                                            switchStartStopBobibnoir.visible = true;
                                            gridConsigneBobinoir.visible = true
                                        }
                                    }
                                }
                            }

                            Rectangle {
                                Layout.alignment: Qt.AlignHCenter
                                Layout.preferredWidth: groupBoxImpression.width / 1.5
                                height: 1 * Constants.scaleFactor
                                gradient: Gradient {
                                    orientation: Gradient.Horizontal
                                    GradientStop { position : 0.0; color: "transparent" }
                                    GradientStop { position : 0.25; color: appTheme.bodyText }
                                    GradientStop { position : 0.75; color: appTheme.bodyText}
                                    GradientStop { position : 1.0; color: "transparent" }
                                }
                            }

                            GridLayout {
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                                columns: 2
                                rowSpacing: Constants.spacing * 2
                                columnSpacing: Constants.spacing

                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: "Vitesse"
                                    font.pixelSize: Constants.sp(18)
                                    horizontalAlignment: Text.AlignHCenter
                                    color: appTheme.bodyText
                                }

                                NumericInput {
                                    id: vitesseBobinoir
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.preferredWidth: groupBoxImpression.width * 0.5
                                    Layout.preferredHeight: centralRow.componentHeight
                                    Layout.minimumWidth:  Constants.dp(90)
                                    Layout.maximumHeight: Constants.dp(70)
                                    Layout.minimumHeight: Constants.dp(30)
                                    horizontalAlignment: Text.AlignHCenter
                                    readOnly: true
                                    unit: qsTr("m/min")
                                    digit: 1
                                    min: 0
                                    max: 1000
                                    nodeId: "Arp.Plc.Eclr/vitesseRoueBobinoir"
                                    font.pixelSize: Constants.sp(18)
                                    enabled: false
                                }

                                ScenarioButton {
                                    id: scenarioChangerBob
                                    Layout.alignment: Qt.AlignHCenter
                                    labelText: "Changer Bobines"
                                    runningText: "Changement\ndes bobines..."
                                    Layout.preferredWidth: scenarioFoursIR.width
                                    Layout.preferredHeight: centralRow.componentHeight
                                    nodeIdExec: "Arp.Plc.Eclr/windingEnd"
                                    nodeIdEnd: "Arp.Plc.Eclr/etatBobinoir"
                                    endValue: 0
                                    Layout.columnSpan: 2
                                    enabled: false
                                }
                            }
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

    Connections {
        target: btnCantre
        function onClicked() {
            rootApp.pageChanged(rootApp.sliderBtnCantre)
        }
    }

    Connections {
        target: btnPT
        function onClicked() {
            rootApp.pageChanged(rootApp.sliderBtnPT)
        }
    }

    Connections {
        target: btnFour1
        function onClicked() {
            rootApp.pageChanged(rootApp.sliderBtnFour)
        }
    }

    Connections {
        target: btnIR
        function onClicked() {
            rootApp.pageChanged(rootApp.sliderBtnIR)
        }
    }

    Connections {
        target: btnImpression
        function onClicked() {
            rootApp.pageChanged(rootApp.sliderBtnImpression)
        }
    }

    Connections {
        target: btnFour2
        function onClicked() {
            rootApp.pageChanged(rootApp.sliderBtnFour)
        }
    }

    Connections {
        target: btnBob
        function onClicked() {
            rootApp.pageChanged(rootApp.sliderBtnBobinoir)
        }
    }

    function inverserBit(numeroBit) {
        // Vérifie que le numéro de bit est bien entre 1 et 16
        if (numeroBit < 1 || numeroBit > 16) {
            throw new Error("Le numéro de bit doit être compris entre 1 et 16.")
        }

        // Convertit l'entier en binaire sur 16 bits
        let binaire = (lgl.erreurID >>> 0).toString(2).padStart(16, '0')

        // Inverse le bit spécifié
        let index = 16 - numeroBit; // Calcul de l'index du bit à inverser

        let nouveauBinaire = binaire.substr(0, index) +
            (binaire[index] === '0' ? '1' : '0') +
            binaire.substr(index + 1);

        // Convertit le nouveau binaire en entier
        let nouvelEntier = parseInt(nouveauBinaire, 2);

        return nouvelEntier;
    }
}
