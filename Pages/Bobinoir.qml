import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../"
import Bobink
import QtQuick.Effects
import "../Resources/Components"

Item {
    id: root

    property alias manuelBobinoirButton: manuelBobinoirButton

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40 * Constants.scaleFactor
        spacing: 40 * Constants.scaleFactor

        RowLayout {
            Layout.fillWidth: true
            spacing: Constants.dp(15)

            Text {
                Layout.fillWidth: true

                text: qsTr("Bobinoir")
                font.pixelSize: Math.max(35, parent.width * 0.037)
                font.bold: true
                color: appTheme.bodyText
            }

            Item {
                Layout.fillWidth: true
            }

            ManuelSwitch {
                id: manuelBobinoirButton
                nodeId: "Arp.Plc.Eclr/modeAutomatiqueBobinoir"
            }

            // StatusIndicatorTricolor {
            //     id: bobGlobalStatus
            //     Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            //     Layout.preferredWidth: Constants.dp(45)
            //     Layout.preferredHeight: width
            //     nodeIdRed: "Arp.Plc.Eclr/tricolorRougeBobinoir"
            //     nodeIdYellow: "Arp.Plc.Eclr/tricolorOrangeBobinoir"
            //     nodeIdGreen: "Arp.Plc.Eclr/tricolorVertBobinoir"

            //     onClicked: {
            //         capteursBobinoirPopup.open()
            //     }
            // }


        }

        RowLayout {
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            spacing: Constants.dp(25)

            ColumnLayout {
                Layout.fillHeight: true

                StyledFrame {
                    id: bobinageConsigneFrame
                    style: "shadowed"
                    Layout.preferredWidth: paraffineFrameBtn.width
                    padding: Constants.dp(16)
                    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                    topPadding: Constants.dp(30)

                    shadowColor: manuelBobinoirButton.checked ? "#deae2a" : startStopBobinoir.checked ? "#35a646" : "black"

                    readonly property real fieldW: Math.min(width * 0.62, Constants.dp(420))
                    readonly property real fieldH: Constants.dp(48)
                    readonly property real smallFieldW: Constants.dp(80)
                    readonly property real smallFieldH: Constants.dp(25)
                    readonly property real iconSize: Constants.dp(110)
                    readonly property real gap: Constants.dp(10)

                    ColumnLayout {
                        width: parent.width
                        spacing: bobinageConsigneFrame.gap * 2

                        RowLayout {
                            visible: !manuelBobinoirButton.checked
                            spacing: 20 * Constants.scaleFactor

                            Item {
                                Layout.preferredWidth: bobinageConsigneFrame.width * 0.075
                            }

                            Text {
                                Layout.preferredWidth: bobinageConsigneFrame.width * 0.7
                                Layout.alignment: Qt.AlignHCenter
                                text: "Bobinage"
                                font.pixelSize: Constants.sp(30)
                                font.bold: true
                                horizontalAlignment: Text.AlignHCenter
                                color: appTheme.bodyText
                                Layout.fillWidth: true
                            }

                            OptionButton {
                                onClicked: trancanageParametersPopup.open()
                            }
                        }

                        CustomPlayPause {
                            id: startStopBobinoir
                            visible: !manuelBobinoirButton.checked
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredWidth: bobinageConsigneFrame.iconSize
                            Layout.preferredHeight: bobinageConsigneFrame.iconSize
                            nodeId: "Arp.Plc.Eclr/startWinding"
                        }

                        RowLayout {
                            id: controleAutoBob
                            Layout.alignment: Qt.AlignHCenter
                            spacing: bobinageConsigneFrame.gap
                            visible: !manuelBobinoirButton.checked
                            ColumnLayout {
                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: "Consigne"
                                    font.pixelSize: Constants.sp(18)
                                    horizontalAlignment: Text.AlignHCenter
                                    color: appTheme.bodyText
                                }

                                NumericInput {
                                    id: consigneBobinoir
                                    Layout.alignment: Qt.AlignHCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    Layout.preferredWidth: Constants.dp(150)
                                    unit: qsTr("m/min")
                                    min: 1
                                    max: 1000
                                    nodeId: "Arp.Plc.Eclr/vitesseMaitreBobinoir"
                                }
                            }

                            ColumnLayout {
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
                                    horizontalAlignment: Text.AlignHCenter
                                    Layout.preferredWidth: Constants.dp(150)
                                    readOnly: true
                                    unit: qsTr("m/min")
                                    digit: 1
                                    min: 0
                                    max: 1000
                                    nodeId: "Arp.Plc.Eclr/vitesseRoueBobinoir"
                                }
                            }
                        }

                        RowLayout {
                            id: controlBobinageManuel
                            visible: manuelBobinoirButton.checked
                            Layout.alignment: Qt.AlignHCenter
                            spacing: Constants.dp(5)

                            ColumnLayout {
                                id: manuelBobinage
                                Layout.alignment: Qt.AlignHCenter
                                Layout.preferredWidth: Math.min(bobinageConsigneFrame.width * 0.46, Constants.dp(520))
                                spacing: bobinageConsigneFrame.gap

                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: "Bobinage"
                                    font.bold: true
                                    font.pixelSize: Constants.sp(20)
                                    horizontalAlignment: Text.AlignHCenter
                                    color: appTheme.bodyText
                                }

                                CustomPlayPause {
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.preferredWidth: bobinageConsigneFrame.iconSize
                                    Layout.preferredHeight: bobinageConsigneFrame.iconSize

                                    nodeId: "Arp.Plc.Eclr/startManuBobinoir"
                                }

                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: "Consigne"
                                    font.pixelSize: Constants.sp(18)
                                    horizontalAlignment: Text.AlignHCenter
                                    color: appTheme.bodyText
                                }

                                NumericInput {
                                    Layout.alignment: Qt.AlignHCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    unit: qsTr("mm/s")
                                    Layout.preferredWidth: Constants.dp(150)
                                    min: 0
                                    max: 250
                                    nodeId: "Arp.Plc.Eclr/vitesseManuelBobinoir"
                                }

                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: "Accélération"
                                    font.pixelSize: Constants.sp(18)
                                    horizontalAlignment: Text.AlignHCenter
                                    color: appTheme.bodyText
                                }

                                NumericInput {
                                    Layout.alignment: Qt.AlignHCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    unit: qsTr("mm/s²")
                                    Layout.preferredWidth: Constants.dp(150)
                                    digit: 3
                                    min: 0
                                    max: 500
                                    nodeId: "Arp.Plc.Eclr/accelerationManuelBobinoir"
                                }

                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: "Décélération"
                                    font.pixelSize: Constants.sp(18)
                                    horizontalAlignment: Text.AlignHCenter
                                    color: appTheme.bodyText
                                }

                                NumericInput {
                                    Layout.alignment: Qt.AlignHCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    unit: qsTr("mm/s²")
                                    Layout.preferredWidth: Constants.dp(150)
                                    digit: 3
                                    min: 0
                                    max: 500
                                    nodeId: "Arp.Plc.Eclr/decelerationManuelBobinoir"
                                }
                            }

                            ColumnLayout {
                                id: manuelTrancanage
                                Layout.alignment: Qt.AlignHCenter
                                Layout.preferredWidth: Math.min(bobinageConsigneFrame.width * 0.46, Constants.dp(520))
                                spacing: bobinageConsigneFrame.gap

                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: "Trancanage"
                                    font.bold: true
                                    font.pixelSize: Constants.sp(20)
                                    horizontalAlignment: Text.AlignHCenter
                                    color: appTheme.bodyText
                                }

                                CustomPlayPause {
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.preferredWidth: bobinageConsigneFrame.iconSize
                                    Layout.preferredHeight: bobinageConsigneFrame.iconSize

                                    nodeId: "Arp.Plc.Eclr/startManuTrancanage"
                                }

                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: "Consigne"
                                    font.pixelSize: Constants.sp(18)
                                    horizontalAlignment: Text.AlignHCenter
                                    color: appTheme.bodyText
                                }

                                NumericInput {
                                    Layout.alignment: Qt.AlignHCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    unit: qsTr("mm/s")
                                    Layout.preferredWidth: Constants.dp(150)
                                    min: 0
                                    max: 250
                                    nodeId: "Arp.Plc.Eclr/vitesseManuelTrancanage"
                                }

                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: "Accélération"
                                    font.pixelSize: Constants.sp(18)
                                    horizontalAlignment: Text.AlignHCenter
                                    color: appTheme.bodyText
                                }

                                NumericInput {
                                    Layout.alignment: Qt.AlignHCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    unit: qsTr("mm/s²")
                                    Layout.preferredWidth: Constants.dp(150)
                                    digit: 3
                                    min: 0
                                    max: 500
                                    nodeId: "Arp.Plc.Eclr/accelerationManuelTrancanage"
                                }

                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: "Décélération"
                                    font.pixelSize: Constants.sp(18)
                                    horizontalAlignment: Text.AlignHCenter
                                    color: appTheme.bodyText
                                }

                                NumericInput {
                                    Layout.alignment: Qt.AlignHCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    unit: qsTr("mm/s²")
                                    Layout.preferredWidth: Constants.dp(150)
                                    digit: 3
                                    min: 0
                                    max: 500
                                    nodeId: "Arp.Plc.Eclr/decelerationManuelTrancanage"
                                }
                            }

                        }

                        ComboBox {
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredHeight: Constants.dp(44)
                            Layout.preferredWidth: bobinageConsigneFrame.width * 0.6
                            font.pixelSize: Constants.sp(16)

                            property bool clickable : manuelBobinoirButton.checked

                            model: [
                                { etape: 0, label: "[0] Waiting Start Command" },
                                { etape: 10, label: "[10] Mise sous tension des axes" },
                                { etape: 11, label: "[11] Homing Trancanage" },
                                { etape: 12, label: "[12] Making End queue" },
                                { etape: 13, label: "[13] Mise en position des axes" },
                                { etape: 14, label: "[14] Generation des cams" },
                                { etape: 15, label: "[15] CamIn Tranc et Bob" },
                                { etape: 16, label: "[16] CamIn MaitreVirtuel" },
                                { etape: 17, label: "[17] Pause" },
                                { etape: 18, label: "[18] Scaling Came" },
                                { etape: 20, label: "[20] Starting Bobinage" },
                                { etape: 21, label: "[21] Bobinage Running" },
                                { etape: 30, label: "[30] Homing" },
                                { etape: 31, label: "[31] Bobinoir Set Position" },
                                { etape: 32, label: "[32] Stop Bobinoir" },
                                { etape: 33, label: "[33] Making Queue" },
                                { etape: 40, label: "[40] Waiting Bobbin Bucket UP Position" },
                                { etape: 50, label: "[50] Waiting Bobbin Compressor Opened" },
                                { etape: 60, label: "[60] Waiting Bobbin Bucket Middle Position" },
                                { etape: 70, label: "[70] Waiting Thread Guide Up Position" },
                                { etape: 80, label: "[80] Closing Yarn Catcher" },
                                { etape: 90, label: "[90] Supplying Cone" },
                                { etape: 100, label: "[100] Waiting Bobbin Compressor Closed" },
                                { etape: 110, label: "[110] Cutting Yarn" },
                                { etape: 120, label: "[120] Waiting Bobbin Bucket DOWN Position" },
                                { etape: 130, label: "[130] Waiting Yarn Catcher Opened" },
                                { etape: 140, label: "[140] Waiting Thread Guide Down Position" },
                                { etape: 999, label: "[999] Magazin Not Safe" },
                                { etape: 1000, label: "[1000] Yarn Catcher Not Safe" },
                                { etape: -100, label: "[-100] Soft Reset" }
                            ]
                            textRole: "label"
                            onActivated: {
                                console.log("Writing " + model[currentIndex].etape + " to OPCUANode")
                                opcuaNode.setValue(parseFloat(model[currentIndex].etape))
                            }
                            onCurrentIndexChanged: {
                                console.log("Current index Changed")
                                console.log("Étape sélectionnée :", currentText)
                                console.log("Code de l'étape :", model[currentIndex].etape)
                                console.log("index :", currentIndex)
                                // opcuaNode.setValue(model[currentIndex].etape)
                                // Exemple : envoyer le code à une variable ou un automate
                                // myVar = model[currentIndex].code
                            }
                            indicator.visible:  clickable
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if( parent.clickable ){
                                        parent.popup.open()  // Ouvre manuellement le menu déroulant
                                    }
                                }
                            }
                            OpcUaMonitoredNode {
                                monitored: root.visible
                                id: opcuaNode
                                nodeId: "Arp.Plc.Eclr/etatBobinoir"
                                onValueChanged: {
                                    for (var i = 0; i < parent.model.length; i++) {
                                        if (parent.model[i].etape === value) {
                                            parent.currentIndex = i
                                            break
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

            GridLayout {
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                columnSpacing: Constants.dp(25)
                rowSpacing: Constants.dp(5)

                StyledFrame {
                    id: paraffineFrameBtn
                    Layout.alignment: Qt.AlignTop
                    style: "shadowed"
                    Layout.preferredHeight: Constants.dp(110)
                    Layout.preferredWidth: Constants.dp(350)
                    padding: 0
                    Layout.row: 1
                    Layout.column: 1

                    shadowColor: manuelBobinoirButton.checked ? "#deae2a" : checkboxParaffine.checked ? "#35a646" : "black"

                    Label {
                        text: "Paraffines"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.centerIn: parent
                        font.bold: true
                        font.pixelSize: Constants.sp(30)
                        color: appTheme.bodyText
                    }

                    Rectangle {
                        id: checkboxParaffine
                        property bool checked: false

                        width: Constants.dp(25)
                        height: width
                        x: parent.width - width - Constants.dp(20)
                        y: Constants.dp(20)
                        radius: height/2
                        color: manuelBobinoirButton.checked ? "#deae2a" : checked ? "#35a646" : "transparent"
                        border.width: 1
                        border.color: (checked || manuelBobinoirButton.checked) ? "transparent" : appTheme.bodyText

                        Image {
	sourceSize: Qt.size(width, height) 
                            anchors.centerIn: parent
                            width: parent.height * 0.6
                            height: width
                            visible: checkboxParaffine.checked && !manuelBobinoirButton.checked
                            source: "../Resources/Images/Check.svg"
                            fillMode: Image.PreserveAspectFit
                        }

                        Rectangle {
                            anchors.centerIn: parent
                            width: parent.height * 0.55
                            radius: 0.5
                            height: 3
                            color: "white"
                            visible: manuelBobinoirButton.checked
                        }

                    }

                    MouseArea {
                        anchors.fill: parent
                        visible: !manuelBobinoirButton.checked
                        onClicked: {
                            checkboxParaffine.checked = !checkboxParaffine.checked
                            opcuaNodeParaffine.setValue(checkboxParaffine.checked)
                        }

                        OpcUaMonitoredNode {
                            monitored: root.visible
                            id: opcuaNodeParaffine
                            nodeId: "Arp.Plc.Eclr/enableParafinage"
                            onValueChanged: {
                                checkboxParaffine.checked = value
                            }
                        }
                    }

                }

                StyledFrame {
                    id: convoyeurFrameBtn
                    style: "shadowed"
                    Layout.preferredHeight: Constants.dp(110)
                    Layout.preferredWidth: Constants.dp(350)
                    Layout.alignment: Qt.AlignTop
                    padding: 0
                    Layout.row: 1
                    Layout.column: 2

                    shadowColor: manuelBobinoirButton.checked ? "#deae2a" : checkboxConvoyeur.checked ? "#35a646" : "black"

                    Label {
                        text: qsTr("Convoyeur")
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.centerIn: parent
                        font.bold: true
                        font.pixelSize: Constants.sp(30)
                        color: appTheme.bodyText
                    }

                    Rectangle {
                        id: checkboxConvoyeur
                        property bool checked: false

                        width: Constants.dp(25)
                        height: width
                        x: parent.width - width - Constants.dp(20)
                        y: Constants.dp(20)
                        radius: height/2
                        color: manuelBobinoirButton.checked ? "#deae2a" : checked ? "#35a646" : "transparent"
                        border.width: 1
                        border.color: (checked || manuelBobinoirButton.checked) ? "transparent" : appTheme.bodyText

                        Image {
	sourceSize: Qt.size(width, height) 
                            anchors.centerIn: parent
                            width: parent.height * 0.6
                            height: width
                            visible: checkboxConvoyeur.checked && !manuelBobinoirButton.checked
                            source: "../Resources/Images/Check.svg"
                            fillMode: Image.PreserveAspectFit
                        }

                        Rectangle {
                            anchors.centerIn: parent
                            width: parent.height * 0.55
                            radius: 0.5
                            height: 3
                            color: "white"
                            visible: manuelBobinoirButton.checked
                        }

                    }

                    MouseArea {
                        anchors.fill: parent
                        visible: !manuelBobinoirButton.checked
                        onClicked: {
                            checkboxConvoyeur.checked = !checkboxConvoyeur.checked
                            opcuaNodeConvoyeur.setValue(checkboxConvoyeur.checked)
                        }

                        OpcUaMonitoredNode {
                            monitored: root.visible
                            id: opcuaNodeConvoyeur
                            nodeId: ""
                            onValueChanged: {
                                checkboxConvoyeur.checked = value
                            }
                        }
                    }

                }

                StyledFrame {
                    id: paraffineDetails
                    style: "thin"
                    Layout.preferredWidth: paraffineFrameBtn.width
                    padding: Constants.dp(20)
                    Layout.row: 2
                    Layout.column: 1
                    visible: manuelBobinoirButton.checked
                    Layout.alignment: Qt.AlignTop

                    ColumnLayout {
                        spacing: Constants.dp(10)
                        width: parent.width

                        RowLayout {
                            Layout.fillWidth: true

                            Label {
                                text: qsTr("Manuel paraffinage")
                                horizontalAlignment: Text.AlignLeft
                                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                                color: appTheme.bodyText
                                font.pixelSize: Constants.sp(18)
                            }

                            Item {Layout.fillWidth: true}

                            CustomSwitch {
                                id: manuelChauffeIR
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                nodeId: "Arp.Plc.Eclr/manuelParafinage"
                                Layout.preferredWidth: implicitWidth * 1.2 * Constants.scaleFactor
                                Layout.preferredHeight: implicitHeight * 1.2 * Constants.scaleFactor
                            }

                        }
                    }
                }

                StyledFrame {
                    id: convoyeurDetails
                    style: "thin"
                    Layout.preferredWidth: paraffineFrameBtn.width
                    padding: Constants.dp(20)
                    Layout.row: 2
                    Layout.column: 2
                    visible: manuelBobinoirButton.checked
                    Layout.alignment: Qt.AlignTop

                    ColumnLayout {
                        spacing: Constants.dp(10)
                        width: parent.width

                        RowLayout {
                            Layout.fillWidth: true

                            Label {
                                text: qsTr("Manuel convoyeur")
                                horizontalAlignment: Text.AlignLeft
                                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                                color: appTheme.bodyText
                                font.pixelSize: Constants.sp(18)
                            }

                            Item {Layout.fillWidth: true}

                            TapisSwitch {
                                id: sliderConvoyeur
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.preferredWidth: paraffineFrameBtn.width * 0.3
                                Layout.preferredHeight: manuelChauffeIR.height
                                locked: true
                                nodeIdForward: "Arp.Plc.Eclr/convoyeurCW"
                                nodeIdBackward: "Arp.Plc.Eclr/convoyeurCCW"
                            }

                        }
                    }
                }

                Item {
                    Layout.preferredHeight: paraffineDetails.height
                    Layout.columnSpan: 2
                    Layout.row: 2
                    Layout.column: 1
                    visible: !manuelBobinoirButton.checked
                }
            }

        }

    }

    Rectangle {
        id: manualAvertissement
        visible: manuelBobinoirButton.checked
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
        id: capteursBobinoirPopup

        width: parent.width * 0.6
        height: parent.height * 0.98
        modal: true
        focus: false
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        anchors.centerIn: parent

        background: Rectangle{
            color: appTheme.backgroundColor
            border.width: 2
            border.color: appTheme.bodyText
            radius: 20 * Constants.scaleFactor
        }

        Item {
            anchors.fill: parent

            ColumnLayout {
                Layout.fillHeight: true
                spacing: Constants.dp(10)

                Label {
                    text: qsTr("Capteurs Bobinoir")
                    font.bold: true
                    font.pixelSize: Constants.sp(22)
                    Layout.alignment: Qt.AlignHCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: appTheme.bodyText

                }

                StyledFrame {
                    id: capteursFrame
                    style: "shadowed"
                    Layout.fillHeight: extended ? true : false
                    padding: Constants.dp(12)

                    Layout.preferredWidth: Math.max(Constants.dp(200), root.width * 0.58)

                    property bool extended: true
                    property real rowHeight: extended ? (height - 2 * padding - 12 * corpsTable.spacing) / 13 : Constants.dp(50)
                    property real columnWidth: (width - 2 * padding - 8 * corpsTable.spacing) / 9

                    ColumnLayout {
                        id: corpsTable
                        anchors.fill: parent
                        spacing: Constants.dp(5)

                        RowLayout {
                            id: titleCapteurRow
                            Repeater {
                                model: ["Spindle",
                                    "Bobbin\nBucket",
                                    "Magazine\nSafety",
                                    "Magazine\nOpen",
                                    "Bobbin\nCompressor",
                                    "Home",
                                    "YarnGuide\nBobbin",
                                    "YarnGuide\nPosition",
                                    "YarnCatcher\nClose"]
                                delegate: ColumnLayout {
                                    required property string modelData
                                    Text {
                                        Layout.preferredWidth: capteursFrame.columnWidth
                                        text: parent.modelData
                                        Layout.alignment: Qt.AlignHCenter
                                        font.pixelSize: Constants.sp(16)
                                        font.bold: true
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignBottom
                                        color: appTheme.bodyText

                                        visible: modelData != "Spindle"
                                    }
                                    ModuleButton {
                                        id: extendButton
                                        checkable: true
                                        Layout.preferredWidth: capteursFrame.columnWidth
                                        Layout.preferredHeight: width * 0.6
                                        Layout.alignment: Qt.AlignHCenter
                                        labelText: checked ? "Spindle\n⮝" : "Spindle\n⮟"
                                        bordered: false
                                        visible: parent.modelData === "Spindle"
                                        checked: true

                                        onCheckedChanged: {
                                            capteursFrame.extended = !capteursFrame.extended
                                        }
                                    }
                                }
                            }
                        }

                        RowLayout {
                            ColumnLayout {
                                id: spindleColumn
                                Layout.preferredWidth: capteursFrame.columnWidth
                                Repeater {
                                    model: capteursFrame.extended ? 12 : 1
                                    Text {
                                        required property int index
                                        Layout.preferredHeight: capteursFrame.rowHeight
                                        text: capteursFrame.extended ? index + 1 : "All"
                                        Layout.alignment: Qt.AlignHCenter
                                        font.pixelSize: Constants.sp(16)
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        color: appTheme.bodyText
                                    }
                                }
                            }

                            ColumnLayout {
                                id: bobbinBucketColumn
                                Repeater {
                                    model: capteursFrame.extended ? 12 : 1
                                    Item {
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        Layout.preferredHeight: capteursFrame.rowHeight
                                        Layout.preferredWidth: capteursFrame.columnWidth
                                        ColumnLayout {
                                            anchors.fill: parent
                                            spacing: 0
                                            StatusIndicator {
                                                id: bobbinBucketUp
                                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                                Layout.preferredWidth: capteursFrame.rowHeight / 3
                                                Layout.preferredHeight: width
                                                nodeId: capteursFrame.extended ? "Arp.Plc.Eclr/sensorBobinoir.bobinoirBucketUp" : "Arp.Plc.Eclr/allBobbinCollectorP1"
                                                index: capteursFrame.extended ? model.index : -1
                                            }
                                            StatusIndicator {
                                                id: bobbinBucketMid
                                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                                Layout.preferredWidth: capteursFrame.rowHeight / 3
                                                Layout.preferredHeight: width
                                                nodeId: capteursFrame.extended ? "Arp.Plc.Eclr/sensorBobinoir.bobinoirBucketMiddle" : "Arp.Plc.Eclr/allBobbinCollectorPM"
                                                index: capteursFrame.extended ? model.index : -1
                                            }
                                            StatusIndicator {
                                                id: bobbinBucketDown
                                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                                Layout.preferredWidth: capteursFrame.rowHeight / 3
                                                Layout.preferredHeight: width
                                                nodeId: capteursFrame.extended ? "Arp.Plc.Eclr/sensorBobinoir.bobinoirBucketDown" : "Arp.Plc.Eclr/allBobbinCollectorP0"
                                                index: capteursFrame.extended ? model.index : -1
                                            }
                                        }
                                    }
                                }
                            }

                            ColumnLayout {
                                id: magazineSafetyColumn
                                Repeater {
                                    model: capteursFrame.extended ? 12 : 1
                                    Item {
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        Layout.preferredHeight: capteursFrame.rowHeight
                                        Layout.preferredWidth: capteursFrame.columnWidth
                                        StatusIndicator {
                                            anchors.centerIn: parent
                                            width: parent.height * 0.8
                                            height: width
                                            color: "red"
                                            nodeId: capteursFrame.extended ? "Arp.Plc.Eclr/sensorBobinoir.magazineSafety" : "Arp.Plc.Eclr/allMagasin"
                                            index: capteursFrame.extended ? model.index : -1
                                            onValueChanged: value == false ? color = "red" : color = "green"
                                        }
                                    }
                                }
                            }

                            ColumnLayout {
                                id: magazineOpenColumn
                                Repeater {
                                    model: capteursFrame.extended ? 12 : 1
                                    Item {
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        Layout.preferredHeight: capteursFrame.rowHeight
                                        Layout.preferredWidth: capteursFrame.columnWidth
                                        StatusIndicator {
                                            anchors.centerIn: parent
                                            width: parent.height * 0.8
                                            height: width
                                            nodeId: capteursFrame.extended ? "Arp.Plc.Eclr/sensorBobinoir.magazineOpen" : "Arp.Plc.Eclr/allSupplierMagasin"
                                            index: capteursFrame.extended ? model.index : -1
                                        }
                                    }
                                }
                            }

                            ColumnLayout {
                                id: bobbinCompressorColumn
                                Repeater {
                                    model: capteursFrame.extended ? 12 : 1
                                    Item {
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        Layout.preferredHeight: capteursFrame.rowHeight
                                        Layout.preferredWidth: capteursFrame.columnWidth
                                        RowLayout {
                                            anchors.fill: parent
                                            spacing: 0
                                            StatusIndicator {
                                                id: bobbinCompressorClose
                                                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                                                Layout.preferredWidth: capteursFrame.rowHeight / 2
                                                Layout.preferredHeight: width
                                                nodeId: capteursFrame.extended ? "Arp.Plc.Eclr/sensorBobinoir.bobinoirCompressorClose" : "Arp.Plc.Eclr/allBobbinCompressorP0"
                                                index: capteursFrame.extended ? model.index : -1
                                            }
                                            StatusIndicator {
                                                id: bobbinCompressorOpen
                                                Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                                                Layout.preferredWidth: capteursFrame.rowHeight / 2
                                                Layout.preferredHeight: width
                                                nodeId: capteursFrame.extended ? "Arp.Plc.Eclr/sensorBobinoir.bobinoirCompressorOpen" : "Arp.Plc.Eclr/allBobbinCompressorP1"
                                                index: capteursFrame.extended ? model.index : -1
                                            }
                                        }
                                    }
                                }
                            }

                            ColumnLayout {
                                id: homeColumn
                                Repeater {
                                    model: capteursFrame.extended ? 12 : 1
                                    Item {
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        Layout.preferredHeight: capteursFrame.rowHeight
                                        Layout.preferredWidth: capteursFrame.columnWidth
                                        StatusIndicator {
                                            anchors.centerIn: parent
                                            width: parent.height * 0.8
                                            height: width
                                            nodeId: capteursFrame.extended ? "Arp.Plc.Eclr/sensorBobinoir.home" : "Arp.Plc.Eclr/allFinDeCourseTrancanage"
                                            index: capteursFrame.extended ? model.index : -1
                                        }
                                    }
                                }
                            }

                            ColumnLayout {
                                id: yarnGuideBobbinColumn
                                Repeater {
                                    model: capteursFrame.extended ? 12 : 1
                                    Item {
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        Layout.preferredHeight: capteursFrame.rowHeight
                                        Layout.preferredWidth: capteursFrame.columnWidth
                                        StatusIndicator {
                                            anchors.centerIn: parent
                                            width: parent.height * 0.8
                                            height: width
                                            nodeId: capteursFrame.extended ? "Arp.Plc.Eclr/sensorBobinoir.yarnGuideBobinoir" : "Arp.Plc.Eclr/allSensor4"
                                            index: capteursFrame.extended ? model.index : -1
                                        }
                                    }
                                }
                            }

                            ColumnLayout {
                                id: yarnGuidePositionColumn
                                Repeater {
                                    model: capteursFrame.extended ? 12 : 1
                                    Item {
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        Layout.preferredHeight: capteursFrame.rowHeight
                                        Layout.preferredWidth: capteursFrame.columnWidth
                                        ColumnLayout {
                                            anchors.fill: parent
                                            spacing: 0
                                            StatusIndicator {
                                                id: yarnGuidePositionDown
                                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                                Layout.preferredWidth: capteursFrame.rowHeight / 2
                                                Layout.preferredHeight: width
                                                nodeId: capteursFrame.extended ? "Arp.Plc.Eclr/sensorBobinoir.yarnGuidePositiondown" : "Arp.Plc.Eclr/allThreadGuideP0"
                                                index: capteursFrame.extended ? model.index : -1
                                            }
                                            StatusIndicator {
                                                id: yarnGuidePositionUp
                                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                                Layout.preferredWidth: capteursFrame.rowHeight / 2
                                                Layout.preferredHeight: width
                                                nodeId: capteursFrame.extended ? "Arp.Plc.Eclr/sensorBobinoir.yarnGuidePositionUp" : "Arp.Plc.Eclr/allThreadGuideP1"
                                                index: capteursFrame.extended ? model.index : -1
                                            }
                                        }
                                    }
                                }
                            }

                            ColumnLayout {
                                id: yarnCatcherClose
                                Repeater {
                                    model: capteursFrame.extended ? 12 : 1
                                    Item {
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        Layout.preferredHeight: capteursFrame.rowHeight
                                        Layout.preferredWidth: capteursFrame.columnWidth
                                        StatusIndicator {
                                            anchors.centerIn: parent
                                            width: parent.height * 0.8
                                            height: width
                                            nodeId: capteursFrame.extended ? "Arp.Plc.Eclr/sensorBobinoir.yarnCatcherClose" : "Arp.Plc.Eclr/allThreadCatcher"
                                            index: capteursFrame.extended ? model.index : -1
                                        }
                                    }
                                }
                            }
                        }

                    }

                }

                // StyledFrame {
                //     id: scenarioFrame
                //     visible: !capteursFrame.extended
                //     style: "shadowed"
                //     Layout.fillHeight: true
                //     Layout.alignment: Qt.AlignHCenter


                // }

                Item {
                    Layout.fillHeight: true
                }

            }



        }

    }
    Popup {
        id: trancanageParametersPopup

        width: parent.width * 0.8
        height: parent.height * 0.95
        modal: true
        focus: false
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        anchors.centerIn: parent

        background: Rectangle{
            color: appTheme.backgroundColor
            border.width: 2
            border.color: appTheme.bodyText
            radius: 20 * Constants.scaleFactor
        }

        Item {
            anchors.fill: parent
            ColumnLayout{
                anchors.fill: parent
                spacing: Constants.dp(5)

                Label {
                    text: qsTr("Paramètres Avancés Bobinoir")
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    font.pixelSize: 28 * Constants.scaleFactor
                    font.bold: true
                    color: appTheme.bodyText
                }

                Rectangle{
                    Layout.preferredHeight: Constants.dp(60)
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    color: "transparent"
                    GridLayout{
                        anchors.centerIn: parent
                        columns: 2
                        columnSpacing: Constants.dp(8)
                        CustomSwitch{
                            onOffText: false
                            nodeId: "Arp.Plc.Eclr/DI_1"
                        }
                        Label{
                            color: appTheme.bodyText
                            font.pixelSize: Constants.sp(18)
                            text: "Reset"
                        }
                    }
                }
                RowLayout{
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.alignment: {
                        Qt.AlignHCenter
                        Qt.AlignVCenter
                    }
                    spacing: Constants.dp(15)
                    Layout.margins: Constants.dp(15)

                    StyledFrame{
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        style: "thin"

                        ColumnLayout{
                            id: servo6
                            anchors {
                                centerIn: parent
                                fill: parent
                            }
                            Label{
                                text: String((servo6Name.value))
                                Layout.alignment: Qt.AlignHCenter
                                font.bold: true
                                color: appTheme.bodyText
                                font.pixelSize: Constants.sp(20)

                                OpcUaMonitoredNode {
                                    monitored: root.visible
                                    id: servo6Name
                                    nodeId: "Arp.Plc.Eclr/gAxis[6].Name"
                                }
                            }
                            Label{
                                color: appTheme.bodyText
                                Layout.alignment: Qt.AlignHCenter
                                OpcUaMonitoredNode {
                                    monitored: root.visible
                                    id: servo6eStatus
                                    nodeId: "Arp.Plc.Eclr/gAxis[6].Status.eStatus"
                                    onValueChanged: {
                                        if (value === 0) {
                                            parent.text = "Status: #DISABLED"
                                        }
                                        else if (value === 1){
                                            parent.text = "Status: #STANDSTILL"
                                        }
                                        else if (value === 2){
                                            parent.text = "Status: #HOMING"
                                        }
                                        else if (value === 3){
                                            parent.text = "Status: #ERRORSTOP"
                                        }
                                        else if (value === 4){
                                            parent.text = "Status: #STOPPING"
                                        }
                                        else if (value === 5){
                                            parent.text = "Status: #DISCRETE_MOTION"
                                        }
                                        else if (value === 6){
                                            parent.text = "Status: #CONTINUOUS_MOTION"
                                        }
                                        else if (value === 7){
                                            parent.text = "Status: #SYNCHRONYZED_MOTION"
                                        }
                                        else if (value === 8){
                                            parent.text = "Status: #None"
                                        }
                                    }
                                }
                            }
                            Label {
                                color: appTheme.bodyText
                                Layout.alignment: Qt.AlignHCenter
                                OpcUaMonitoredNode {
                                    monitored: root.visible
                                    id: servo6CamState
                                    nodeId: "Arp.Plc.Eclr/gAxis[6].Status.Cam.CamState"
                                    onValueChanged: {
                                        if (value === -1) {
                                            parent.text = "State: #ErrorReadingState"
                                        }
                                        else if (value === 0){
                                            parent.text = "State: #Not Engaged"
                                        }
                                        else if (value === 1){
                                            parent.text = "State: #Waiting to Engage"
                                        }
                                        else if (value === 2){
                                            parent.text = "State: #Engaging"
                                        }
                                        else if (value === 3){
                                            parent.text = "State: #Engaged"
                                        }
                                        else if (value === 4){
                                            parent.text = "State: #Waiting to Disengage"
                                        }
                                        else if (value === 5){
                                            parent.text = "State: #Disengaging"
                                        }
                                    }
                                }
                            }

                            ModuleButton {
                                Layout.preferredHeight: implicitHeight
                                Layout.preferredWidth: parent.width * 0.3
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                labelText: "Initialiser"
                                nodeId: ""
                                bordered: false
                            }

                            GridLayout{
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                columns: 2
                                rowSpacing: Constants.dp(10)
                                columnSpacing: Constants.dp(10)
                                Label{
                                    color: appTheme.bodyText
                                    text: "Power"
                                }
                                CustomSwitch{
                                    nodeId: "Arp.Plc.Eclr/gAxis[6].Cmd.Power"
                                }
                                Label{
                                    color: appTheme.bodyText
                                    text: "Jog_Forward"
                                }
                                CustomSwitch{
                                    nodeId: "Arp.Plc.Eclr/gAxis[6].Cmd.Jog_Forward"
                                }
                                Label{
                                    color: appTheme.bodyText
                                    text: "Jog_Reverse"
                                }
                                CustomSwitch{
                                    nodeId: "Arp.Plc.Eclr/gAxis[6].Cmd.Jog_Reverse"
                                }
                                Label{
                                    color: appTheme.bodyText
                                    text: "Home"
                                }
                                CustomSwitch{
                                    nodeId: "Arp.Plc.Eclr/gAxis[6].Cmd.MoveAbs"
                                }
                                Label{
                                    color: appTheme.bodyText
                                    text: "Cam"
                                }
                                RowLayout{
                                    CustomSwitch{
                                        nodeId: "Arp.Plc.Eclr/gAxis[6].Cmd.Camin"
                                    }
                                    Rectangle{
                                        width: 25
                                        height: width
                                        radius: width/2
                                        property bool active/*: trancanageToDegresInSync.value*/
                                        color: active ? "green" : "red"
                                        OpcUaMonitoredNode {
                                            monitored: root.visible
                                            // id: trancanageToDegresInSync
                                            nodeId: "Arp.Plc.Eclr/gAxis[6].Status.Cam.InSync"
                                            onValueChanged: parent.active = value

                                        }
                                    }
                                }
                                Label{
                                    color: appTheme.bodyText
                                    text: "Stop"
                                }
                                CustomSwitch{
                                    nodeId: "Arp.Plc.Eclr/gAxis[6].Cmd.Stop"
                                }
                                Label{
                                    color: appTheme.bodyText
                                    text: "Position"
                                }
                                NumericInput{
                                    nodeId: "Arp.Plc.Eclr/gAxis[6].Values.Position"
                                    readOnly: true
                                    min: -1000
                                    max: 1000
                                    digit: 2
                                }
                                Label{
                                    color: appTheme.bodyText
                                    text: "Vitesse"
                                }
                                NumericInput{
                                    readOnly: true
                                    min: -1000
                                    max: 1000
                                    nodeId: "Arp.Plc.Eclr/gAxis[6].Values.Velocity"
                                    digit: 2
                                }
                            }
                        }
                    }

                    StyledFrame{
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        style: "thin"

                        ColumnLayout{
                            id: servo1
                            anchors {
                                centerIn: parent
                                fill: parent
                            }
                            Label{
                                text: String(servo1Name.value)
                                Layout.alignment: Qt.AlignHCenter
                                font.bold: true
                                color: appTheme.bodyText
                                font.pixelSize: Constants.sp(20)
                                OpcUaMonitoredNode {
                                    monitored: root.visible
                                    id: servo1Name
                                    nodeId: "Arp.Plc.Eclr/gAxis[1].Name"
                                }
                            }
                            Label{
                                Layout.alignment: Qt.AlignHCenter
                                color: appTheme.bodyText
                                OpcUaMonitoredNode {
                                    monitored: root.visible
                                    id: servo1eStatus
                                    nodeId: "Arp.Plc.Eclr/gAxis[1].Status.eStatus"
                                    onValueChanged: {
                                        if (value === 0) {
                                            parent.text = "Status: #DISABLED"
                                        }
                                        else if (value === 1){
                                            parent.text = "Status: #STANDSTILL"
                                        }
                                        else if (value === 2){
                                            parent.text = "Status: #HOMING"
                                        }
                                        else if (value === 3){
                                            parent.text = "Status: #ERRORSTOP"
                                        }
                                        else if (value === 4){
                                            parent.text = "Status: #STOPPING"
                                        }
                                        else if (value === 5){
                                            parent.text = "Status: #DISCRETE_MOTION"
                                        }
                                        else if (value === 6){
                                            parent.text = "Status: #CONTINUOUS_MOTION"
                                        }
                                        else if (value === 7){
                                            parent.text = "Status: #SYNCHRONYZED_MOTION"
                                        }
                                        else if (value === 8){
                                            parent.text = "Status: #None"
                                        }
                                    }
                                }
                            }
                            Label {
                                Layout.alignment: Qt.AlignHCenter
                                color: appTheme.bodyText
                                OpcUaMonitoredNode {
                                    monitored: root.visible
                                    id: servo1CamState
                                    nodeId: "Arp.Plc.Eclr/gAxis[1].Status.Cam.CamState"
                                    onValueChanged: {
                                        if (value === -1) {
                                            parent.text = "State: #ErrorReadingState"
                                        }
                                        else if (value === 0){
                                            parent.text = "State: #Not Engaged"
                                        }
                                        else if (value === 1){
                                            parent.text = "State: #Waiting to Engage"
                                        }
                                        else if (value === 2){
                                            parent.text = "State: #Engaging"
                                        }
                                        else if (value === 3){
                                            parent.text = "State: #Engaged"
                                        }
                                        else if (value === 4){
                                            parent.text = "State: #Waiting to Disengage"
                                        }
                                        else if (value === 5){
                                            parent.text = "State: #Disengaging"
                                        }
                                    }
                                }
                            }

                            ModuleButton {
                                Layout.preferredHeight: implicitHeight
                                Layout.preferredWidth: parent.width * 0.3
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                labelText: "Initialiser"
                                nodeId: ""
                                bordered: false
                            }

                            GridLayout{
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                columns: 2
                                rowSpacing: Constants.dp(10)
                                columnSpacing: Constants.dp(10)

                                Label{
                                    text: "Power"
                                    color: appTheme.bodyText
                                }
                                CustomSwitch{
                                    nodeId: "Arp.Plc.Eclr/gAxis[1].Cmd.Power"
                                }
                                Label{
                                    text: "Jog_Forward"
                                    color: appTheme.bodyText
                                }
                                CustomSwitch{
                                    nodeId: "Arp.Plc.Eclr/gAxis[1].Cmd.Jog_Forward"
                                }
                                Label{
                                    text: "Jog_Reverse"
                                    color: appTheme.bodyText
                                }
                                CustomSwitch{
                                    nodeId: "Arp.Plc.Eclr/gAxis[1].Cmd.Jog_Reverse"
                                }
                                Label{
                                    text: "Home"
                                    color: appTheme.bodyText
                                }
                                CustomSwitch{
                                    nodeId: "Arp.Plc.Eclr/gAxis[1].Cmd.MoveAbs"
                                }
                                Label{
                                    text: "Cam"
                                    color: appTheme.bodyText
                                }
                                RowLayout{
                                    CustomSwitch{
                                        nodeId: "Arp.Plc.Eclr/gAxis[1].Cmd.Camin"
                                    }
                                    Rectangle{
                                        width: 25
                                        height: width
                                        radius: width/2
                                        property bool active/*: trancanageToDegresInSync.value*/
                                        color: active ? "green" : "red"
                                        OpcUaMonitoredNode {
                                            monitored: root.visible
                                            id: trancanageToDegresInSync
                                            nodeId: "Arp.Plc.Eclr/gAxis[1].Status.Cam.InSync"
                                            onValueChanged: parent.active = value

                                        }
                                    }
                                }
                                Label{
                                    text: "SetPosition"
                                    color: appTheme.bodyText
                                }
                                CustomSwitch{
                                    nodeId: "Arp.Plc.Eclr/gAxis[1].Cmd.SetPosition"
                                }
                                Label{
                                    color: appTheme.bodyText
                                    text: "Stop"
                                }
                                CustomSwitch{
                                    nodeId: "Arp.Plc.Eclr/gAxis[1].Cmd.Stop"
                                }
                                Label{
                                    text: "Position"
                                    color: appTheme.bodyText
                                }
                                NumericInput{
                                    readOnly: true
                                    nodeId: "Arp.Plc.Eclr/gAxis[1].Values.Position"
                                    min: -1000
                                    max: 1000
                                    digit: 2
                                }
                                Label{
                                    text: "Vitesse"
                                    color: appTheme.bodyText
                                }
                                NumericInput{
                                    readOnly: true
                                    nodeId: "Arp.Plc.Eclr/gAxis[1].Values.Position"
                                    min: -1000
                                    max: 1000
                                    digit: 2
                                }
                            }
                        }
                    }

                    StyledFrame{
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        style: "thin"

                        ColumnLayout{
                            id: servo3
                            anchors {
                                centerIn: parent
                                fill: parent
                            }
                            Label{
                                text: String(servo2Name.value)
                                Layout.alignment: Qt.AlignHCenter
                                font.bold: true
                                color: appTheme.bodyText
                                font.pixelSize: Constants.sp(20)

                                OpcUaMonitoredNode {
                                    monitored: root.visible
                                    id: servo2Name
                                    nodeId: "Arp.Plc.Eclr/gAxis[2].Name"
                                }
                            }
                            Label{
                                Layout.alignment: Qt.AlignHCenter
                                color: appTheme.bodyText
                                OpcUaMonitoredNode {
                                    monitored: root.visible
                                    id: servo3eStatus
                                    nodeId: "Arp.Plc.Eclr/gAxis[2].Status.eStatus"
                                    onValueChanged: {
                                        if (value === 0) {
                                            parent.text = "Status: #DISABLED"
                                        }
                                        else if (value === 1){
                                            parent.text = "Status: #STANDSTILL"
                                        }
                                        else if (value === 2){
                                            parent.text = "Status: #HOMING"
                                        }
                                        else if (value === 3){
                                            parent.text = "Status: #ERRORSTOP"
                                        }
                                        else if (value === 4){
                                            parent.text = "Status: #STOPPING"
                                        }
                                        else if (value === 5){
                                            parent.text = "Status: #DISCRETE_MOTION"
                                        }
                                        else if (value === 6){
                                            parent.text = "Status: #CONTINUOUS_MOTION"
                                        }
                                        else if (value === 7){
                                            parent.text = "Status: #SYNCHRONYZED_MOTION"
                                        }
                                        else if (value === 8){
                                            parent.text = "Status: #None"
                                        }
                                    }
                                }
                            }
                            Label {
                                Layout.alignment: Qt.AlignHCenter
                                color: appTheme.bodyText
                                OpcUaMonitoredNode {
                                    monitored: root.visible
                                    id: servo2CamState
                                    nodeId: "Arp.Plc.Eclr/gAxis[2].Status.Cam.CamState"
                                    onValueChanged: {
                                        if (value === -1) {
                                            parent.text = "State: #ErrorReadingState"
                                        }
                                        else if (value === 0){
                                            parent.text = "State: #Not Engaged"
                                        }
                                        else if (value === 1){
                                            parent.text = "State: #Waiting to Engage"
                                        }
                                        else if (value === 2){
                                            parent.text = "State: #Engaging"
                                        }
                                        else if (value === 3){
                                            parent.text = "State: #Engaged"
                                        }
                                        else if (value === 4){
                                            parent.text = "State: #Waiting to Disengage"
                                        }
                                        else if (value === 5){
                                            parent.text = "State: #Disengaging"
                                        }
                                    }
                                }
                            }

                            ModuleButton {
                                Layout.preferredHeight: implicitHeight
                                Layout.preferredWidth: parent.width * 0.3
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                labelText: "Initialiser"
                                nodeId: ""
                                bordered: false
                            }

                            GridLayout{
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                columns: 2
                                rowSpacing: Constants.dp(10)
                                columnSpacing: Constants.dp(10)
                                Label{
                                    text: "Power"
                                    color: appTheme.bodyText
                                }
                                CustomSwitch{
                                    nodeId: "Arp.Plc.Eclr/gAxis[2].Cmd.Power"
                                }
                                Label{
                                    text: "Jog_Forward"
                                    color: appTheme.bodyText
                                }
                                CustomSwitch{
                                    nodeId: "Arp.Plc.Eclr/gAxis[2].Cmd.Jog_Forward"
                                }
                                Label{
                                    text: "Jog_Reverse"
                                    color: appTheme.bodyText
                                }
                                CustomSwitch{
                                    nodeId: "Arp.Plc.Eclr/gAxis[2].Cmd.Jog_Reverse"
                                }
                                Label{
                                    text: "Home"
                                    color: appTheme.bodyText
                                }
                                CustomSwitch{
                                    nodeId: "Arp.Plc.Eclr/gAxis[2].Cmd.MoveAbs"
                                }
                                Label{
                                    text: "Cam"
                                    color: appTheme.bodyText
                                }
                                RowLayout{
                                    CustomSwitch{
                                        nodeId: "Arp.Plc.Eclr/gAxis[2].Cmd.Camin"
                                    }
                                    Rectangle{
                                        width: 25
                                        height: width
                                        radius: width/2
                                        property bool active/*: trancanageToDegresInSync.value*/
                                        color: active ? "green" : "red"
                                        OpcUaMonitoredNode {
                                            monitored: root.visible
                                            id: camTrancanage360ToMMInSync
                                            nodeId: "Arp.Plc.Eclr/gAxis[2].Status.Cam.InSync"
                                            onValueChanged: parent.active = value
                                        }
                                    }
                                }
                                Label{
                                    text: "Stop"
                                    color: appTheme.bodyText
                                }
                                CustomSwitch{
                                    nodeId: "Arp.Plc.Eclr/gAxis[2].Cmd.Stop"
                                }
                                Label{
                                    text: "Position"
                                    color: appTheme.bodyText
                                }
                                NumericInput{
                                    readOnly: true
                                    min: -1000
                                    max: 1000
                                    nodeId: "Arp.Plc.Eclr/gAxis[2].Values.Position"
                                    digit: 2
                                }
                                Label{
                                    text: "Vitesse"
                                    color: appTheme.bodyText
                                }
                                NumericInput{
                                    readOnly: true
                                    min: -1000
                                    max: 1000
                                    nodeId: "Arp.Plc.Eclr/gAxis[2].Values.Velocity"
                                    digit: 2
                                }
                            }
                        }
                    }

                    StyledFrame{
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        style: "thin"

                        ColumnLayout{
                            id: servo4
                            anchors {
                                centerIn: parent
                                fill: parent
                            }
                            Label{
                                text: String(servo4Name.value)
                                Layout.alignment: Qt.AlignHCenter
                                font.bold: true
                                color: appTheme.bodyText
                                font.pixelSize: Constants.sp(20)

                                OpcUaMonitoredNode {
                                    monitored: root.visible
                                    id: servo4Name
                                    nodeId: "Arp.Plc.Eclr/gAxis[3].Name"
                                }
                            }
                            Label{
                                color: appTheme.bodyText
                                Layout.alignment: Qt.AlignHCenter
                                OpcUaMonitoredNode {
                                    monitored: root.visible
                                    id: servo4eStatus
                                    nodeId: "Arp.Plc.Eclr/gAxis[3].Status.eStatus"
                                    onValueChanged: {
                                        if (value === 0) {
                                            parent.text = "Status: #DISABLED"
                                        }
                                        else if (value === 1){
                                            parent.text = "Status: #STANDSTILL"
                                        }
                                        else if (value === 2){
                                            parent.text = "Status: #HOMING"
                                        }
                                        else if (value === 3){
                                            parent.text = "Status: #ERRORSTOP"
                                        }
                                        else if (value === 4){
                                            parent.text = "Status: #STOPPING"
                                        }
                                        else if (value === 5){
                                            parent.text = "Status: #DISCRETE_MOTION"
                                        }
                                        else if (value === 6){
                                            parent.text = "Status: #CONTINUOUS_MOTION"
                                        }
                                        else if (value === 7){
                                            parent.text = "Status: #SYNCHRONYZED_MOTION"
                                        }
                                        else if (value === 8){
                                            parent.text = "Status: #None"
                                        }
                                    }
                                }
                            }
                            Label {
                                color: appTheme.bodyText
                                Layout.alignment: Qt.AlignHCenter
                                OpcUaMonitoredNode {
                                    monitored: root.visible
                                    id: servo3CamState
                                    nodeId: "Arp.Plc.Eclr/gAxis[3].Status.Cam.CamState"
                                    onValueChanged: {
                                        if (value === -1) {
                                            parent.text = "State: #ErrorReadingState"
                                        }
                                        else if (value === 0){
                                            parent.text = "State: #Not Engaged"
                                        }
                                        else if (value === 1){
                                            parent.text = "State: #Waiting to Engage"
                                        }
                                        else if (value === 2){
                                            parent.text = "State: #Engaging"
                                        }
                                        else if (value === 3){
                                            parent.text = "State: #Engaged"
                                        }
                                        else if (value === 4){
                                            parent.text = "State: #Waiting to Disengage"
                                        }
                                        else if (value === 5){
                                            parent.text = "State: #Disengaging"
                                        }
                                    }
                                }
                            }

                            ModuleButton {
                                Layout.preferredHeight: implicitHeight
                                Layout.preferredWidth: parent.width * 0.3
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                labelText: "Initialiser"
                                nodeId: ""
                                bordered: false
                            }

                            GridLayout{
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                columns: 2
                                rowSpacing: Constants.dp(10)
                                columnSpacing: Constants.dp(10)
                                Label{
                                    color: appTheme.bodyText
                                    text: "Power"
                                }
                                CustomSwitch{
                                    nodeId: "Arp.Plc.Eclr/gAxis[3].Cmd.Power"
                                }
                                Label{
                                    color: appTheme.bodyText
                                    text: "Jog_Forward"
                                }
                                CustomSwitch{
                                    nodeId: "Arp.Plc.Eclr/gAxis[3].Cmd.Jog_Forward"
                                }
                                Label{
                                    color: appTheme.bodyText
                                    text: "Jog_Reverse"
                                }
                                CustomSwitch{
                                    nodeId: "Arp.Plc.Eclr/gAxis[3].Cmd.Jog_Reverse"
                                }
                                Label{
                                    color: appTheme.bodyText
                                    text: "Home"
                                }
                                CustomSwitch{
                                    nodeId: "Arp.Plc.Eclr/gAxis[3].Cmd.MoveAbs"
                                }
                                Label{
                                    color: appTheme.bodyText
                                    text: "Cam"
                                }
                                CustomSwitch{
                                    nodeId: "Arp.Plc.Eclr/gAxis[3].Cmd.Camin"
                                }
                                Label{
                                    color: appTheme.bodyText
                                    text: "Stop"
                                }
                                CustomSwitch{
                                    nodeId: "Arp.Plc.Eclr/gAxis[3].Cmd.Stop"
                                }
                                Label{
                                    color: appTheme.bodyText
                                    text: "Position"
                                }
                                NumericInput{
                                    nodeId: "Arp.Plc.Eclr/gAxis[3].Values.Position"
                                    readOnly: true
                                    min: -1000
                                    max: 1000
                                    digit: 2
                                }
                                Label{
                                    color: appTheme.bodyText
                                    text: "Vitesse"
                                }
                                NumericInput{
                                    readOnly: true
                                    min: -1000
                                    max: 1000
                                    nodeId: "Arp.Plc.Eclr/gAxis[3].Values.Velocity"
                                    digit: 2
                                }
                            }
                        }
                    }

                }

                RowLayout {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    spacing: Constants.dp(20)

                    ColumnLayout {

                        Label {
                            text: "OnFlyAdjust Scale"
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            font.pixelSize: Constants.sp(15)
                            color: appTheme.bodyText
                        }

                        CustomSwitch {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            Layout.preferredHeight: Constants.dp(40)
                            Layout.preferredWidth: height * 2
                            nodeId: "Arp.Plc.Eclr/gAxis[6].Cam.OnFlyAdjust.Scale"
                        }

                    }
                    ColumnLayout {

                        Label {
                            text: "Numerator Scale Bobinage"
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            font.pixelSize: Constants.sp(15)
                            color: appTheme.bodyText
                        }

                        NumericInput {
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredWidth: Constants.dp(80)
                            Layout.maximumHeight: Constants.dp(70)
                            Layout.fillHeight: true
                            Layout.minimumHeight: Constants.dp(30)
                            horizontalAlignment: Text.AlignHCenter
                            unit: qsTr("")
                            min: 0
                            max: 10000
                            nodeId: "Arp.Plc.Eclr/numeratorScaleBobinage"
                            font.pixelSize: Constants.sp(16)
                        }

                    }
                    ColumnLayout {

                        Label {
                            text: "Denominator Scale Bobinage"
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            font.pixelSize: Constants.sp(15)
                            color: appTheme.bodyText
                        }

                        NumericInput {
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredWidth: Constants.dp(80)
                            Layout.maximumHeight: Constants.dp(70)
                            Layout.fillHeight: true
                            Layout.minimumHeight: Constants.dp(30)
                            horizontalAlignment: Text.AlignHCenter
                            unit: qsTr("")
                            min: 0
                            max: 10000
                            nodeId: "Arp.Plc.Eclr/denominatorScaleBobinage"
                            font.pixelSize: Constants.sp(16)
                        }

                    }

                    ComboBox {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredHeight: Constants.dp(40)
                        Layout.preferredWidth: Constants.dp(160)
                        font.pixelSize: Constants.sp(16)

                        model: [
                            { etape: 1, label: "camX1_33r0_36.csv" },
                            { etape: 2, label: "camX2_66r0_36.csv" },
                            { etape: 3, label: "camX2_83r0_36.csv" },
                            { etape: 4, label: "camX3_16r0_36.csv" },
                            { etape: 5, label: "camX3_33r0_36.csv" }
                        ]
                        textRole: "label"

                        indicator.visible: false

                        OpcUaMonitoredNode {
                            monitored: root.visible
                            nodeId: "Arp.Plc.Eclr/gAxis[6].Cam.CamFile_CSV"
                            onValueChanged: {
                                for (var i = 0; i < parent.model.length; i++) {
                                    if (parent.model[i].label === value) {
                                        parent.currentIndex = i
                                        break
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
