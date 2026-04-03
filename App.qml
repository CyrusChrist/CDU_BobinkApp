// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

import QtQuick
import QtQuick.Shapes
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Bobink
import "./Resources/Components"
import "./Pages"

ApplicationWindow {
    id: mainWindow
    width: 1500
    height: 900

    StackView {
        id: stack
        anchors.fill: parent

        pushEnter: null; pushExit: null; popEnter: null; popExit: null; replaceEnter: null; replaceExit: null

        initialItem: machineSelectionComponent
    }

    function getScreen(){
        console.log("Écran courant :", Screen.name)
        console.log("Largeur écran :", Screen.width)
        console.log("Hauteur écran :", Screen.height)
        console.log("DPI logique :", Screen.pixelDensity * 25.4) // conversion en DPI
        console.log("Scale Factor before :", Constants.scaleFactor)
        Constants.refreshScaleFactor()
        console.log("Scale Factor after :", Constants.scaleFactor)
    }
    onWidthChanged: { getScreen() }
    onHeightChanged: { getScreen() }
    onScreenChanged:  {
        Constants.window = mainWindow
        getScreen()
    }
    AppTheme {
        id: appTheme
    }
    Component.onCompleted: {
        Constants.window = mainWindow
        getScreen()
        appTheme.setDarkTheme()
    }
    visible: true
    visibility: Constants.fullScreen ? Window.FullScreen : Window.Maximized

    title: "Bobink"

    Component {
        id: machineSelectionComponent
        MachineSelection {}
    }

    Component {
        id: loadingComponent
        LoadingScreen {}
    }

    Component {
        id: mainComponent

        Item {
            id: rootApp

            property bool slideMenuActive: true
            property bool slideMenuHovered: false

            property alias sliderBtnCantre: sliderBtnCantre
            property alias sliderBtnPT: sliderBtnPT
            property alias sliderBtnFour: sliderBtnFour
            property alias sliderBtnImpression: sliderBtnImpression
            property alias sliderBtnIR: sliderBtnIR
            property alias sliderBtnBobinoir: sliderBtnBobinoir

            signal pageChanged(Item pageId)

            onPageChanged: (pageId) => {
                               pageId.clicked()
                               pageId.checked = true
                           }

            // Component.onCompleted:appTheme.setDarkTheme()

            // ------------------- EM TOGGLE ------------------------
            // ------------------------------------------------------

            function toggleEM(emIndex) {
                var newMask
                if (Constants.emInactiveMask & (1 << emIndex)) {
                    newMask = Constants.emInactiveMask | (1 << emIndex)
                } else {
                    newMask = Constants.emInactiveMask & ~(1 << emIndex)
                }
                nodeEMInactiveMask.writeValue(Number(newMask))
                Constants.emInactiveMask = newMask
            }

            // desactivate all EM, except EM8 : CHAUFFE
            function desactivateAllEMs() {
                nodeEMInactiveMask.writeValue(Number(0xFEFF))
                Constants.emInactiveMask = 0xFEFF
            }

            // activate all EM : [1, 2, 3, 8] -> Part 1
            function activateAllEMs() {
                nodeEMInactiveMask.writeValue(Number(0xFEF1))
                Constants.emInactiveMask = 0xFEF1
            }

            function deactivateAllCMs(emIndex) {
                nodeCMInactiveMasks.itemAt(emIndex).opcNode.writeValue(Number(0xFFFF))
                var newMasks = Constants.cmInactiveMasks.slice()
                newMasks[emIndex] = 0xFFFF
                Constants.cmInactiveMasks = newMasks
            }

            function activateAllCMsBuffered(emIndex) {
                nodeCMInactiveMasks.itemAt(emIndex).opcNode.writeValue(Number(Constants.cmInactiveMasksManuelBuffer[emIndex]))
                var newMasks = Constants.cmInactiveMasks.slice()
                newMasks[emIndex] = Constants.cmInactiveMasksManuelBuffer[emIndex]
                Constants.cmInactiveMasks = newMasks
            }

            OpcUaMonitoredNode {
                id: nodeEMInactiveMask
                nodeId: "ns=6;s=Arp.Plc.Eclr/UN00_Modules.EM_InactiveMask"
                monitored: true
                onValueChanged: if (value !== "¿") Constants.emInactiveMask = value
                onWriteCompleted: (success, message, writtenValue) => console.log("OpcUaMonitoredNode: " + nodeId + " = " + writtenValue + " (" + message + ")")
            }

            Repeater {
                id: nodeCMInactiveMasks
                model: 9
                delegate: Item {
                    property alias opcNode: innerCMInactiveMask
                    OpcUaMonitoredNode {
                        id: innerCMInactiveMask
                        property int emIndex: index
                        nodeId: "ns=6;s=Arp.Plc.Eclr/UN00_Modules.EM[" + index + "].CM_InactiveMask"
                        monitored: true
                        onValueChanged: {
                            if (value !== "¿") {
                                var newMasks = Constants.cmInactiveMasks.slice()
                                newMasks[emIndex] = value
                                Constants.cmInactiveMasks = newMasks
                            }
                        }
                        onWriteCompleted: (success, message, writtenValue) => console.log("OpcUaMonitoredNode: " + nodeId + " = " + writtenValue + " (" + message + ")")
                    }
                }

            }

            // ------------------- MODE MANUEL ------------------------
            // --------------------------------------------------------

            property string currentMode: "R&D"

            onCurrentModeChanged: {
                let modeManueActive = currentMode === "Manuel"

                home.manualModeButton.checked = modeManueActive
                cantreMaintenance.manuelCantreBtn.checked = modeManueActive
                preTraitementMaintenance.manuelPreTraitementButton.checked = modeManueActive
                fourMaintenance.manualModeButton.checked = modeManueActive

                if (modeManueActive) {
                    Constants.cmInactiveMasksManuelBuffer = Constants.cmInactiveMasks
                    Constants.cmInactiveMasks = [
                                0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF,
                                0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF,
                                0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF,
                                0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF
                            ]
                    for (var i=0; i < 9; i++) {
                        deactivateAllCMs(i)
                    }

                    rootApp.openNewNotif(2, "Passage au mode Manuel",
                                                "Mise hors tension des axes",
                                                "Info", "#deae2a", true)
                    if ([3,4,5,6,10,11,12,13,14,15,16,17].includes(home.currentState)) {
                        home.writeNode(home.nodeCmdStop, true)
                    }
                    desactivateAllEMs()

                } else {
                    Constants.cmInactiveMasks = Constants.cmInactiveMasksManuelBuffer
                    activateAllEMs()
                    for (var j=0; j < 9; j++) {
                        activateAllCMsBuffered(j)
                    }
                    rootApp.openNewNotif(2, "Passage au mode R&D",
                                                "Machine en veille",
                                                "Info", "#555", true)
                }
            }


            ConnexionPopup {
                id: connexionPopup
                btnState: 0
                btnText: qsTr("Retour")

                onBtnStateChanged: {
                    if (stack.currentItem !== machineSelectionComponent) { stack.push(machineSelectionComponent) }
                    connexionPopup.close()
                }
            }

            Connections {
                id: proxyConnection
                target: Bobink

                property bool proxyConnect: false // variable to check if the proxy is already disconnected, that way it won't open the disconnection message 2 times

                // onProxyConnected: () => {
                //                       console.log("PROXY CONNECTED")
                //                       connexionPopup.close()
                //                       proxyConnection.proxyConnect = true
                //                   }
                // onProxyDisconnected: () => {
                //                          console.log("TRYING PROXY DISCONNECTION")
                //                          if (proxyConnection.proxyConnect && !connexionPopup.opened) {
                //                              console.log("PROXY DISCONNECTED")
                //                              // stack.push(machineSelectionComponent)
                //                              connexionPopup.open()

                //                              proxyConnection.proxyConnect = false
                //                          }
                //                      }
            }

            Popup {
                id: deconnexionPopup
                modal: true
                focus: true
                closePolicy: Popup.CloseOnPressOutside
                height: parent.height * 0.2
                width: parent.width * 0.2
                anchors.centerIn: parent

                ColumnLayout {
                    anchors.fill: parent
                    spacing: Constants.dp(20)

                    Label {
                        text: qsTr("Quitter vers l'usine ?")
                        Layout.alignment: Qt.AlignHCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.bold: true
                        font.pixelSize: Constants.sp(32)
                        color: appTheme.bodyText
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.fillWidth: true
                        spacing: Constants.dp(20)

                        ModuleButton {
                            labelText: qsTr("Déconnexion")
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredWidth: Constants.dp(150)
                            Layout.preferredHeight: Constants.dp(55)
                            btnColor: "#B65151"
                            onClicked: {
                                stack.push(machineSelectionComponent)
                                deconnexionPopup.close()
                            }
                        }

                        ModuleButton {
                            labelText: qsTr("Annuler")
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredWidth: Constants.dp(100)
                            Layout.preferredHeight: Constants.dp(55)
                            onClicked: deconnexionPopup.close()
                        }
                    }
                }

                background: Rectangle {
                    color: appTheme.backgroundColor
                    border.color: Qt.lighter(color, 1.5)
                    border.width: Constants.dp(3)
                    radius: Constants.dp(15)
                }
            }

            ColumnLayout {
                spacing: 0

                Frame {
                    id: frameMainScreen
                    padding: 0
                    background: Rectangle {
                        anchors.fill: parent
                        color: appTheme.gradientMid
                    }

                    RowLayout {
                        spacing: 0

                        MenuFrame {
                            id: frameMenuSlider
                            Layout.preferredHeight: mainWindow.height
                            Layout.preferredWidth: slideMenuActive ?
                                                       mainWindow.width * 0.138
                                                     : mainWindow.width * 0.075
                            padding: Layout.preferredWidth * 0.1

                            Behavior on Layout.preferredWidth {
                                NumberAnimation {
                                    duration: 150
                                    easing.type: Easing.InOutQuad
                                }
                            }

                            ColumnLayout {
                                id: menuSliderColumn
                                spacing: Constants.dp(8)
                                anchors.fill: parent

                                RowLayout {
                                    spacing: Constants.dp(8)
                                    Layout.alignment: Qt.AlignHCenter

                                    MenuButton {
                                        id: sliderFactoryBtn
                                        buttonImage: "../Images/MENU_factory.svg"
                                        labelText: qsTr("Usine")
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: mainWindow.height * 0.06
                                        Layout.preferredWidth: menuSliderColumn.width * 0.55
                                        mainBtn: true
                                        onClicked: {
                                            deconnexionPopup.open()
                                        }
                                    }

                                    Image {
                                        sourceSize: Qt.size(width, height)
                                        id: logoImage
                                        source: "Resources/Images/BobinkLogo.svg"
                                        Layout.preferredHeight: slideMenuActive ?
                                                                    frameMenuSlider.width * 0.3 :
                                                                    frameMenuSlider.width * 0.55
                                        Layout.preferredWidth: slideMenuActive ?
                                                                   frameMenuSlider.width * 0.3 :
                                                                   frameMenuSlider.width * 0.55

                                        transform: Rotation {
                                            id: logoRotation
                                            origin.x: logoImage.implicitWidth / 2
                                            origin.y: logoImage.implicitHeight / 2
                                            axis { x: 0; y: 0; z: 1 }
                                            angle: 0
                                        }

                                        // Réajustement dynamique de l'origine si taille explicite
                                        Component.onCompleted: {
                                            logoRotation.origin.x = logoImage.width / 2
                                            logoRotation.origin.y = logoImage.height / 2
                                        }

                                        onWidthChanged: logoRotation.origin.x = logoImage.width / 2
                                        onHeightChanged: logoRotation.origin.y = logoImage.height / 2

                                        Behavior on Layout.preferredWidth {
                                            NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
                                        }
                                        Behavior on Layout.preferredHeight {
                                            NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
                                        }

                                        states: [
                                            State {
                                                name: "expanded"
                                                when: slideMenuActive
                                                PropertyChanges { target: logoRotation; angle: 90 }
                                            },
                                            State {
                                                name: "collapsed"
                                                when: !slideMenuActive
                                                PropertyChanges { target: logoRotation; angle: 0 }
                                            }
                                        ]

                                        transitions: Transition {
                                            NumberAnimation { properties: "angle"; duration: 150; easing.type: Easing.InOutQuad }
                                        }
                                    }
                                }

                                Rectangle {
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.preferredWidth: frameMenuSlider.width / 1.5
                                    height: 1
                                    gradient: Gradient {
                                        orientation: Gradient.Horizontal
                                        GradientStop { position : 0.0; color: "transparent" }
                                        GradientStop { position : 0.25; color: appTheme.bodyText }
                                        GradientStop { position : 0.75; color: appTheme.bodyText}
                                        GradientStop { position : 1.0; color: "transparent" }
                                    }
                                }

                                ButtonGroup {
                                    id: menuSliderButtons
                                }

                                ButtonGroup {
                                    id: menuSliderExtendableButtons
                                }

                                MenuButton {
                                    id: sliderExtendMachine
                                    buttonImage: "../Images/MENU_machine.svg"
                                    labelText: qsTr("Bobink 2")
                                    ButtonGroup.group: menuSliderExtendableButtons
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: mainWindow.height * 0.06
                                    Layout.preferredWidth: parent.width
                                    checked: true
                                    extendable: true
                                    mainBtn: true
                                    onClicked: { if (checked) { sliderHomeBtn.click() } }
                                }

                                Item {
                                    id: placeholderExtendMachine
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    Layout.preferredHeight: currentHeight
                                    visible: false

                                    // Hauteur dynamique animée
                                    property int currentHeight: 0

                                    // Hauteur réelle du bouton
                                    property int targetHeight: sliderHomeBtn.height * 8 + menuSliderColumn.spacing * 9 + separatingLigne.height

                                    // Pour déclencher le comportement
                                    property bool animate: !sliderExtendMachine.checked

                                    onAnimateChanged: {
                                        if (animate) {
                                            // --- CAS "glissement vers le haut" ---
                                            placeholderExtendMachine.visible = true;
                                            sliderHomeBtn.visible = false;
                                            sliderBtnCantre.visible = false;
                                            sliderBtnPT.visible = false;
                                            sliderBtnFour.visible = false;
                                            sliderBtnIR.visible = false;
                                            sliderBtnImpression.visible = false;
                                            sliderBtnBobinoir.visible = false;
                                            sliderBtnSystem.visible = false;

                                            // on part de targetHeight → 0
                                            currentHeight = targetHeight;
                                            Qt.callLater(() => {
                                                             heightAnimationExtendMachine.to = 0;
                                                             heightAnimationExtendMachine.start();
                                                         });

                                        } else {
                                            // --- CAS "glissement vers le bas" ---
                                            placeholderExtendMachine.visible = true;
                                            currentHeight = 0;

                                            Qt.callLater(() => {
                                                             heightAnimationExtendMachine.to = targetHeight;
                                                             heightAnimationExtendMachine.start();
                                                         });
                                        }
                                    }

                                    PropertyAnimation {
                                        id: heightAnimationExtendMachine
                                        target: placeholderExtendMachine
                                        property: "currentHeight"
                                        duration: 250
                                        easing.type: Easing.InOutQuad

                                        onStopped: {
                                            if (!placeholderExtendMachine.animate) {
                                                // On cache le placeholderExtendMachine une fois l'animation vers le bas terminée
                                                placeholderExtendMachine.visible = false;
                                                sliderHomeBtn.visible = true;
                                                sliderBtnCantre.visible = true;
                                                sliderBtnPT.visible = true;
                                                sliderBtnFour.visible = true;
                                                sliderBtnIR.visible = true;
                                                sliderBtnImpression.visible = true;
                                                sliderBtnBobinoir.visible = true;
                                                sliderBtnSystem.visible = true;
                                            } else {
                                                placeholderExtendMachine.visible = false;
                                            }
                                        }
                                    }
                                }

                                MenuButton {
                                    id: sliderHomeBtn
                                    buttonImage: "../Images/MENU_home.svg"
                                    ButtonGroup.group: menuSliderButtons
                                    labelText: qsTr("Home")
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: mainWindow.height * 0.06
                                    Layout.preferredWidth: parent.width
                                    checked: true
                                    manuelOn: home.manualModeButton.checked
                                    onClicked: {
                                        stackLayoutPage.currentIndex = 0
                                    }
                                    visible: sliderExtendMachine.checked
                                }
                                MenuButton {
                                    id: sliderBtnCantre
                                    buttonImage: "../Images/MENU_cantre.svg"
                                    ButtonGroup.group: menuSliderButtons
                                    labelText: qsTr("Cantre")
                                    Layout.preferredWidth: parent.width
                                    Layout.preferredHeight: sliderHomeBtn.height
                                    Layout.fillWidth: true
                                    onClicked: {
                                        stackLayoutPage.currentIndex = 1
                                    }
                                    visible: sliderExtendMachine.checked
                                    manuelOn: cantreMaintenance.manuelCantreBtn.checked
                                }
                                MenuButton {
                                    id: sliderBtnPT
                                    buttonImage: "../Images/MENU_pretraitement.svg"
                                    ButtonGroup.group: menuSliderButtons
                                    labelText: qsTr("Pré-Traitement")
                                    Layout.preferredWidth: parent.width
                                    Layout.preferredHeight: sliderHomeBtn.height
                                    Layout.fillWidth: true
                                    visible: sliderExtendMachine.checked
                                    manuelOn: preTraitementMaintenance.manuelPreTraitementButton.checked
                                    onClicked: {
                                        stackLayoutPage.currentIndex = 2
                                    }

                                }
                                MenuButton {
                                    id: sliderBtnFour
                                    buttonImage: "../Images/MENU_four.svg"
                                    ButtonGroup.group: menuSliderButtons
                                    labelText: qsTr("Fours")
                                    Layout.preferredWidth: parent.width
                                    Layout.preferredHeight: sliderHomeBtn.height
                                    Layout.fillWidth: true
                                    visible: sliderExtendMachine.checked
                                    manuelOn: fourMaintenance.manualModeButton.checked
                                    onClicked: {
                                        stackLayoutPage.currentIndex = 3
                                    }
                                }
                                MenuButton {
                                    id: sliderBtnIR
                                    buttonImage: "../Images/MENU_IR.svg"
                                    ButtonGroup.group: menuSliderButtons
                                    labelText: qsTr("IR")
                                    Layout.preferredWidth: parent.width
                                    Layout.preferredHeight: sliderHomeBtn.height
                                    Layout.fillWidth: true
                                    visible: sliderExtendMachine.checked
                                    manuelOn: irMaintenance.manuelIRButton.checked
                                    onClicked: {
                                        stackLayoutPage.currentIndex = 4
                                    }
                                }
                                MenuButton {
                                    id: sliderBtnImpression
                                    buttonImage: "../Images/MENU_impression.svg"
                                    ButtonGroup.group: menuSliderButtons
                                    labelText: qsTr("Impression")
                                    Layout.preferredWidth: parent.width
                                    Layout.preferredHeight: sliderHomeBtn.height
                                    visible: sliderExtendMachine.checked
                                    onClicked: {
                                        stackLayoutPage.currentIndex = 5
                                    }
                                }
                                MenuButton {
                                    id: sliderBtnBobinoir
                                    buttonImage: "../Images/MENU_bobinoir.svg"
                                    ButtonGroup.group: menuSliderButtons
                                    labelText: qsTr("Bobinoir")
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: sliderHomeBtn.height
                                    visible: sliderExtendMachine.checked
                                    manuelOn: bobinoir.manuelBobinoirButton.checked
                                    onClicked: {
                                        stackLayoutPage.currentIndex = 6
                                        // opcuaNodeInactiveMasks.emIndex = 7

                                    }
                                }

                                MenuButton {
                                    id: sliderBtnSystem
                                    buttonImage: "../Images/MENU_systeme.svg"
                                    ButtonGroup.group: menuSliderButtons
                                    labelText: qsTr("Systeme")
                                    Layout.preferredHeight: sliderHomeBtn.height
                                    Layout.preferredWidth: parent.width
                                    visible: sliderExtendMachine.checked
                                    onClicked: {
                                        stackLayoutPage.currentIndex = 7

                                    }
                                }

                                Rectangle {
                                    id: separatingLigne
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.preferredWidth: frameMenuSlider.width / 1.5
                                    height: 1
                                    gradient: Gradient {
                                        orientation: Gradient.Horizontal
                                        GradientStop { position : 0.0; color: "transparent" }
                                        GradientStop { position : 0.25; color: appTheme.bodyText }
                                        GradientStop { position : 0.75; color: appTheme.bodyText}
                                        GradientStop { position : 1.0; color: "transparent" }
                                    }
                                    visible: sliderExtendMachine.checked
                                }

                                MenuButton {
                                    id: sliderExtendJob
                                    buttonImage: "../Images/MENU_jobs.svg"
                                    labelText: qsTr("Tâches")
                                    ButtonGroup.group: menuSliderExtendableButtons
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: mainWindow.height * 0.06
                                    Layout.preferredWidth: parent.width
                                    extendable: true
                                    mainBtn: true
                                    // onClicked: { if (checked) { sliderBtnJobList.click() } }
                                }

                                Item {
                                    id: placeholderExtendJob
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    Layout.preferredHeight: currentHeight
                                    visible: true

                                    // Hauteur dynamique animée
                                    property int currentHeight: 0

                                    // Hauteur réelle du bouton
                                    property int targetHeight: sliderBtnJobList.height * 2 + menuSliderColumn.spacing * 3 + separatingLigne.height

                                    // Pour déclencher le comportement
                                    property bool animate: !sliderExtendJob.checked

                                    onAnimateChanged: {
                                        if (animate) {
                                            // --- CAS "glissement vers le haut" ---
                                            placeholderExtendJob.visible = true;
                                            sliderBtnJobList.visible = false;
                                            sliderBtnJobHistory.visible = false;

                                            // on part de targetHeight → 0
                                            currentHeight = targetHeight;
                                            Qt.callLater(() => {
                                                             heightAnimationExtendJob.to = 0;
                                                             heightAnimationExtendJob.start();
                                                         });

                                        } else {
                                            // --- CAS "glissement vers le bas" ---
                                            placeholderExtendJob.visible = true;
                                            separatingLigneJob.visible = true;
                                            currentHeight = 0;

                                            Qt.callLater(() => {
                                                             heightAnimationExtendJob.to = targetHeight;
                                                             heightAnimationExtendJob.start();
                                                         });
                                        }
                                    }

                                    PropertyAnimation {
                                        id: heightAnimationExtendJob
                                        target: placeholderExtendJob
                                        property: "currentHeight"
                                        duration: 180
                                        easing.type: Easing.InOutQuad

                                        onStopped: {
                                            if (!placeholderExtendJob.animate) {
                                                placeholderExtendJob.visible = false;
                                                sliderBtnJobList.visible = true;
                                                sliderBtnJobHistory.visible = true;
                                            } else {
                                                placeholderExtendJob.visible = false;
                                                separatingLigneJob.visible = false
                                            }
                                        }
                                    }
                                }

                                MenuButton {
                                    id: sliderBtnJobList
                                    buttonImage: "../Images/MENU_jobList.svg"
                                    ButtonGroup.group: menuSliderButtons
                                    labelText: qsTr("Liste des tâches")
                                    Layout.preferredWidth: parent.width
                                    Layout.preferredHeight: sliderHomeBtn.height
                                    visible: sliderExtendJob.checked
                                    onClicked: {
                                        stackLayoutPage.currentIndex = 14

                                    }
                                }
                                MenuButton {
                                    id: sliderBtnJobHistory
                                    buttonImage: "../Images/MENU_jobHistory.svg"
                                    ButtonGroup.group: menuSliderButtons
                                    labelText: qsTr("Historique")
                                    Layout.preferredWidth: parent.width
                                    Layout.preferredHeight: sliderHomeBtn.height
                                    visible: sliderExtendJob.checked
                                    onClicked: {
                                        stackLayoutPage.currentIndex = 15
                                    }
                                }
                                Rectangle {
                                    id: separatingLigneJob
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.preferredWidth: frameMenuSlider.width / 1.5
                                    height: 1
                                    gradient: Gradient {
                                        orientation: Gradient.Horizontal
                                        GradientStop { position : 0.0; color: "transparent" }
                                        GradientStop { position : 0.25; color: appTheme.bodyText }
                                        GradientStop { position : 0.75; color: appTheme.bodyText}
                                        GradientStop { position : 1.0; color: "transparent" }
                                    }
                                }

                                Frame {
                                    id: jobFrame
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    bottomPadding: 0//padding * 0.5

                                    property bool shouldMergeJob: false

                                    property real emptyHeight: availableHeight - jobTitleLabel.height - Constants.dp(8)
                                    property real fusionHeight: jobFirstPage.occupiedHeight + jobSecondPage.occupiedHeight + jobThirdPage.occupiedHeight + fusionJobColumn.spacing * 2

                                    onEmptyHeightChanged: {
                                        // console.log(emptyHeight + " vs " + fusionHeight)
                                        if (emptyHeight < fusionHeight) {
                                            shouldMergeJob = false
                                        } else {
                                            shouldMergeJob = true
                                        }
                                    }

                                    background: Rectangle {
                                        color: Qt.lighter(appTheme.gradientMid, 1.3)
                                        radius: Constants.dp(10)
                                    }

                                    Item {
                                        id: jobFirstPage
                                        width: parent.width
                                        height: parent.height
                                        parent: jobPage1

                                        property real occupiedHeight: jobId.height + jobColor.height + jobProgress.height + 2 * Constants.dp(4)

                                        ColumnLayout {
                                            Layout.fillWidth: true
                                            spacing: Constants.dp(4)

                                            Label {
                                                id: jobId
                                                Layout.alignment: Qt.AlignLeft
                                                text: qsTr("Cotton_1070_2/50")
                                                font.bold: true
                                                font.pixelSize: Constants.sp(17)
                                                color: appTheme.bodyText

                                            }

                                            RowLayout {
                                                id: jobColor
                                                spacing: Constants.dp(8)

                                                Rectangle {
                                                    Layout.alignment: Qt.AlignVCenter
                                                    Layout.preferredWidth: jobFirstPage.width * 0.12
                                                    Layout.preferredHeight: width
                                                    color: "#ff4400"
                                                    radius: width / 4
                                                }

                                                Text {
                                                    Layout.alignment: Qt.AlignVCenter
                                                    text: qsTr("Orange préféré")
                                                    font.bold: false
                                                    font.pixelSize: Constants.sp(17)
                                                    color: appTheme.bodyText

                                                }

                                            }

                                            GaugeProgress {
                                                id: jobProgress
                                                Layout.preferredWidth: jobFirstPage.width * 0.88
                                                Layout.preferredHeight: width * 0.1
                                                nodeId: "%CurrentJob"
                                                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                                                value: 12
                                                fontSize: Constants.sp(18)
                                                unit: "%"
                                                style: "rectangle"
                                            }
                                        }

                                    }
                                    Item {
                                        id: jobSecondPage
                                        width: parent.width
                                        height: parent.height
                                        parent: jobPage2

                                        property real occupiedHeight: timeDisplay.height + timerBtnRow.height + Constants.dp(8)
                                        property int elapsedMs: 0

                                        Timer {
                                            id: timerJob
                                            interval: 1000
                                            repeat: true
                                            running: false
                                            onTriggered: jobSecondPage.elapsedMs += interval
                                        }

                                        ColumnLayout {
                                            spacing: Constants.dp(8)
                                            anchors.horizontalCenter: parent.horizontalCenter

                                            Label {
                                                id: timeDisplay
                                                Layout.alignment: Qt.AlignHCenter
                                                text: {
                                                    let totalSeconds = Math.floor(jobSecondPage.elapsedMs / 1000)
                                                    let hours = Math.floor(totalSeconds / 3600).toString().padStart(2, "0")
                                                    let minutes = Math.floor((totalSeconds % 3600) / 60).toString().padStart(2, "0")
                                                    let seconds = (totalSeconds % 60).toString().padStart(2, "0")
                                                    return hours + ":" + minutes + ":" + seconds
                                                }

                                                font.pixelSize: Constants.sp(20)
                                                color: appTheme.bodyText

                                            }

                                            RowLayout {
                                                id: timerBtnRow
                                                Layout.alignment: Qt.AlignHCenter
                                                spacing: Constants.dp(8)

                                                ModuleButton {
                                                    Layout.preferredHeight: Constants.dp(40)
                                                    Layout.preferredWidth: jobSecondPage.width * 0.45
                                                    labelText: timerJob.running ? "Pause" : "Start"
                                                    onClicked: timerJob.running = !timerJob.running
                                                }

                                                ModuleButton {
                                                    Layout.preferredHeight: Constants.dp(40)
                                                    Layout.preferredWidth: jobSecondPage.width * 0.45
                                                    labelText: "Reset"
                                                    onClicked: {
                                                        timerJob.running = false
                                                        jobSecondPage.elapsedMs = 0
                                                    }
                                                }
                                            }

                                        }

                                    }
                                    Item {
                                        id: jobThirdPage
                                        width: parent.width
                                        height: parent.height
                                        parent: jobPage3

                                        property real occupiedHeight: 2 * Constants.dp(8) + grammage.height + metrage.height + remainingTime.height

                                        ColumnLayout {
                                            spacing: Constants.dp(8)

                                            Label {
                                                id: grammage
                                                Layout.alignment: Qt.AlignLeft
                                                text: qsTr("122 kg / 1000 kg")
                                                font.bold: false
                                                font.pixelSize: Constants.sp(17)
                                                color: appTheme.bodyText
                                            }

                                            Label {
                                                id: metrage
                                                Layout.alignment: Qt.AlignLeft
                                                text: qsTr("64 m / 500 m")
                                                font.bold: false
                                                font.pixelSize: Constants.sp(17)
                                                color: appTheme.bodyText
                                            }

                                            Label {
                                                id: remainingTime
                                                horizontalAlignment: Text.AlignLeft
                                                verticalAlignment: Text.AlignVCenter
                                                wrapMode: Text.WordWrap
                                                text: qsTr("Temps restant : 03h 45m")
                                                font.bold: false
                                                font.pixelSize: Constants.sp(17)
                                                color: appTheme.bodyText
                                                Layout.alignment: Qt.AlignLeft
                                            }
                                        }
                                    }


                                    ColumnLayout {
                                        spacing: Constants.dp(8)
                                        anchors.fill: parent

                                        Label {
                                            id: jobTitleLabel
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            text: qsTr("Tâche en cours")
                                            font.bold: true
                                            font.pixelSize: Constants.sp(20)
                                            color: appTheme.bodyText
                                        }

                                        SwipeView {
                                            id: jobView
                                            currentIndex: 0
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true
                                            // Layout.minimumHeight: mainWindow.height * 0.25
                                            clip: true
                                            visible: !jobFrame.shouldMergeJob

                                            Item {
                                                id: jobPage1
                                                Layout.fillWidth: true
                                                Layout.fillHeight: true
                                            }
                                            Item {
                                                id: jobPage2
                                                Layout.fillWidth: true
                                                Layout.fillHeight: true
                                            }
                                            Item {
                                                id: jobPage3
                                                Layout.fillWidth: true
                                                Layout.fillHeight: true
                                            }

                                            onVisibleChanged: {
                                                if (!jobFrame.shouldMergeJob) {
                                                    jobFirstPage.parent = jobPage1
                                                    jobSecondPage.parent = jobPage2
                                                    jobThirdPage.parent = jobPage3
                                                }
                                            }
                                        }

                                        ColumnLayout {
                                            id: fusionJobColumn
                                            spacing: Constants.dp(15)
                                            visible: jobFrame.shouldMergeJob
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true

                                            Item {
                                                id: jobPage1Fusion
                                                Layout.fillWidth: true
                                                Layout.preferredHeight: jobFirstPage.occupiedHeight
                                            }
                                            Item {
                                                id: jobPage2Fusion
                                                Layout.fillWidth: true
                                                Layout.preferredHeight: jobSecondPage.occupiedHeight
                                            }
                                            Item {
                                                id: jobPage3Fusion
                                                Layout.fillWidth: true
                                                Layout.preferredHeight: jobThirdPage.occupiedHeight
                                            }

                                            Item { Layout.fillHeight: true }

                                            onVisibleChanged: {
                                                if (jobFrame.shouldMergeJob) {
                                                    jobFirstPage.parent = jobPage1Fusion
                                                    jobSecondPage.parent = jobPage2Fusion
                                                    jobThirdPage.parent = jobPage3Fusion
                                                }
                                            }
                                        }

                                        PageIndicator {
                                            id: jobPageInd
                                            count: jobView.count
                                            currentIndex: jobView.currentIndex
                                            visible: !jobFrame.shouldMergeJob

                                            Layout.alignment: Qt.AlignHCenter

                                            delegate: Rectangle {
                                                implicitWidth: index === jobPageInd.currentIndex ? jobView.width * 0.05 : jobView.width * 0.04
                                                implicitHeight: width
                                                anchors.verticalCenter: parent.verticalCenter

                                                radius: width / 2
                                                color: appTheme.pageIndColor

                                                opacity: index === jobPageInd.currentIndex ? 0.95 : pressed ? 0.7 : 0.45

                                                Behavior on opacity {
                                                    OpacityAnimator {
                                                        duration: 100
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }

                            }
                        }

                        ColumnLayout {
                            spacing: 0

                            Frame {
                                id: frameLoader
                                property int scaleX: 0
                                property int scaleY: 0

                                Layout.preferredHeight: mainWindow.height - frameAppBar.height
                                Layout.preferredWidth: mainWindow.width - frameMenuSlider.width

                                background: Item {
                                    anchors.fill: parent

                                    MultiEffect {
                                        anchors.fill: source
                                        source: liseretBlanc
                                        shadowEnabled: true
                                        shadowColor: "black"
                                        opacity: 0.3
                                    }

                                    Rectangle {
                                        id: liseretBlanc
                                        width: fondLoader.width + 0.4
                                        height: fondLoader.height
                                        anchors.right: fondLoader.right
                                        anchors.bottom: fondLoader.bottom
                                        topLeftRadius: fondLoader.topLeftRadius
                                        color: Qt.lighter(fondLoader.color, 1.8)
                                    }

                                    Rectangle {
                                        id: fondLoader
                                        topLeftRadius: 25
                                        anchors.fill: parent
                                        color: appTheme.backgroundColor
                                    }

                                }

                                StackLayout {
                                    id: stackLayoutPage
                                    currentIndex: 0
                                    anchors.fill: parent

                                    property int numeroCognex

                                    Home { // 0
                                        id: home
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                    }
                                    Cantre { // 1
                                        id: cantreMaintenance
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                    }
                                    PreTraitement { // 2
                                        id: preTraitementMaintenance
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                    }
                                    Fours { // 3
                                        id: fourMaintenance
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                    }
                                    IR { // 4
                                        id: irMaintenance
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                    }
                                    Impression { // 5
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                    }
                                    Bobinoir { // 6
                                        id: bobinoir
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                    }
                                    System { // 7
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                    }
                                    Schema { // 8
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                    }
                                    Ventilation { // 9
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                    }
                                    AxisSettings { // 10
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                    }
                                    WebEngine { // 11
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                    }
                                    Test { // 12
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                    }
                                    Notification { // 13
                                        id: notificationPage
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                    }
                                    JobList { // 14
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                    }
                                    JobHistory { // 15
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                    }

                                }

                            }

                            MenuFrame{
                                id: frameAppBar
                                z:1
                                hasShadow: true
                                Layout.preferredWidth: mainWindow.width - frameMenuSlider.width
                                Layout.preferredHeight: mainWindow.height * 0.15
                                padding: 10


                                RowLayout{
                                    spacing: 20
                                    anchors.fill: parent

                                    Item {
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                    }

                                    ColumnLayout {
                                        visible: false
                                        Label {
                                            text: "Asservissement"
                                            color: appTheme.bodyText
                                            font.pixelSize: Constants.sp(15)
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            Layout.alignment: Qt.AlignHCenter
                                        }

                                        CustomSwitch {
                                            Layout.alignment: Qt.AlignHCenter
                                            nodeId: "Arp.Plc.Eclr/enableAsservissementFoursIR"
                                        }
                                    }

                                    Item {
                                        id: notifications
                                        Layout.preferredHeight: frameAppBar.height * 0.52
                                        Layout.preferredWidth: height
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                                        Button {
                                            id: notificationButton
                                            ButtonGroup.group: menuSliderButtons
                                            checkable: true
                                            width: parent.width - 10
                                            height: parent.height - 10
                                            anchors.centerIn: parent

                                            property bool isHovered: false

                                            Image {
                                                sourceSize: Qt.size(width, height)
                                                anchors.fill: parent
                                                source: "Resources/Images/Notification.svg"
                                            }

                                            background: Rectangle {
                                                width: parent.width - 4
                                                height: width
                                                radius: width / 2
                                                anchors.centerIn: parent
                                                color: notificationButton.checked ? "grey" : notificationPage.read ? "transparent" : "#ff6659"

                                                SequentialAnimation on opacity {
                                                    running: !notificationPage.read
                                                    loops: Animation.Infinite
                                                    NumberAnimation { to: 0.4; duration: 650 }
                                                    NumberAnimation { to: 1.0; duration: 650 }
                                                }
                                            }
                                        }

                                        Item {
                                            height: Constants.dp(25)
                                            width: height
                                            anchors.top: parent.top
                                            anchors.right: parent.right

                                            Rectangle {
                                                anchors.fill: parent
                                                radius: width / 2
                                                color: notificationPage.numActive > 0 ?
                                                           notificationPage.blockingEvents > 0 ? "#f44336" : "#fabd05" : "#4CAF50"
                                            }

                                            Text {
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                anchors.verticalCenter: parent.verticalCenter
                                                anchors.verticalCenterOffset: -0.5
                                                text: notificationPage.numActive
                                                font.pixelSize: 14
                                                font.bold: true
                                                color: appTheme.bodyText
                                            }
                                        }


                                        MouseArea {
                                            hoverEnabled: true
                                            anchors.fill: notificationButton
                                            // onEntered: notificationButton.isHovered = true
                                            // onExited: notificationButton.isHovered = false
                                            onClicked: {
                                                // loader.setSource("./Cockpit/Notification.qml")
                                                notificationButton.checked = true
                                                // loadingScreenPopup.open()

                                                stackLayoutPage.currentIndex = 13

                                            }
                                        }
                                    }

                                    Item { Layout.fillWidth: true}

                                    GridLayout{
                                        id: cuves
                                        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                                        Layout.fillHeight: true
                                        columns: 2
                                        rowSpacing: 10
                                        columnSpacing: 15

                                        Label{
                                            text: qsTr("% PreTraitement")
                                            color: appTheme.bodyText
                                            Layout.fillHeight: true
                                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            horizontalAlignment: Text.AlignRight
                                            font.pointSize: 10
                                        }
                                        GaugeBar{
                                            Layout.preferredWidth: frameAppBar.width * 0.15
                                            Layout.preferredHeight: frameAppBar.height * 0.3
                                            antialiasing: true
                                            Layout.alignment: Qt.AlignVCenter
                                            nodeId: "Arp.Plc.Eclr/niveauPreTraitement"
                                        }

                                        Label{
                                            text: qsTr("% Encre")
                                            color: appTheme.bodyText
                                            Layout.fillHeight: true
                                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            horizontalAlignment: Text.AlignRight
                                            font.pointSize: 10
                                        }
                                        GaugeBar{
                                            Layout.preferredWidth: frameAppBar.width * 0.15
                                            Layout.preferredHeight: frameAppBar.height * 0.3
                                            Layout.alignment: Qt.AlignVCenter
                                            nodeId: "Arp.Plc.Eclr/niveauCuveImpression"
                                        }
                                    }

                                    ToolSeparator{
                                        Layout.fillHeight: true
                                        contentItem: Rectangle{color:"transparent"}
                                    }

                                    RowLayout {
                                        id: gauges
                                        spacing: 10
                                        Layout.alignment: Qt.AlignVCenter

                                        Item {
                                            Layout.fillHeight: true
                                            Layout.alignment: Qt.AlignVCenter
                                            Layout.preferredWidth: frameAppBar.height * 0.65

                                            ColumnLayout {
                                                spacing: 15
                                                anchors.fill: parent
                                                Layout.margins: 20

                                                Item { Layout.fillHeight: true}

                                                GaugeProgress {
                                                    id: gaugeTempFour1
                                                    Layout.alignment: Qt.AlignHCenter
                                                    Layout.preferredHeight: frameAppBar.height * 0.65
                                                    Layout.preferredWidth: frameAppBar.height * 0.65
                                                    nodeId: "ns=6;s=Arp.Plc.Eclr/batterieDeChauffe1.Temperature.Four"
                                                    fontSize: Constants.sp(24)
                                                    unit: "°C"
                                                    max: 300
                                                    alert: true
                                                }

                                                Item {
                                                    Layout.fillHeight: true
                                                    Layout.fillWidth: true

                                                    Text {
                                                        text: qsTr("Four 1")
                                                        anchors.fill: parent
                                                        color: appTheme.bodyText
                                                        font.pointSize: 10
                                                        font.bold: true

                                                        verticalAlignment: Text.AlignVCenter
                                                        horizontalAlignment: Text.AlignHCenter
                                                    }
                                                }
                                                Item { Layout.fillHeight: true}
                                            }
                                        }

                                        Item {

                                            Layout.alignment: Qt.AlignVCenter
                                            Layout.fillHeight: true
                                            Layout.preferredWidth: gaugeTempFour1.width
                                            ColumnLayout {
                                                Layout.fillHeight: true
                                                Layout.preferredWidth: gaugeTempFour1.width
                                                anchors.fill: parent
                                                spacing: 15

                                                Item { Layout.fillHeight: true}

                                                GaugeProgress {
                                                    id: gaugeTempFour2
                                                    Layout.alignment: Qt.AlignHCenter
                                                    Layout.preferredHeight: gaugeTempFour1.width
                                                    Layout.preferredWidth: gaugeTempFour1.width
                                                    nodeId: "ns=6;s=Arp.Plc.Eclr/batterieDeChauffe2.Temperature.Four"
                                                    fontSize: gaugeTempFour1.fontSize
                                                    unit: "°C"
                                                    max: 300
                                                    alert: true
                                                }

                                                Item {
                                                    Layout.fillHeight: true
                                                    Layout.fillWidth: true

                                                    Text {
                                                        text: qsTr("Four 2")
                                                        anchors.fill: parent
                                                        color: appTheme.bodyText
                                                        font.pointSize: 10
                                                        font.bold: true

                                                        verticalAlignment: Text.AlignVCenter
                                                        horizontalAlignment: Text.AlignHCenter
                                                    }
                                                }

                                                Item { Layout.fillHeight: true}
                                            }
                                        }

                                        Item {

                                            Layout.alignment: Qt.AlignVCenter
                                            Layout.fillHeight: true
                                            Layout.preferredWidth: gaugeTempFour1.width
                                            ColumnLayout {
                                                spacing: 15
                                                anchors.fill: parent
                                                Item { Layout.fillHeight: true}

                                                GaugeProgress {
                                                    id: gaugeTempIR1
                                                    Layout.alignment: Qt.AlignHCenter
                                                    Layout.preferredHeight: gaugeTempFour1.width
                                                    Layout.preferredWidth: gaugeTempFour1.width
                                                    offset: 0.1
                                                    nodeId: "ns=6;s=Arp.Plc.Eclr/pt100Four1FourIR"
                                                    fontSize: gaugeTempFour1.fontSize
                                                    unit: "°C"
                                                    max: 60
                                                }

                                                Item {
                                                    Layout.fillHeight: true
                                                    Layout.fillWidth: true

                                                    Text {
                                                        text: qsTr("IR 1")
                                                        anchors.fill: parent
                                                        color: appTheme.bodyText
                                                        font.pointSize: 10
                                                        font.bold: true

                                                        verticalAlignment: Text.AlignVCenter
                                                        horizontalAlignment: Text.AlignHCenter
                                                    }
                                                }

                                                Item { Layout.fillHeight: true}
                                            }
                                        }

                                        Item {
                                            Layout.alignment: Qt.AlignVCenter
                                            Layout.fillHeight: true
                                            Layout.preferredWidth: gaugeTempFour1.width
                                            ColumnLayout {
                                                spacing: 15
                                                anchors.fill: parent
                                                Item { Layout.fillHeight: true}

                                                GaugeProgress {
                                                    id: gaugeTempIR2
                                                    Layout.alignment: Qt.AlignHCenter
                                                    Layout.preferredHeight: gaugeTempFour1.width
                                                    Layout.preferredWidth: gaugeTempFour1.width
                                                    offset: 0.1
                                                    nodeId: "ns=6;s=Arp.Plc.Eclr/pt100Four2FourIR"
                                                    fontSize: gaugeTempFour1.fontSize
                                                    unit: "°C"
                                                    max: 60
                                                }

                                                Item {
                                                    Layout.fillHeight: true
                                                    Layout.fillWidth: true

                                                    Text {
                                                        text: qsTr("IR 2")
                                                        anchors.fill: parent
                                                        color: appTheme.bodyText
                                                        font.pointSize: 10
                                                        font.bold: true

                                                        verticalAlignment: Text.AlignVCenter
                                                        horizontalAlignment: Text.AlignHCenter
                                                    }
                                                }
                                                Item { Layout.fillHeight: true}
                                            }
                                        }


                                    }

                                    Item{
                                        Layout.fillWidth: true
                                    }

                                    Button {
                                        id: mainStopButton
                                        checkable: true
                                        Layout.preferredWidth: frameAppBar.height * 0.75
                                        Layout.preferredHeight: frameAppBar.height * 0.75

                                        checked: home.currentState === 9 || home.currentState === 8

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                home.mainStopBtnClicked = true
                                            }
                                        }

                                        contentItem: Item {
                                            id: mainStopVisual
                                            anchors.fill: parent
                                            transformOrigin: Item.Center

                                            MultiEffect {
                                                id: mainStopEffect
                                                anchors.fill: source
                                                source: mainStopVisual
                                                shadowEnabled: true
                                                shadowColor: mainStopButton.checked ? "red" : "transparent"
                                                shadowBlur: 2
                                            }

                                            SequentialAnimation {
                                                running: mainStopButton.checked
                                                loops: Animation.Infinite

                                                PropertyAnimation {
                                                    target: mainStopEffect
                                                    property: "shadowColor"
                                                    to: "red"
                                                    duration: 0
                                                }

                                                PauseAnimation { duration: 550 }

                                                PropertyAnimation {
                                                    target: mainStopEffect
                                                    property: "shadowColor"
                                                    to: "transparent"
                                                    duration: 0
                                                }

                                                PauseAnimation { duration: 550 }
                                            }

                                            Image {
                                                sourceSize: Qt.size(width, height)
                                                source: mainStopButton.checked ? "Resources/Images/ButtonStopMainDown.svg" : "Resources/Images/ButtonStopMain.svg"
                                                anchors.fill: parent
                                                fillMode: Image.PreserveAspectFit

                                                Rectangle {
                                                    anchors.centerIn: parent
                                                    width: parent.width - 2
                                                    height: width
                                                    radius: mainStopButton.width / 2
                                                    color: appTheme.stopButtonWhite
                                                    opacity: 0.15
                                                }
                                            }
                                        }

                                        background: Rectangle {
                                            color: "transparent"
                                        }
                                    }


                                    Item{
                                        Layout.fillWidth: true
                                    }


                                    ColumnLayout {
                                        spacing: 5
                                        Layout.alignment: Qt.AlignVCenter

                                        Text {
                                            text: "État automate :"
                                            font.pixelSize: Constants.sp(20)
                                            color: appTheme.bodyText
                                            Layout.alignment: Qt.AlignLeft

                                        }

                                        Rectangle { Layout.preferredHeight: 2; Layout.fillWidth: true; color: "#555" }

                                        Text {
                                            text: Constants.stateNames[home.currentState]
                                            font.pixelSize: Constants.sp(25)
                                            font.bold: true
                                            color: appTheme.getStateColor(home.currentState)
                                            Layout.alignment: Qt.AlignLeft

                                        }
                                    }

                                    // RowLayout {
                                    //     spacing: 20

                                    //     ModuleButton{
                                    //         Layout.preferredHeight: frameAppBar.height *  0.4
                                    //         Layout.preferredWidth: frameAppBar.width * 0.08
                                    //         labelText: qsTr("Acquitter")
                                    //         nodeId: "Arp.Plc.Eclr/acquitterTout"
                                    //     }
                                    // }
                                    Item{
                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Repeater {
                id: notificationPopupRepeater
                model: modelNotifPopup
                Item {
                    anchors.fill: parent
                    function openNotif() { notificationPopup.open() }
                    property bool isActive: true

                    NotificationPopup {
                        id: notificationPopup

                        notifIndex: index
                        importance: parent.isActive ? modelNotifPopup.get(index).importance : 1
                        text: parent.isActive ? modelNotifPopup.get(index).text : ""
                        subText: parent.isActive ? modelNotifPopup.get(index).subtext : ""
                        srcImg: parent.isActive ? "../Images/" + modelNotifPopup.get(index).srcImg + ".svg" : ""
                        warningColor: parent.isActive ? modelNotifPopup.get(index).color : ""
                        autoClose: parent.isActive ? modelNotifPopup.get(index).autoclose : true
                        em: parent.isActive ? modelNotifPopup.get(index).em : 0
                        cm: parent.isActive ? modelNotifPopup.get(index).cm : 0
                        date: parent.isActive ? modelNotifPopup.get(index).date : ""
                        time: parent.isActive ? modelNotifPopup.get(index).time : ""
                    }
                }
            }

            function openNewNotif(importance, text, subtext, srcImg, color, autoclose, em, cm, date, time) {
                if (em === undefined) { em = 0 }
                if (cm === undefined) { cm = 0 }
                if (date === undefined) { date = "" }
                if (time === undefined) { time = "" }

                modelNotifPopup.append({"importance": importance, "text": text, "subtext": subtext, "srcImg": srcImg, "color": color, "autoclose": autoclose,
                                       "em": em, "cm": cm, "date": date, "time": time })
            }

            function closeNotif(index) {
                notificationPopupRepeater.itemAt(index).isActive = false
                modelNotifPopup.remove(index, 1)
            }

            ListModel {
                id: modelNotifPopup

                onCountChanged: {
                    if (count > 0) {
                        notificationPopupRepeater.itemAt(count - 1).openNotif()
                    }
                }
            }

            Popup {
                id: loadingScreenPopup
                height: parent.height
                width: parent.width
                modal: true
                focus: true
                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
                padding: 0

                LoadingScreen {
                    anchors.fill: parent
                }

            }

            LoadingScreen {}

        }
    }


}
