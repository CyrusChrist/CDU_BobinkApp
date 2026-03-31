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

    // Cantre
    property alias statusIndicatorButtonCantre: statusIndicatorButtonCantre
    property alias groupBoxPreTraitement: groupBoxPreTraitement

    // property alias labelStartStopPreTraitement: labelStartStopPreTraitement
    property alias switchStartStopPreTraitement: switchStartStopPreTraitement

    property alias labelConsigneVitessePreTraitement: labelConsigneVitessePreTraitement
    property alias textFieldConsigneVitessePreTraitement: textFieldConsigneVitessePreTraitement

    // property alias switchAsservissementPreTraitement: switchAsservissementPreTraitement
    property alias switchPlasmaPreTraitement: switchPlasmaPreTraitement
    property alias switchSprayingPreTraitement: switchSprayingPreTraitement
    // property alias textFieldConsigneSprayingPreTraitement: textFieldConsigneSprayingPreTraitement

    property alias groupBoxProduction: groupBoxProduction

    property alias consigneTextFieldProduction: consigneTextFieldProduction
    property alias chronoMaitreFours: chronoMaitreFours

    property alias groupBoxImpression: groupBoxImpression
    // property alias switchStartStopImpressionFour2: switchStartStopImpressionFour2
    property alias switchStartStopImpression: switchStartStopImpression
    property alias textFieldConsigneVitesseImpression: textFieldConsigneVitesseImpression
    property alias textFieldConsigneVitesseFour2: textFieldConsigneVitesseFour2

    // property alias switchAsservissementFoursIR: switchAsservissementFoursIR
    property alias switchStartStopFour2: switchStartStopFour2

    property alias groupBoxBobinoir: groupBoxBobinoir
    property alias switchStartStopBobibnoir: switchStartStopBobibnoir
    property alias consigneTextFieldBobibnoir: consigneTextFieldBobibnoir
    // property alias switchAsservissementBobinoir: switchAsservissementBobinoir

    property alias chainAsservissement1: chainAsservissement1
    // property alias chainAsservissement2: chainAsservissement2

    property alias automaticModeScrollView: automaticModeScrollView

    function onPlayPauseChecked(btn) {
        let isControlButton = (
            btn === switchStartStopPreTraitement ||
            btn === switchStartStopImpressionFour2 ||
            btn === switchStartStopBobibnoir ||
            btn === playPauseButton
        );

        if (isControlButton) {
            // --- CLIC SUR MODULES / PLAYPAUSE ---
            if (chainAsservissement1.checked && chainAsservissement3.checked) {
                toggleModule(switchStartStopPreTraitement);
                toggleModule(switchStartStopImpressionFour2);
                toggleModule(switchStartStopBobibnoir);
            } else if (chainAsservissement1.checked && !chainAsservissement3.checked) {
                if (btn === playPauseButton) {
                    toggleModule(switchStartStopPreTraitement);
                    toggleModule(switchStartStopImpressionFour2);
                }
            } else if (!chainAsservissement1.checked && chainAsservissement3.checked) {
                if (btn === playPauseButton) {
                    toggleModule(switchStartStopImpressionFour2);
                    toggleModule(switchStartStopBobibnoir);
                }
            }

            // Synchronisation état PlayPause <-> Impression
            // playPauseButton.checked = switchStartStopImpressionFour2.checked;

        } else {
            // --- CLIC SUR UN BOUTON D’ASSERVISSEMENT ---
            // L'esclave doit immédiatement suivre l'état du maître, que ce soit ON ou OFF

            if (btn === chainAsservissement1 && chainAsservissement1.checked) {
                // switchStartStopPreTraitement.checked = switchStartStopImpressionFour2.checked;
            }

            if (btn === chainAsservissement3 && chainAsservissement3.checked) {
                // switchStartStopBobibnoir.checked = switchStartStopImpressionFour2.checked;
            }
        }
    }

    function toggleModule(module) {
        module.checked = !module.checked;
    }


    Frame {
        anchors.fill: parent
        anchors.centerIn: parent
        background: Rectangle {
            color: "transparent"
        }
        // anchors.centerIn: parent
        Layout.fillHeight: true
        Layout.fillWidth: true

        ColumnLayout {
            id: mainColumn
            anchors.margins: 40 * Constants.scaleFactor
            anchors.topMargin: 20 * Constants.scaleFactor
            anchors.bottomMargin: 10 * Constants.scaleFactor
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
                    nodeId: "Arp.Plc.Eclr/modeAutomatiqueFours"
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
                visible: true

                StyledFrame {
                    style: "shadowed"

                    Layout.alignment: Qt.AlignHCenter

                    // anchors.horizontalCenter: centralRow.horizontalCenter
                    id: groupBoxProduction
                    Layout.fillHeight: true
                    Layout.preferredWidth: centralRow.width * 0.4
                    spacing: 10 * Constants.scaleFactor

                    GroupBox {
                        width: groupBoxImpression.width
                        height: groupBoxImpression.height

                        anchors.margins: 30 * Constants.scaleFactor
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.fill: parent

                        contentItem: ColumnLayout {

                            spacing: Constants.spacing * 2
                            anchors.fill: parent

                            Label {
                                text: qsTr("Production")
                                color: appTheme.bodyText
                                Layout.alignment: Qt.AlignCenter | Qt.AlignTop
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.bold: true
                                font.pixelSize: Constants.scaleFactor * 35
                            }
                            GridLayout {

                                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                                columns: 2
                                rowSpacing: 20 * Constants.scaleFactor
                                columnSpacing: Constants.spacing * 2

                                Label {
                                    text: qsTr("Vitesse")
                                    color: appTheme.bodyText
                                    font.pixelSize: 18 * Constants.scaleFactor
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                }

                                NumericInput {
                                    id: consigneTextFieldProduction
                                    horizontalAlignment: Text.AlignHCenter
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    placeholderText: qsTr("m/min")
                                    Layout.preferredHeight: 60 * Constants.scaleFactor
                                    Layout.preferredWidth: 250 * Constants.scaleFactor
                                    min: 0
                                    max: 200
                                    unit: placeholderText

                                    onAccepted: focus = false
                                    nodeId: "Arp.Plc.Eclr/vitesseMaitreFours"
                                }

                                Item {
                                    Layout.columnSpan: 2
                                    visible: false
                                }
                                Label {
                                    id: chronoMaitreFours
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    Layout.columnSpan: 2
                                    Layout.fillWidth: true
                                    visible: false
                                }
                            }

                            // Gauge {
                            //     id: gaugeVitesse
                            //     value: consigneTextFieldProduction.text
                            //     Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            //     Layout.preferredWidth: groupBoxProduction.width * 0.7
                            //     Layout.preferredHeight: groupBoxProduction.height * 0.5
                            //     nodeId: "Arp.Plc.Eclr/axisValueRouleauFoursIR.Velocity"
                            // }

                            ModuleButton {
                                checkable: false
                                //horizontalAlignment: Text.AlignHCenter
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                                Layout.preferredHeight: 30 * Constants.scaleFactor
                                Layout.preferredWidth: 250 * Constants.scaleFactor

                                //onAccepted: focus = false
                                // OPCUANODE A MODIFIER UPDATE TVA
                                // OPCUANode{
                                //     nodeId: "Arp.Plc.Eclr/chronometreMaitreFours"
                                //     onValueChanged: parent.labelText = value
                                // }
                            }

                            Item {
                                Layout.fillHeight: true
                            }

                        }

                        background: Rectangle {
                            color: "transparent"
                        }
                    }
                }

                ScrollView {
                    id: automaticModeScrollView
                    ScrollBar.vertical.policy: ScrollBar.AsNeeded
                    ScrollBar.horizontal.policy: ScrollBar.AsNeeded
                    ScrollBar.horizontal.interactive: true
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    // Layout.preferredWidth: parent.width
                    RowLayout {

                        StyledFrame {
                            style: "shadowed"
                            id: groupBoxPreTraitement
                            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                            Layout.fillHeight: centralRow
                            Layout.preferredWidth: groupBoxImpression.width
                            Layout.margins: 10 * Constants.scaleFactor
                            shadowColor: manualModeButton.checked ?
                                            "#deae2a" :
                                            (switchStartStopPreTraitement.checked || (chainAsservissement1.checked && playPauseButton.checked)) ?
                                                 "#0FFF35" :
                                                 "black"

                            GroupBox {
                                anchors.horizontalCenter: parent.horizontalCenter

                                //Layout.fillHeight: true
                                contentItem: ColumnLayout {
                                    anchors.horizontalCenter: parent.horizontalCenter
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
                                        nodeId: "Arp.Plc.Eclr/startMaitreFour1"
                                        onClicked: onPlayPauseChecked(switchStartStopPreTraitement)

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
                                            Layout.preferredHeight: implicitHeight * Constants.scaleFactor
                                            nodeId: "Arp.Plc.Eclr/vitesseMaitreFour1"
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

                                                // Label {
                                                //     id: labelStartStopPreTraitement
                                                //     text: qsTr("Start/Stop")
                                                //     font.pixelSize: 18 * Constants.scaleFactor
                                                //     color: appTheme.bodyText
                                                //     Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                                // }
                                                // CustomSwitch {
                                                //     id: switchStartStopPreTraitement
                                                //     Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                                //     Layout.preferredWidth: groupBoxPreTraitement.width * 0.28
                                                //     Layout.preferredHeight: width / 2
                                                // }


                                                // Label {
                                                //     visible: false
                                                //     id: labelAsservissementPreTraitement
                                                //     text: qsTr("Asservissement")
                                                //     font.pixelSize: 18 * Constants.scaleFactor
                                                //     color: appTheme.bodyText
                                                //     Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                                // }
                                                // CustomSwitch {
                                                //     visible: false
                                                //     id: switchAsservissementPreTraitement
                                                //     Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                                //     Layout.preferredWidth: groupBoxPreTraitement.width * 0.28
                                                //     Layout.preferredHeight: width / 2
                                                // }

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
                                                    Layout.preferredWidth: groupBoxImpression.width * 0.28// groupBoxPreTraitement.width * 0.28
                                                    Layout.preferredHeight: width / 2
                                                    nodeId: "Arp.Plc.Eclr/plasmaEnable"
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
                                                    Layout.preferredWidth: switchPlasmaPreTraitement.width
                                                    Layout.preferredHeight: switchPlasmaPreTraitement.height
                                                    nodeId: "Arp.Plc.Eclr/pompePreTraitementEnable"
                                                }
                                                // Label {
                                                //     text: qsTr("Consigne\nSpraying")
                                                //     font.pixelSize: 18 * Constants.scaleFactor
                                                //     color: appTheme.bodyText
                                                //     Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                                //     horizontalAlignment: Text.AlignHCenter

                                                // }
                                                // NumericInput {
                                                //     id: textFieldConsigneSprayingPreTraitement
                                                //     horizontalAlignment: Text.AlignHCenter
                                                //     Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                                //     placeholderText: qsTr("%")
                                                //     Layout.preferredWidth: textFieldConsigneVitessePreTraitement.width
                                                //     Layout.preferredHeight: implicitHeight * Constants.scaleFactor
                                                //     unit: "%"
                                                //     min: 0
                                                //     max: 100
                                                //     nodeId: "Arp.Plc.Eclr/consignePompePreTraitement"
                                                // }

                                                // }


                                                ScenarioButton {
                                                    id: scenarioFour1
                                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                                    Layout.preferredWidth: scenarioFoursIR.width
                                                    Layout.preferredHeight: implicitHeight * Constants.scaleFactor
                                                    labelText: "Remplir Four 1"
                                                    runningText: "Remplissage\nFour 1..."
                                                    Layout.columnSpan: 2
                                                    nodeIdExec: "Arp.Plc.Eclr/executeRemplissageFour1"
                                                    nodeIdEnd: "Arp.Plc.Eclr/etatRemplissageFour1"
                                                    endValue: 0
                                                }

                                            }
                                        }

                                    }
                                }

                                background: Rectangle {
                                    color: "transparent"
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
                            Layout.fillHeight: centralRow
                            Layout.margins: 10 * Constants.scaleFactor
                            Layout.preferredWidth: _item.width / 3 - 40 * Constants.scaleFactor - chainAsservissement1.width - centralRow.spacing
                            shadowColor: manualModeButton.checked ?
                                             "#deae2a" :
                                             switchStartStopImpressionFour2.checked || playPauseButton.checked ?
                                                 "#0FFF35" :
                                                 "black"

                            GroupBox {
                                anchors.horizontalCenter: parent.horizontalCenter

                                contentItem: ColumnLayout {
                                    spacing: Constants.spacing * 1.5

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
                                        nodeId: "Arp.Plc.Eclr/startMaitreFour2"
                                        visible: !playPauseButton.visible
                                        onClicked: onPlayPauseChecked(switchStartStopImpressionFour2)
                                    }

                                    Button {
                                        id: playPauseButton
                                        checkable: !mainStopButton.checked
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        visible: chainAsservissement1.checked || chainAsservissement3.checked
                                        Layout.preferredWidth: groupBoxImpression.width * 0.28
                                        Layout.preferredHeight: width
                                        property string nodeId: "Arp.Plc.Eclr/startMaitreFours"

                                        onCheckedChanged: {
                                            console.log("PlayPauseButton is checked :" + playPauseButton.checked)
                                            opcuaLoaderPlayPauseButton.item.setValue(playPauseButton.checked)
                                            // onPlayPauseChecked(playPauseButton)
                                        }

                                        Loader {
                                            id: opcuaLoaderPlayPauseButton
                                            active: playPauseButton.nodeId !== ""
                                            sourceComponent: opcuaNodeComponentPlayPauseButton
                                        }

                                        Component {
                                            id: opcuaNodeComponentPlayPauseButton
                                            Item {}
                                            // OPCUANODE A MODIFIER UPDATE TVA
                                            // OPCUANode {
                                            //     nodeId: playPauseButton.nodeId
                                            //     onValueChanged: {
                                            //         playPauseButton.checked = value
                                            //     }
                                            // }
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
                                                id: playPauseIcon
                                                anchors.fill: parent
                                                fillMode: Image.PreserveAspectFit
                                                source: playPauseButton.checked ? "../Resources/Images/ButtonPause.svg" : "../Resources/Images/ButtonPlay.svg"
                                                smooth: true
                                            }

                                            MultiEffect {
                                                // width: playPauseButton.width
                                                // height: playPauseButton.height
                                                //anchors.centerIn: playPauseButton
                                                anchors.fill: source
                                                source: playPauseIcon
                                                shadowEnabled: true
                                                shadowColor: playPauseButton.checked ? "#65E031" : "#FF9A3D"
                                                shadowBlur: 1
                                                // visible: !stopButton.checked
                                            }

                                        }

                                        background: Rectangle {
                                            color: "transparent"
                                        }

                                        //                 onClicked: {
                                        //                     if(!mainStopButton.checked){
                                        //                     //mainStopButton.checked = false
                                        //                     mainStopButton.checked = false


                                        //                     // var opcua = children.find(c=> c.toString().includes("OPCUANode"));
                                        //                     // console.log(opcua.nodeId)
                                        //                     // if (opcua) opcua.setValue(checked);
                                        //                     }

                                        //                 }
                                        //                 // OPCUANode{
                                        //                 //     nodeId: "Arp.Plc.Eclr/startMaitreFours"
                                        //                 //     onValueChanged: {
                                        //                 //         parent.checked = value
                                        //                 //         machineState.state = playPauseButton.checked ? "clearOn" : "clearOff"
                                        //                 //     }
                                        //                 // }

                                    }

                                    State {
                                        id: stateplayPauseButton
                                        name: "pressed"
                                        when: playPauseButton.pressed
                                        PropertyChanges {
                                            target: playPauseVisual
                                            scale: 0.90
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
                                            Layout.preferredHeight: implicitHeight
                                                                    * Constants.scaleFactor
                                            unit: "m/min"
                                            min: 1
                                            max: 400
                                            nodeId: "Arp.Plc.Eclr/vitesseMaitreFour2"
                                            // nodeIdLinked: "Arp.Plc.Eclr/vitesseMaitreFours"   // les nodes sont bien linkées, mais le texte ne se met pas tjrs à jour...
                                            visible: !playPauseButton.visible

                                        }

                                        NumericInput {
                                            id: textFieldConsigneVitesseFours
                                            horizontalAlignment: Text.AlignHCenter
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            placeholderText: qsTr("m/min")
                                            Layout.preferredWidth: groupBoxImpression.width * 0.5
                                            Layout.preferredHeight: implicitHeight
                                                                    * Constants.scaleFactor
                                            unit: "m/min"
                                            min: 1
                                            max: 400
                                            nodeId: "Arp.Plc.Eclr/vitesseMaitreFours"
                                            // nodeIdLinked: "Arp.Plc.Eclr/vitesseMaitreFour2"
                                            visible: playPauseButton.visible

                                        }
                                    }


                                Rectangle {
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.preferredWidth: groupBoxProduction.width / 1.5
                                    height: 1 * Constants.scaleFactor
                                    gradient: Gradient {
                                        orientation: Gradient.Horizontal
                                        GradientStop { position : 0.0; color: "transparent" }
                                        GradientStop { position : 0.25; color: appTheme.bodyText }
                                        GradientStop { position : 0.75; color: appTheme.bodyText}
                                        GradientStop { position : 1.0; color: "transparent" }
                                    }
                                }

                                    // Label {
                                    //     text: qsTr("Impression")
                                    //     color: appTheme.bodyText
                                    //     Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                                    //     horizontalAlignment: Text.AlignHCenter
                                    //     verticalAlignment: Text.AlignVCenter
                                    //     font.bold: true
                                    //     font.pixelSize: 25 * Constants.scaleFactor
                                    // }

                                    GridLayout {
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                                        columns: 2
                                        rowSpacing: Constants.spacing * 2
                                        columnSpacing: Constants.spacing
                                        visible: false

                                        Label {
                                            text: qsTr("Start/Stop")
                                            font.pixelSize: 18 * Constants.scaleFactor
                                            color: appTheme.bodyText
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            visible: false //!chainAsservissement2.checked
                                        }
                                        CustomSwitch {
                                            id: switchStartStopImpression
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            Layout.preferredWidth: switchPlasmaPreTraitement.width
                                            Layout.preferredHeight: switchPlasmaPreTraitement.height
                                            visible: false //!chainAsservissement2.checked

                                        }

                                        Label {
                                            text: qsTr("Consigne")
                                            color: appTheme.bodyText
                                            font.pixelSize: 18 * Constants.scaleFactor
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            visible: false
                                        }
                                        NumericInput {
                                            id: textFieldConsigneVitesseImpression
                                            horizontalAlignment: Text.AlignHCenter
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            placeholderText: qsTr("m/min")
                                            Layout.preferredWidth: textFieldConsigneVitessePreTraitement.width
                                            Layout.preferredHeight: implicitHeight
                                                                    * Constants.scaleFactor
                                            unit: "m/min"
                                            min: 1
                                            max: 400
                                            nodeId: "Arp.Plc.Eclr/vitesseMaitreFour2"
                                            visible: false
                                        }


                                        // Label {
                                        //     visible: (Authentification.currentUserType
                                        //               > 2) ? true : false
                                        //     text: qsTr("Asservissement\ncapteur de tension")
                                        //     font.pixelSize: 18 * Constants.scaleFactor
                                        //     wrapMode: Text.WordWrap
                                        //     horizontalAlignment: Text.AlignHCenter
                                        //     color: appTheme.bodyText
                                        //     Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        // }
                                        // CustomSwitch {
                                        //     visible: (Authentification.currentUserType
                                        //               > 2) ? true : false
                                        //     id: switchAsservissementFoursIR
                                        //     Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        // }
                                        // Item {
                                        //     Layout.fillHeight: true
                                        // }
                                    }

                                    // ChainAsservissement {
                                    //     Layout.alignment: Qt.AlignHCenter
                                    //     id: chainAsservissement2
                                    //     width: chainAsservissement1.width
                                    //     height: chainAsservissement1.height
                                    //     rotation: 90
                                    // }

                                    Label {
                                        text: qsTr("Four 2")
                                        color: appTheme.bodyText
                                        Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        font.bold: true
                                        font.pixelSize: 25 * Constants.scaleFactor
                                        visible: false
                                    }

                                    GridLayout {
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                                        columns: 2
                                        rowSpacing: Constants.spacing * 2
                                        columnSpacing: Constants.spacing

                                        Label {
                                            text: qsTr("Start/Stop")
                                            font.pixelSize: 18 * Constants.scaleFactor
                                            color: appTheme.bodyText
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            visible: false //!chainAsservissement2.checked
                                        }
                                        CustomSwitch {
                                            id: switchStartStopFour2
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            Layout.preferredWidth: switchPlasmaPreTraitement.width
                                            Layout.preferredHeight: switchPlasmaPreTraitement.height
                                            visible: false // !chainAsservissement2.checked
                                        }

                                        Label {
                                            text: qsTr("Séchage IR")
                                            color: appTheme.bodyText
                                            font.pixelSize: 18 * Constants.scaleFactor
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                                        }

                                        CustomSwitch {
                                            id: switchStartIR
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            Layout.preferredWidth: groupBoxImpression.width * 0.28
                                            Layout.preferredHeight: width / 2
                                            nodeId:"Arp.Plc.Eclr/chauffeIRsAutomatiqueEnable"
                                            // onCheckedChanged: nodeIR.setValue(checked)

                                            // OPCUANode {
                                            //     id: nodeIR
                                            //     nodeId:"Arp.Plc.Eclr/chauffeIR2"
                                            // }
                                        }

                                        ScenarioButton {
                                            id: scenarioFoursIR
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            Layout.preferredWidth: textFieldConsigneVitesseFours.width * 1.4
                                            Layout.preferredHeight: implicitHeight * Constants.scaleFactor
                                            labelText: "Remplir Fours IR"
                                            runningText: "Remplissage\nFours IR..."
                                            Layout.columnSpan: 2
                                            nodeIdExec: "Arp.Plc.Eclr/executeScenarioVerrinsIRs"
                                            nodeIdEnd: "Arp.Plc.Eclr/verrins11BasFoursIR"
                                            nodeIdEnd2: "Arp.Plc.Eclr/verrins12BasFoursIR"
                                            endValue: true
                                            nodeIdReset: "Arp.Plc.Eclr/resetVerrinsScenario"
                                            razButton: true
                                        }

                                        ScenarioButton {
                                            id: scenarioFour2
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            Layout.preferredWidth: scenarioFoursIR.width
                                            Layout.preferredHeight: implicitHeight * Constants.scaleFactor
                                            labelText: "Remplir Four 2"
                                            runningText: "Remplissage\nFour 2..."
                                            nodeIdExec: "Arp.Plc.Eclr/executeRemplissageFour2"
                                            nodeIdEnd: "Arp.Plc.Eclr/etatRemplissageFour2"
                                            endValue: 0
                                            Layout.columnSpan: 2
                                            enabled: false
                                        }
                                    }
                                }

                                background: Rectangle {
                                    color: "transparent"
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

                            Layout.fillHeight: centralRow
                            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                            Layout.margins: 10 * Constants.scaleFactor
                            Layout.preferredWidth: groupBoxImpression.width
                            shadowColor: manualModeButton.checked ?
                                             "#deae2a" :
                                             switchStartStopBobibnoir.checked /*|| (chainAsservissement3.checked && playPauseButton.checked)*/ ?
                                                 "#0FFF35" :
                                                 "black"

                            GroupBox {
                                anchors.horizontalCenter: parent.horizontalCenter
                                contentItem: ColumnLayout {
                                    spacing: Constants.spacing * 2

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
                                        nodeId: "Arp.Plc.Eclr/startWinding"
                                        // visible: !chainAsservissement3.checked
                                        onClicked: onPlayPauseChecked(switchStartStopBobibnoir)
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
                                            Layout.preferredHeight: implicitHeight
                                                                    * Constants.scaleFactor
                                            unit: "m/min"
                                            min: 1
                                            max: 1000
                                            nodeId: "Arp.Plc.Eclr/vitesseMaitreBobinoir"
                                            visible: !chainAsservissement3.checked

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
                                            Layout.preferredHeight: implicitHeight
                                                                    * Constants.scaleFactor
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
                                        }

                                        ScenarioButton {
                                            id: scenarioChangerBob
                                            Layout.alignment: Qt.AlignHCenter
                                            labelText: "Changer Bobines"
                                            runningText: "Changement\ndes bobines..."
                                            Layout.preferredWidth: scenarioFoursIR.width
                                            Layout.preferredHeight: implicitHeight
                                            nodeIdExec: "Arp.Plc.Eclr/windingEnd"
                                            nodeIdEnd: "Arp.Plc.Eclr/etatBobinoir"
                                            endValue: 0
                                            Layout.columnSpan: 2
                                        }

                                    }
                                }

                                background: Rectangle {
                                    color: "transparent"
                                }
                            }
                        }
                    }
                }
            }

            ScrollView {
                id: manualModeScrollView
                ScrollBar.vertical.policy: ScrollBar.AsNeeded
                ScrollBar.horizontal.policy: ScrollBar.AsNeeded
                ScrollBar.horizontal.interactive: true
                Layout.fillHeight: true
                Layout.fillWidth: true

                SwipeView {
                    anchors.centerIn: parent
                    width: parent.width
                    height: parent.height
                    visible: false
                    id: manualView
                    currentIndex: 0

                    Item {

                        id: manualFour1
                        StyledFrame {
                            style: "shadowed"
                            id: groupBoxManuelFour1
                            anchors.centerIn: parent
                            Layout.fillHeight: centralRow
                            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                            Layout.margins: 10 * Constants.scaleFactor
                            Layout.preferredWidth: groupBoxImpression.width

                            RowLayout {
                                id: controlFour1Manuel
                                Layout.alignment: Qt.AlignHCenter
                                spacing: 20 * Constants.scaleFactor

                                ColumnLayout {
                                    id: manuelFour1
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.preferredWidth: controlBobinageManuel.width * 0.48
                                    spacing: 5 * Constants.scaleFactor

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Rouleau Four 1"
                                        font.bold: true
                                        font.pixelSize: 23 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    CustomPlayPause {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.4
                                        Layout.preferredHeight: width
                                        nodeId: "Arp.Plc.Eclr/startManuRouleauFour1"
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: qsTr("Automatique")
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    CustomSwitch{
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Vitesse"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("m/min")
                                        min: 0
                                        max: 250
                                        nodeId: "Arp.Plc.Eclr/vitesseManuelRouleauFour1"
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Accélération"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("mm/s²")
                                        digit: 3
                                        min: 0
                                        max: 500
                                        nodeId: "Arp.Plc.Eclr/accelerationManuelRouleauFour1"
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Décélération"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("mm/s²")
                                        digit: 3
                                        min: 0
                                        max: 500
                                        nodeId: "Arp.Plc.Eclr/decelerationManuelRouleauFour1"
                                    }
                                }

                                ColumnLayout {
                                    id: manuelDeposeFilsFour1
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.preferredWidth: controlBobinageManuel.width * 0.48
                                    spacing: 5 * Constants.scaleFactor

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Dépose Fils Four 1"
                                        font.bold: true
                                        font.pixelSize: 23 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    CustomPlayPause {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.4
                                        Layout.preferredHeight: width
                                        nodeId: "Arp.Plc.Eclr/startManuDeposeFilsFour1"
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: qsTr("Automatique")
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    CustomSwitch{
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Vitesse"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("m/min")
                                        min: 0
                                        max: 250
                                        nodeId: "Arp.Plc.Eclr/vitesseManuelDeposeFilsFour1"
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Accélération"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("mm/s²")
                                        digit: 3
                                        min: 0
                                        max: 500
                                        nodeId: "Arp.Plc.Eclr/accelerationManuelDeposeFilsFour1"
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Décélération"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("mm/s²")
                                        digit: 3
                                        min: 0
                                        max: 500
                                        nodeId: "Arp.Plc.Eclr/decelerationManuelDeposeFilsFour1"
                                    }
                                }

                                ColumnLayout {
                                    id: manuelDeposeTapisFour1
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.preferredWidth: controlBobinageManuel.width * 0.48
                                    spacing: 5 * Constants.scaleFactor

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Tapis Four 1"
                                        font.bold: true
                                        font.pixelSize: 23 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }

                                    CustomPlayPause {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.4
                                        Layout.preferredHeight: width
                                        nodeId: "Arp.Plc.Eclr/startManuTapisFour1"
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: qsTr("Automatique")
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    CustomSwitch{
                                        Layout.alignment: Qt.AlignHCenter
                                    }

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Vitesse"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }

                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("m/min")
                                        min: 0
                                        max: 250
                                        nodeId: "Arp.Plc.Eclr/vitesseManuelTapisFour1"
                                    }

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Accélération"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }

                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("mm/s²")
                                        digit: 3
                                        min: 0
                                        max: 500
                                        nodeId: "Arp.Plc.Eclr/accelerationManuelTapisFour1"
                                    }

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Décélération"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }

                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("mm/s²")
                                        digit: 3
                                        min: 0
                                        max: 500
                                        nodeId: "Arp.Plc.Eclr/decelerationManuelTapisFour1"
                                    }
                                }

                            }


                        }
                    }
                    Item {
                        id: manualFoursIR
                        StyledFrame {
                            style: "shadowed"
                            id: groupBoxManuelFoursIR
                            anchors.centerIn: parent
                            Layout.fillHeight: centralRow
                            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                            Layout.margins: 10 * Constants.scaleFactor
                            Layout.preferredWidth: groupBoxImpression.width

                            RowLayout {
                                id: controlFoursIRManuel
                                Layout.alignment: Qt.AlignHCenter
                                spacing: 20 * Constants.scaleFactor

                                ColumnLayout {
                                    id: manuelPreAlImpressionFoursIR
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.preferredWidth: controlBobinageManuel.width * 0.48
                                    spacing: 5 * Constants.scaleFactor

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Pré-Alimenteur Impression"
                                        font.bold: true
                                        font.pixelSize: 23 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    CustomPlayPause {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.4
                                        Layout.preferredHeight: width
                                        nodeId: "Arp.Plc.Eclr/startManuPreAlImpressionFoursIR"
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: qsTr("Automatique")
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    CustomSwitch{
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Vitesse"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("m/min")
                                        min: 0
                                        max: 250
                                        nodeId: "Arp.Plc.Eclr/vitesseManuelPreAlImpressionFoursIR"
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Accélération"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("mm/s²")
                                        digit: 3
                                        min: 0
                                        max: 500
                                        nodeId: "Arp.Plc.Eclr/accelerationManuelPreAlImpressionFoursIR"
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Décélération"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("mm/s²")
                                        digit: 3
                                        min: 0
                                        max: 500
                                        nodeId: "Arp.Plc.Eclr/decelerationManuelPreAlImpressionFoursIR"
                                    }
                                }
                                ColumnLayout {
                                    id: manuelRouleauFoursIR
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.preferredWidth: controlBobinageManuel.width * 0.48
                                    spacing: 5 * Constants.scaleFactor

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Rouleau Fours IR"
                                        font.bold: true
                                        font.pixelSize: 23 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    CustomPlayPause {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.4
                                        Layout.preferredHeight: width
                                        nodeId: "Arp.Plc.Eclr/startManuRouleauFoursIR"
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: qsTr("Automatique")
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    CustomSwitch{
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Vitesse"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("m/min")
                                        min: 0
                                        max: 250
                                        nodeId: "Arp.Plc.Eclr/vitesseManuelRouleauFoursIR"
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Accélération"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("mm/s²")
                                        digit: 3
                                        min: 0
                                        max: 500
                                        nodeId: "Arp.Plc.Eclr/accelerationManuelRouleauFoursIR"
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Décélération"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("mm/s²")
                                        digit: 3
                                        min: 0
                                        max: 500
                                        nodeId: "Arp.Plc.Eclr/decelerationManuelRouleauFoursIR"
                                    }
                                }
                                ColumnLayout {
                                    id: manuelPreAlFoursIR
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.preferredWidth: controlBobinageManuel.width * 0.48
                                    spacing: 5 * Constants.scaleFactor

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Pré-Alimenteur Fours IR"
                                        font.bold: true
                                        font.pixelSize: 23 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }

                                    CustomPlayPause {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.4
                                        Layout.preferredHeight: width
                                        nodeId: "Arp.Plc.Eclr/startManuPreAlInfraRougeFoursIR"
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: qsTr("Automatique")
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    CustomSwitch{
                                        Layout.alignment: Qt.AlignHCenter
                                    }

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Vitesse"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }

                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("m/min")
                                        min: 0
                                        max: 250
                                        nodeId: "Arp.Plc.Eclr/vitesseManuelPreAlInfraRougeFoursIR"
                                    }

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Accélération"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }

                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("mm/s²")
                                        digit: 3
                                        min: 0
                                        max: 500
                                        nodeId: "Arp.Plc.Eclr/accelerationManuelPreAlInfraRougeFoursIR"
                                    }

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Décélération"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }

                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("mm/s²")
                                        digit: 3
                                        min: 0
                                        max: 500
                                        nodeId: "Arp.Plc.Eclr/decelerationManuelPreAlInfraRougeFoursIR"
                                    }
                                }

                            }


                        }
                    }
                    Item {

                        id: manualFour2
                        StyledFrame {
                            style: "shadowed"
                            id: groupBoxManuelFour2
                            anchors.centerIn: parent
                            Layout.fillHeight: centralRow
                            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                            Layout.margins: 10 * Constants.scaleFactor
                            Layout.preferredWidth: groupBoxImpression.width

                            RowLayout {
                                id: controlFour2Manuel
                                Layout.alignment: Qt.AlignHCenter
                                spacing: 20 * Constants.scaleFactor

                                ColumnLayout {
                                    id: manuelFour2
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.preferredWidth: controlBobinageManuel.width * 0.48
                                    spacing: 5 * Constants.scaleFactor

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Rouleau Four 2"
                                        font.bold: true
                                        font.pixelSize: 23 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    CustomPlayPause {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.4
                                        Layout.preferredHeight: width
                                        nodeId: "Arp.Plc.Eclr/startManuRouleauFour2"
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: qsTr("Automatique")
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    CustomSwitch{
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Vitesse"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("m/min")
                                        min: 0
                                        max: 250
                                        nodeId: "Arp.Plc.Eclr/vitesseManuelRouleauFour2"
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Accélération"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("mm/s²")
                                        digit: 3
                                        min: 0
                                        max: 500
                                        nodeId: "Arp.Plc.Eclr/accelerationManuelRouleauFour2"
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Décélération"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("mm/s²")
                                        digit: 3
                                        min: 0
                                        max: 500
                                        nodeId: "Arp.Plc.Eclr/decelerationManuelRouleauFour2"
                                    }
                                }

                                ColumnLayout {
                                    id: manuelDeposeFilsFour2
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.preferredWidth: controlBobinageManuel.width * 0.48
                                    spacing: 5 * Constants.scaleFactor

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Dépose Fils Four 2"
                                        font.bold: true
                                        font.pixelSize: 23 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    CustomPlayPause {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.4
                                        Layout.preferredHeight: width
                                        nodeId: "Arp.Plc.Eclr/startManuDeposeFilsFour2"
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: qsTr("Automatique")
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    CustomSwitch{
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Vitesse"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("m/min")
                                        min: 0
                                        max: 250
                                        nodeId: "Arp.Plc.Eclr/vitesseManuelDeposeFilsFour2"
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Accélération"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("mm/s²")
                                        digit: 3
                                        min: 0
                                        max: 500
                                        nodeId: "Arp.Plc.Eclr/accelerationManuelDeposeFilsFour2"
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Décélération"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("mm/s²")
                                        digit: 3
                                        min: 0
                                        max: 500
                                        nodeId: "Arp.Plc.Eclr/decelerationManuelDeposeFilsFour2"
                                    }
                                }

                                ColumnLayout {
                                    id: manuelDeposeTapisFour2
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.preferredWidth: controlBobinageManuel.width * 0.48
                                    spacing: 5 * Constants.scaleFactor

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Tapis Four 1"
                                        font.bold: true
                                        font.pixelSize: 23 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }

                                    CustomPlayPause {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.4
                                        Layout.preferredHeight: width
                                        nodeId: "Arp.Plc.Eclr/startManuTapisFour2"
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: qsTr("Automatique")
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    CustomSwitch{
                                        Layout.alignment: Qt.AlignHCenter
                                    }

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Vitesse"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }

                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("m/min")
                                        min: 0
                                        max: 250
                                        nodeId: "Arp.Plc.Eclr/vitesseManuelTapisFour2"
                                    }

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Accélération"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }

                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("mm/s²")
                                        digit: 3
                                        min: 0
                                        max: 500
                                        nodeId: "Arp.Plc.Eclr/accelerationManuelTapisFour2"
                                    }

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Décélération"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }

                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("mm/s²")
                                        digit: 3
                                        min: 0
                                        max: 500
                                        nodeId: "Arp.Plc.Eclr/decelerationManuelTapisFour2"
                                    }
                                }

                            }


                        }
                    }
                    Item {
                        id: manualBobinoir
                        StyledFrame {
                            style: "shadowed"
                            id: groupBoxManuelBobinage
                            anchors.centerIn: parent
                            Layout.fillHeight: centralRow
                            Layout.margins: 10 * Constants.scaleFactor
                            Layout.preferredWidth: groupBoxImpression.width

                            RowLayout {
                                id: controlBobinageManuel
                                Layout.alignment: Qt.AlignHCenter
                                spacing: 20 * Constants.scaleFactor

                                ColumnLayout {
                                    id: manuelBobinage
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.preferredWidth: controlBobinageManuel.width * 0.48
                                    spacing: 5 * Constants.scaleFactor

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Bobinage"
                                        font.bold: true
                                        font.pixelSize: 23 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }

                                    CustomPlayPause {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.4
                                        Layout.preferredHeight: width
                                        nodeId: "Arp.Plc.Eclr/startManuBobinoir"
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: qsTr("Automatique")
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    CustomSwitch{
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Vitesse"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }

                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("m/min")
                                        min: 0
                                        max: 250
                                        nodeId: "Arp.Plc.Eclr/vitesseManuelBobinoir"
                                    }

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Accélération"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }

                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("mm/s²")
                                        digit: 3
                                        min: 0
                                        max: 500
                                        nodeId: "Arp.Plc.Eclr/accelerationManuelBobinoir"
                                    }

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Décélération"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }

                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("mm/s²")
                                        digit: 3
                                        min: 0
                                        max: 500
                                        nodeId: "Arp.Plc.Eclr/decelerationManuelBobinoir"
                                    }
                                }

                                ColumnLayout {
                                    id: manuelTrancanage
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.preferredWidth: controlBobinageManuel.width * 0.48
                                    spacing: 5 * Constants.scaleFactor

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Trancanage"
                                        font.bold: true
                                        font.pixelSize: 23 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }

                                    CustomPlayPause {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.4
                                        Layout.preferredHeight: width
                                        nodeId: "Arp.Plc.Eclr/startManuTrancanage"
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: qsTr("Automatique")
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }
                                    CustomSwitch{
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Vitesse"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }

                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("m/min")
                                        min: 0
                                        max: 250
                                        nodeId: "Arp.Plc.Eclr/vitesseManuelTrancanage"
                                    }

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Accélération"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }

                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("mm/s²")
                                        digit: 3
                                        min: 0
                                        max: 500
                                        nodeId: "Arp.Plc.Eclr/accelerationManuelTrancanage"
                                    }

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Décélération"
                                        font.pixelSize: 19 * Constants.scaleFactor
                                        horizontalAlignment: Text.AlignHCenter
                                        color: appTheme.bodyText
                                    }

                                    NumericInput {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: manuelBobinage.width * 0.8
                                        Layout.preferredHeight: width * 0.4
                                        horizontalAlignment: Text.AlignHCenter
                                        unit: qsTr("mm/s²")
                                        digit: 3
                                        min: 0
                                        max: 500
                                        nodeId: "Arp.Plc.Eclr/decelerationManuelTrancanage"
                                    }
                                }

                            }


                        }
                    }


                }

                PageIndicator {
                    id: myPageInd

                    count: manualView.count
                    currentIndex: manualView.currentIndex

                    anchors.bottom: manualView.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    delegate: Rectangle {
                        implicitWidth: index === myPageInd.currentIndex ? 200 * 0.05 : 150 * 0.04
                        implicitHeight: width
                        anchors.verticalCenter: parent.verticalCenter

                        radius: width / 2
                        color: appTheme.pageIndColor

                        opacity: index === myPageInd.currentIndex ? 0.95 : pressed ? 0.7 : 0.45

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
            // loader.setSource("CantreMaintenance.qml")
        }
    }

    Connections {
        target: btnPT
        function onClicked() {
            rootApp.pageChanged(rootApp.sliderBtnPT)
            // loader.setSource("PreTraitementMaintenance.qml")
        }
    }

    Connections {
        target: btnFour1
        function onClicked() {
            rootApp.pageChanged(rootApp.sliderBtnFour)
            // loader.setSource("FourMaintenance.qml")
        }
    }

    Connections {
        target: btnIR
        function onClicked() {
            rootApp.pageChanged(rootApp.sliderBtnIR)
            // loader.setSource("IRMaintenance.qml")
        }
    }

    Connections {
        target: btnImpression
        function onClicked() {
            rootApp.pageChanged(rootApp.sliderBtnImpression)
            // loader.setSource("Impression.qml")
        }
    }

    Connections {
        target: btnFour2
        function onClicked() {
            rootApp.pageChanged(rootApp.sliderBtnFour)
            // loader.setSource("FourMaintenance.qml")
        }
    }

    Connections {
        target: btnBob
        function onClicked() {
            rootApp.pageChanged(rootApp.sliderBtnBobinoir)
            // loader.setSource("Bobinoir.qml")
        }
    }


    groupBoxProduction.visible: false

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
