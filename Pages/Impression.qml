import QtQuick.Controls
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import Bobink
import "../"
import "../Resources/Components"
import "../utils.js" as Utils

Item {
    id: _item
    width: 1600
    height: 800

    property int levelPercent: 85
    property alias switchSortieReto : switchSortieReto
    property alias switchEntréeReto : switchEntréeReto
    property alias switchSortiePompeIn : switchSortiePompeIn
    property alias switchEntréePompeIn : switchEntréePompeIn
    property alias switchPurgeEgoutOn_Off : switchPurgeEgoutOn_Off
    property alias switchEntréePurge: switchEntréePurge
    property alias switchPurgerTete: switchPurgerTete
    property alias switchPrimerTete: switchPrimerTete
    property alias switchCleanSystème: switchCleanSystème

    property int machineId: 0

    // Connections {
    //     target: Bobink
    //     onPrintHeadStatusReceived: stats => {
    //                                    // console.log("XPL PH STATUS")
    //                                    var pHOK_count = 0
    //                                    for(var i = 0 ; i < listModelPHMSelection.count ; i++ ){
    //                                        // console.log("PH " + (i+1) + " status: " + Utils.isPHOk(stats, i))
    //                                        listModelPHMSelection.setProperty(i, "status", Utils.isPHOk(stats, i))
    //                                        if (Utils.isPHOk(stats, i)) {
    //                                            pHOK_count ++
    //                                        }
    //                                    }

    //                                    if (pHOK_count === 6) {
    //                                        indicatorAllHeads.color = "green"
    //                                    } else {
    //                                        indicatorAllHeads.color = "red"
    //                                    }
    //                                }
    // }

    Timer {
        id: getStatusTimer
        running: true
        repeat: true
        triggeredOnStart: true
        interval: 2500

        //onTriggered: QBobinkModel.sendXPLPHStatus(_item.machineId)
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Constants.dp(40)
        anchors.bottomMargin: Constants.dp(1)
        spacing: Constants.dp(20)

        RowLayout {
            Layout.fillWidth: true
            spacing: Constants.dp(15)

            Text {
                Layout.fillWidth: true

                text: qsTr("Impression")
                font.pixelSize: Math.max(35, parent.width * 0.037)
                font.bold: true
                color: appTheme.bodyText
            }

            Item { Layout.fillWidth: true }

            // StatusIndicatorTricolor {
            //     id: impressionGlobalStatus
            //     Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            //     Layout.preferredWidth: Constants.dp(45)
            //     Layout.preferredHeight: width
            //     nodeIdRed: "Arp.Plc.Eclr/tricolorRougeImpression"
            //     nodeIdYellow: "Arp.Plc.Eclr/tricolorOrangeImpression"
            //     nodeIdGreen: "Arp.Plc.Eclr/tricolorVertImpression"
            // }

        }

        RowLayout {
            spacing: Constants.dp(10)
            StyledFrame {
                id: mainFrame
                style: "shadowed"
                Layout.fillHeight: true
                Layout.preferredWidth: 0.7 * _item.width
                padding: Constants.dp(40)

                shadowColor: allOnOffPHM.checked ? "#35a646" : "black"

                Item {
                    RowLayout {
                        spacing: 100
                        GridLayout {
                            columnSpacing: 100
                            layoutDirection: Qt.LeftToRight
                            flow: GridLayout.LeftToRight
                            columns: 4
                            rowSpacing: 25

                            Rectangle {
                                id: arriveeEau
                                Layout.row: 0
                                Layout.column: 0
                                Layout.preferredWidth: 100 * Constants.scaleFactor
                                Layout.preferredHeight: 140 * Constants.scaleFactor
                                color: "light grey"
                                border.width: 0
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                radius: 15

                                ColumnLayout {
                                    anchors.fill: parent

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        text: qsTr("Eau")
                                        font.bold: true
                                        font.pointSize: 12
                                    }
                                    CustomSwitch {
                                        id : switchArriveeEauOnOff
                                        onOffText: true
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        nodeId:"Arp.Plc.Eclr/"
                                    }
                                    CustomSwitch {
                                        id : switchArriveeEau
                                        onOffText: false
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        nodeId:"Arp.Plc.Eclr/eau_cuve"
                                    }
                                }

                            }

                            // Rectangle {
                            //     Layout.row: 4
                            //     Layout.column: 1
                            //     Layout.preferredWidth: 250 * Constants.scaleFactor
                            //     Layout.preferredHeight: 60 * Constants.scaleFactor
                            //     color: "light grey"
                            //     border.width: 0
                            //     Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            //     radius: 15

                            // Text {
                            //     anchors.horizontalCenter: parent.horizontalCenter
                            //     anchors.verticalCenter: parent.verticalCenter
                            //     text: qsTr("Egout")
                            //     font.bold: true
                            //     font.pointSize: 12
                            // }

                            Image {
	sourceSize: Qt.size(width, height) 
                                id: egout
                                Layout.row: 4
                                Layout.column: 1
                                Layout.alignment: Qt.AlignHCenter
                                Layout.preferredHeight: 105 * Constants.scaleFactor
                                Layout.preferredWidth: height
                                source: "../Resources/Images/Egout.svg"
                                fillMode: Image.PreserveAspectFit
                            }
                            // }

                            Rectangle {
                                id: cuveInk
                                Layout.row: 1
                                Layout.column: 0
                                Layout.preferredWidth: 65 * Constants.scaleFactor
                                Layout.preferredHeight: 265 * Constants.scaleFactor
                                color: "light grey"
                                border.width: 0
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                radius: 15
                                Layout.rowSpan: 3



                                Text {
                                    id: cuveInkText
                                    text: qsTr("Cuve Ink")
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    font.bold: true
                                    y: Constants.dp(10)
                                }

                                GaugeBar {
                                    id: progressBar
                                    rotation: -90
                                    anchors.horizontalCenter: cuveInk.horizontalCenter
                                    y: cuveInk.y - width * 0.4

                                    nodeId: "Arp.Plc.Eclr/niveauCuveImpression"
                                }



                            }

                            Rectangle {
                                id: pompeReto
                                Layout.row: 2
                                Layout.column: 1
                                Layout.preferredWidth: 250 * Constants.scaleFactor
                                Layout.preferredHeight: 100 * Constants.scaleFactor
                                color: "light grey"
                                border.width: 0
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                radius: 15

                                RowLayout {
                                    anchors.fill: parent
                                    spacing: 5
                                    CustomSwitch {
                                        id: switchSortieReto
                                        rotation: 90
                                        onOffText: false
                                        nodeId:"Arp.Plc.Eclr/enableEVKNFReturn"
                                    }

                                    ColumnLayout {
                                        Text {
                                            text: qsTr("Pompe Sortie")
                                            horizontalAlignment: Text.AlignHCenter
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            font.bold: true
                                            font.pointSize: 12
                                        }

                                        CustomSwitch {
                                            id: switchEntréeReto
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            text: qsTr("ON/OFF")
                                            nodeId:"Arp.Plc.Eclr/pompeRetourManuelImpression"
                                        }
                                    }
                                }


                            }

                            Rectangle {
                                id: pompeIn
                                Layout.row: 1
                                Layout.column: 1
                                Layout.preferredWidth: 250 * Constants.scaleFactor
                                Layout.preferredHeight: 100 * Constants.scaleFactor
                                color: "light grey"
                                border.width: 0
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                radius: 15

                                RowLayout {
                                    anchors.fill: parent
                                    spacing: 5
                                    CustomSwitch {
                                        id: switchEntréePompeIn
                                        rotation: -90
                                        onOffText: false
                                        nodeId: "Arp.Plc.Eclr/enableEVKNFIn"
                                    }
                                    ColumnLayout {
                                        Text {
                                            text: qsTr("Pompe Entrée")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            font.bold: true
                                            font.pointSize: 12
                                        }
                                        CustomSwitch {
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            id: switchSortiePompeIn
                                            onOffText: true
                                            nodeId:"Arp.Plc.Eclr/pompeInManuelImpression"
                                        }

                                    }
                                }
                            }

                            Rectangle {
                                id: purgeEgout
                                Layout.row: 3
                                Layout.column: 1
                                Layout.preferredWidth: 250 * Constants.scaleFactor
                                Layout.preferredHeight: 100 * Constants.scaleFactor
                                color: "light grey"
                                border.width: 0
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                radius: 15

                                RowLayout {
                                    anchors.fill: parent
                                    spacing: 5

                                    CustomSwitch {
                                        id: switchEntréePurge
                                        rotation: -90
                                        onOffText: false
                                        nodeId: "Arp.Plc.Eclr/enableEVFP400Purge"
                                    }


                                    ColumnLayout {

                                        Text {
                                            text: qsTr("Purge égout")
                                            horizontalAlignment: Text.AlignHCenter
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            font.bold: true
                                            font.pointSize: 12
                                        }

                                        CustomSwitch {
                                            id : switchPurgeEgoutOn_Off
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId:"Arp.Plc.Eclr/pompeEgoutManuelImpression"
                                        }
                                    }
                                }

                            }

                            Rectangle {
                                id: phmBlock
                                Layout.row: 0
                                Layout.column: 2
                                Layout.preferredHeight: mainFrame.height - mainFrame.padding * 2
                                Layout.preferredWidth: mainFrame.width - mainFrame.padding * 2 - 200 - arriveeEau.width - pompeReto.width
                                color: "transparent"
                                border.color: "transparent"
                                border.width: 1
                                radius: 5
                                Layout.rowSpan: 5

                                StyledFrame {
                                    anchors.fill: parent
                                    padding: Constants.dp(25)

                                    ColumnLayout {
                                        anchors.fill: parent

                                        RowLayout {
                                            Layout.alignment: Qt.AlignHCenter
                                            spacing: Constants.dp(25)

                                            Item {
                                                Layout.preferredWidth: indicatorAllHeads.width

                                            }

                                            Text {
                                                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                                                text: qsTr("Têtes d'impression")
                                                font.pixelSize: Constants.sp(30)
                                                color: appTheme.bodyText
                                                font.bold: true
                                            }

                                            StatusIndicator {
                                                id: indicatorAllHeads
                                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                                value: true
                                            }

                                        }

                                        RowLayout {
                                            Layout.alignment: Qt.AlignHCenter
                                            spacing: Constants.dp(20)

                                            Text {
                                                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                                                text: qsTr("DC")
                                                font.pixelSize: Constants.sp(25)
                                                color: appTheme.bodyText
                                            }

                                            NumericInput {
                                                id: numInputDC
                                                Layout.alignment: Qt.AlignHCenter
                                                Layout.preferredWidth: phmBlock.width * 0.33
                                                Layout.preferredHeight: width * 0.4
                                                horizontalAlignment: Text.AlignHCenter
                                                unit: qsTr("%")
                                                digit: 1
                                                min: 0
                                                max: 100
                                                nodeId: ""
                                            }

                                        }

                                        ModuleButton {
                                            id: btnSetDrive
                                            Layout.alignment: Qt.AlignHCenter
                                            labelText: qsTr("Set Drive")
                                            Layout.preferredWidth: phmBlock.width * 0.42
                                            Layout.preferredHeight: Constants.dp(50)
                                            maxFontSize: Constants.sp(28)
                                            bordered: false

                                            onClicked: {
                                                for(var i = 1 ; i < listModelPHMSelection.count + 1 ; i++ ){
                                                    QBobinkModel.sendXPLPHPWM(_item.machineId, i, 100, parseInt(numInputDC.numericPart))
                                                }
                                            }
                                        }

                                        CustomOnOff {
                                            id: allOnOffPHM
                                            Layout.alignment: Qt.AlignHCenter
                                                              | Qt.AlignVCenter
                                            nodeId: ""
                                            Layout.preferredWidth: implicitWidth * 1.75
                                            Layout.preferredHeight: implicitHeight * 1.75

                                            onCheckedChanged: {
                                                let newPhStates = [1, 1, 2, 1, 3, 1, 4, 1, 5, 1, 6, 1, 7, 1, 8, 1]
                                                if (checked) {
                                                    for(var i = 0 ; i < listModelPHMSelection.count ; i++ ){
                                                        newPhStates[2 * i + 1] = listModelPHMSelection.get(i).value === true ? 1 : 0
                                                    }
                                                } else {
                                                    newPhStates = [1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8, 0]
                                                }
                                                console.log(newPhStates)
                                                QBobinkModel.sendXPLPHArrayActivate(_item.machineId, newPhStates)
                                            }
                                        }

                                        RowLayout {
                                            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                                            spacing: Constants.dp(10)

                                            Text {
                                                text: qsTr("Sélection des têtes")
                                                font.pixelSize: Constants.sp(18)
                                                color: appTheme.bodyText
                                                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                                            }

                                            OptionButton {
                                                id: deepPHM
                                                Layout.preferredWidth: Constants.dp(35)
                                                Layout.preferredHeight: width
                                                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                                                nodeId: ""

                                                onClicked: deepPHMpopup.open()
                                            }
                                        }

                                    }

                                }

                            }
                        }

                    }
                    Shape {
                        id: arrowEauToPompeIn
                        width: 1
                        height: 1
                        //anchors.fill: parent
                        property int arrowEau_PompeIn: switchEntréePompeIn.checked
                        property color arrowColor: arrowEau_PompeIn && switchArriveeEauOnOff.checked && switchArriveeEau. checked ? "#029ae6" : "black"
                        property real arrowWidth: switchArriveeEau. checked && arrowEau_PompeIn ? 5 : 2

                        ShapePath {
                            strokeColor: arrowEauToPompeIn.arrowColor
                            strokeWidth: arrowEauToPompeIn.arrowWidth
                            fillColor: "transparent"

                            startX: arriveeEau.x + arriveeEau.width * 2 / 3
                            startY: arriveeEau.y + arriveeEau.height

                            PathLine {
                                x: arriveeEau.x + arriveeEau.width * 2 / 3
                                y: pompeIn.y + pompeIn.height / 3
                            }
                            PathLine {
                                x: pompeIn.x - 10
                                y: pompeIn.y + pompeIn.height / 3
                            }

                            // Pointe
                            PathMove {
                                x: pompeIn.x
                                y: pompeIn.y + pompeIn.height / 3
                            }
                            PathLine {
                                x: pompeIn.x - 10
                                y: pompeIn.y + pompeIn.height / 3 - 5
                            }
                            PathLine {
                                x: pompeIn.x - 10
                                y: pompeIn.y + pompeIn.height / 3 + 5
                            }
                            PathLine {
                                x: pompeIn.x
                                y: pompeIn.y + pompeIn.height / 3
                            }
                        }
                    }
                    Shape {
                        id: arrowEauToCuve
                        width: 1
                        height: 1
                        property int arrowEau_Cuve: switchArriveeEau.checked
                        property color arrowColor: !arrowEau_Cuve && switchArriveeEauOnOff.checked ? "#029ae6" : "black"
                        property real arrowWidth: arrowEau_Cuve ? 2 : 5

                        ShapePath {
                            id: shapeEauToCuve
                            strokeColor: arrowEauToCuve.arrowColor
                            strokeWidth: arrowEauToCuve.arrowWidth
                            fillColor: "transparent"

                            startX: arriveeEau.x + arriveeEau.width * 1 / 3
                            startY: arriveeEau.y + arriveeEau.height

                            PathLine {
                                x: shapeEauToCuve.startX
                                y: cuveInk.y - 10
                            }

                            // Pointe
                            PathLine {
                                x: shapeEauToCuve.startX + 5
                                y: cuveInk.y - 10
                            }
                            PathLine {
                                x: shapeEauToCuve.startX
                                y: cuveInk.y
                            }
                            PathLine {
                                x: shapeEauToCuve.startX - 5
                                y: cuveInk.y - 10
                            }
                            PathLine {
                                x: shapeEauToCuve.startX
                                y: cuveInk.y - 10
                            }
                        }
                    }
                    Shape {
                        id: arrowPompeInToPHM
                        width: 1
                        height: 1 // dummy size, we use absolute position
                        //anchors.fill: parent
                        property int arrowPompeIn_Phm: switchSortiePompeIn.checked
                        property color arrowColor: switchSortiePompeIn.checked ? !switchEntréePompeIn.checked ? "green" :
                                                                                switchArriveeEau.checked && switchArriveeEauOnOff.checked ? "#029ae6" : "black" : "black"
                        property real arrowWidth: arrowPompeIn_Phm === 0 ? 2 : 5

                        ShapePath {
                            strokeColor: arrowPompeInToPHM.arrowColor
                            strokeWidth: arrowPompeInToPHM.arrowWidth
                            fillColor: "transparent"

                            startX: pompeIn.x + pompeIn.width
                            startY: pompeIn.y + pompeIn.height / 2

                            PathLine {
                                x: phmBlock.x - 10
                                y: pompeIn.y + pompeIn.height / 2
                            }

                            // Pointe de flèche
                            PathMove {
                                x: phmBlock.x
                                y: pompeIn.y + pompeIn.height / 2
                            }
                            PathLine {
                                x: phmBlock.x - 10
                                y: pompeIn.y + pompeIn.height / 2 - 5
                            }
                            PathLine {
                                x: phmBlock.x - 10
                                y: pompeIn.y + pompeIn.height / 2 + 5
                            }
                            PathLine {
                                x: phmBlock.x
                                y: pompeIn.y + pompeIn.height / 2
                            }
                        }
                    }
                    Shape {
                        id: arrowPhmToPompeReto
                        width: 1
                        height: 1
                        //anchors.fill: parent
                        property int arrowPhm_Reto: switchEntréeReto.checked
                        property color arrowColor: arrowPhm_Reto === 0 ? "black" : !switchSortieReto.checked ? "green" : "red"
                        property real arrowWidth: arrowPhm_Reto === 0 ? 2 : 5

                        ShapePath {
                            strokeColor: arrowPhmToPompeReto.arrowColor
                            strokeWidth: arrowPhmToPompeReto.arrowWidth
                            fillColor: "transparent"

                            startX: phmBlock.x
                            startY: pompeReto.y + pompeReto.height / 2

                            PathLine {
                                x: pompeReto.x + pompeReto.width + 10
                                y: pompeReto.y + pompeReto.height / 2
                            }

                            PathMove {
                                x: pompeReto.x + pompeReto.width + 0
                                y: pompeReto.y + pompeReto.height / 2
                            }
                            PathLine {
                                x: pompeReto.x + pompeReto.width + 10
                                y: pompeReto.y + pompeReto.height / 2 - 5
                            }
                            PathLine {
                                x: pompeReto.x + pompeReto.width + 10
                                y: pompeReto.y + pompeReto.height / 2 + 5
                            }
                            PathLine {
                                x: pompeReto.x + pompeReto.width + 0
                                y: pompeReto.y + pompeReto.height / 2
                            }
                        }
                    }
                    Shape {
                        id: arrowPhmToPurgeEgout
                        width: 1
                        height: 1
                        //anchors.fill: parent
                        property int arrowPhm_Purge: switchEntréePurge.checked
                        property color arrowColor: arrowPhm_Purge === 0 || !switchPurgeEgoutOn_Off.checked ? "black" : "red"
                        property real arrowWidth: arrowPhm_Purge === 0 ? 2 : 5
                        ShapePath {
                            strokeColor: arrowPhmToPurgeEgout.arrowColor
                            strokeWidth: arrowPhmToPurgeEgout.arrowWidth
                            fillColor: "transparent"

                            startX: phmBlock.x
                            startY: purgeEgout.y - (purgeEgout.y - (pompeReto.y + pompeReto.height)) / 2

                            PathLine {
                                x: phmBlock.x - phmBlock.x + pompeIn.x - 20 * Constants.scaleFactor
                                y: purgeEgout.y - (purgeEgout.y - (pompeReto.y + pompeReto.height)) / 2
                            }
                            PathLine {
                                x: phmBlock.x - phmBlock.x + pompeIn.x - 20 * Constants.scaleFactor
                                y: purgeEgout.y + purgeEgout.height / 3
                            }
                            PathLine {
                                x: purgeEgout.x - 10
                                y: purgeEgout.y + purgeEgout.height / 3
                            }

                            // Pointe de flèche à gauche de purgeEgout
                            PathMove {
                                x: purgeEgout.x
                                y: purgeEgout.y + purgeEgout.height / 3
                            }
                            PathLine {
                                x: purgeEgout.x - 10
                                y: purgeEgout.y + purgeEgout.height / 3 - 5
                            }
                            PathLine {
                                x: purgeEgout.x - 10
                                y: purgeEgout.y + purgeEgout.height / 3 + 5
                            }
                            PathLine {
                                x: purgeEgout.x
                                y: purgeEgout.y + purgeEgout.height / 3
                            }
                        }
                    }
                    Shape {
                        id: arrowCuveToPompeIn
                        width: 1
                        height: 1

                        property int arrowCuve_PompeIn: switchEntréePompeIn.checked
                        property color arrowColor: arrowCuve_PompeIn === 1 || !switchSortiePompeIn.checked ? "black" : "green"
                        property real arrowWidth: arrowCuve_PompeIn === 1 ? 2 : 5

                        ShapePath {
                            id: arrowPath
                            strokeColor: arrowCuveToPompeIn.arrowColor
                            strokeWidth: arrowCuveToPompeIn.arrowWidth
                            fillColor: "transparent"

                            startX: cuveInk.x + cuveInk.width
                            startY: pompeIn.y + pompeIn.height / 1.5

                            PathLine {
                                x: pompeIn.x - 10
                                y: pompeIn.y + pompeIn.height / 1.5
                            }

                            // Pointe de la flèche
                            PathMove {
                                x: pompeIn.x
                                y: pompeIn.y + pompeIn.height / 1.5
                            }
                            PathLine {
                                x: pompeIn.x - 10
                                y: pompeIn.y + pompeIn.height / 1.5 - 5
                            }
                            PathLine {
                                x: pompeIn.x - 10
                                y: pompeIn.y + pompeIn.height / 1.5 + 5
                            }
                            PathLine {
                                x: pompeIn.x
                                y: pompeIn.y + pompeIn.height / 1.5
                            }


                        }
                    }
                    Shape {
                        id: arrowPompeRetoToCuve
                        width: 1
                        height: 1
                        //anchors.fill: parent
                        property int arrowReto_Cuve: !switchSortieReto.checked
                        property color arrowColor: arrowReto_Cuve === 0 || !switchEntréeReto.checked ? "black" : "green"
                        property real arrowWidth: arrowReto_Cuve === 0 ? 2 : 5

                        ShapePath {
                            strokeColor: arrowPompeRetoToCuve.arrowColor
                            strokeWidth: arrowPompeRetoToCuve.arrowWidth
                            fillColor: "transparent"

                            startX: pompeReto.x
                            startY: pompeReto.y + pompeReto.height / 3

                            PathLine {
                                x: cuveInk.x + cuveInk.width + 10
                                y: pompeReto.y + pompeReto.height / 3
                            }

                            PathMove {
                                x: cuveInk.x + cuveInk.width
                                y: pompeReto.y + pompeReto.height / 3
                            }
                            PathLine {
                                x: cuveInk.x + cuveInk.width + 10
                                y: pompeReto.y + pompeReto.height / 3 - 5
                            }
                            PathLine {
                                x: cuveInk.x + cuveInk.width + 10
                                y: pompeReto.y + pompeReto.height / 3 + 5
                            }
                            PathLine {
                                x: cuveInk.x + cuveInk.width
                                y: pompeReto.y + pompeReto.height / 3
                            }
                        }
                    }
                    Shape {
                        id: arrowCuveToPurge
                        width: 1
                        height: 1
                        //anchors.fill: parent
                        property int arrowCuve_Purge: switchEntréePurge.checked
                        property color arrowColor: arrowCuve_Purge === 1 || !switchPurgeEgoutOn_Off.checked ? "black" : "red"
                        property real arrowWidth: arrowCuve_Purge === 1 ? 2 : 5

                        ShapePath {
                            strokeColor: arrowCuveToPurge.arrowColor
                            strokeWidth: arrowCuveToPurge.arrowWidth
                            fillColor: "transparent"

                            startX: cuveInk.x + cuveInk.width / 2
                            startY: cuveInk.y + cuveInk.height

                            // Coude
                            PathLine {
                                x: cuveInk.x + cuveInk.width / 2
                                y: purgeEgout.y + purgeEgout.height * 2 / 3
                            }
                            PathLine {
                                x: purgeEgout.x - 10
                                y: purgeEgout.y + purgeEgout.height * 2 / 3
                            }

                            // Pointe
                            PathMove {
                                x: purgeEgout.x
                                y: purgeEgout.y + purgeEgout.height * 2 / 3
                            }
                            PathLine {
                                x: purgeEgout.x - 10
                                y: purgeEgout.y + purgeEgout.height * 2 / 3 - 5
                            }
                            PathLine {
                                x: purgeEgout.x - 10
                                y: purgeEgout.y + purgeEgout.height * 2 / 3 + 5
                            }
                            PathLine {
                                x: purgeEgout.x
                                y: purgeEgout.y + purgeEgout.height * 2 / 3
                            }
                        }
                    }
                    Shape {
                        id: arrowPompeRetoToEgout
                        width: 1
                        height: 1
                        //anchors.fill: parent
                        property int arrowReto_egout: !switchSortieReto.checked
                        property color arrowColor: arrowReto_egout === 1 || !switchEntréeReto.checked ? "black" : "red"
                        property real arrowWidth: arrowReto_egout === 1 ? 2 : 5

                        ShapePath {
                            strokeColor: arrowPompeRetoToEgout.arrowColor
                            strokeWidth: arrowPompeRetoToEgout.arrowWidth
                            fillColor: "transparent"

                            startX: pompeReto.x
                            startY: pompeReto.y + pompeReto.height * 2 / 3

                            PathLine {
                                x: pompeReto.x - 40
                                y: pompeReto.y + pompeReto.height * 2 / 3
                            }
                            PathLine {
                                x: pompeReto.x - 40
                                y: egout.y + egout.height / 2
                            }
                            PathLine {
                                x: egout.x - 10
                                y: egout.y + egout.height / 2
                            }

                            // Pointe
                            PathMove {
                                x: egout.x
                                y: egout.y + egout.height / 2
                            }
                            PathLine {
                                x: egout.x - 10
                                y: egout.y - 5 + egout.height / 2
                            }
                            PathLine {
                                x: egout.x - 10
                                y: egout.y + 5 + egout.height / 2
                            }
                            PathLine {
                                x: egout.x
                                y: egout.y + egout.height / 2
                            }
                        }
                    }
                    Shape {
                        id: arrowPurgeEgoutToEgout
                        width: 1
                        height: 1
                        //anchors.fill: parent

                        property int arrowPurge_egout: switchPurgeEgoutOn_Off.checked
                        property color arrowColor: arrowPurge_egout === 1 ? "red" : "black"
                        property real arrowWidth: arrowPurge_egout === 1 ? 5 : 2

                        ShapePath {
                            strokeColor: arrowPurgeEgoutToEgout.arrowColor
                            strokeWidth: arrowPurgeEgoutToEgout.arrowWidth
                            fillColor: "transparent"

                            startX: purgeEgout.x + purgeEgout.width
                            startY: purgeEgout.y + purgeEgout.height / 2

                            PathLine {
                                x: purgeEgout.x + purgeEgout.width + 40
                                y: purgeEgout.y + purgeEgout.height / 2
                            }
                            PathLine {
                                x: purgeEgout.x + purgeEgout.width + 40
                                y: egout.y + egout.height / 2
                            }
                            PathLine {
                                x: egout.x + egout.width + 10
                                y: egout.y + egout.height / 2
                            }

                            // Pointe
                            PathMove {
                                x: egout.x + egout.width
                                y: egout.y + egout.height / 2
                            }
                            PathLine {
                                x: egout.x + egout.width + 10
                                y: egout.y + egout.height / 2 - 5
                            }
                            PathLine {
                                x: egout.x + egout.width + 10
                                y: egout.y + egout.height / 2 + 5
                            }
                            PathLine {
                                x: egout.x + egout.width
                                y: egout.y + egout.height / 2
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                spacing: Constants.dp(20)
                StyledFrame {
                    id: framePlateau
                    padding: 20 * Constants.scaleFactor
                    style: "shadowed"
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    ColumnLayout {
                        anchors.fill: parent
                        Text {
                            text: qsTr("Plateau")
                            Layout.fillWidth: false
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            color: appTheme.bodyText
                            font.bold: true
                            font.pixelSize: 28 * Constants.scaleFactor
                        }

                        GridLayout {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            Layout.fillHeight: true
                            columns: 2
                            Layout.margins: 10 * Constants.scaleFactor
                            columnSpacing: 15 * Constants.scaleFactor
                            rowSpacing: 15 * Constants.scaleFactor

                            Label {
                                text: qsTr("Plateau")
                                color: appTheme.bodyText
                                font.pixelSize: 20 * Constants.scaleFactor
                                horizontalAlignment: Text.AlignRight
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            }
                            CustomSwitch {
                                id: switchPurgerTete
                                text: qsTr("")
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.preferredHeight: framePlateau.height * 0.15
                                Layout.preferredWidth: height * 2
                                nodeId: "Arp.Plc.Eclr/enableCanauxImpression"
                                // OPCUANode{
                                //     nodeId:"Arp.Plc.Eclr/verinHaut"
                                // }
                                // OPCUANode{
                                //     nodeId:"Arp.Plc.Eclr/verinBas"
                                // }
                            }
                            Label {
                                text: qsTr("Aspiration")
                                color: appTheme.bodyText
                                font.pixelSize: 20 * Constants.scaleFactor
                                horizontalAlignment: Text.AlignRight
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            }
                            CustomSwitch {
                                id: switchPrimerTete
                                text: qsTr("")
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.preferredHeight: framePlateau.height * 0.15
                                Layout.preferredWidth: height * 2
                                nodeId: "Arp.Plc.Eclr/enableAspirationCanauxImpression"
                                // OPCUANode{
                                //     nodeId:"Arp.Plc.Eclr/hotteAspirante"
                                // }
                            }
                            Label {
                                text: qsTr("Refroidissement")
                                color: appTheme.bodyText
                                font.pixelSize: 20 * Constants.scaleFactor
                                horizontalAlignment: Text.AlignRight
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            }
                            CustomSwitch {
                                id: switchCleanSystème
                                text: qsTr("")
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.preferredHeight: framePlateau.height * 0.15
                                Layout.preferredWidth: height * 2
                                nodeId:"Arp.Plc.Eclr/enableWaterCoolingImpression"

                            }
                        }
                    }
                }

                StyledFrame {
                    visible: false
                    style: "shadowed"
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    padding: 20 * Constants.scaleFactor

                    ColumnLayout {
                        anchors.fill: parent
                        Text {
                            text: qsTr("Tête")
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            color: appTheme.bodyText
                            font.bold: true
                            font.pixelSize: 28 * Constants.scaleFactor
                        }

                        GridLayout {
                            columns: 2
                            Layout.margins: 10 * Constants.scaleFactor
                            rowSpacing: 15 * Constants.scaleFactor
                            columnSpacing: 20 * Constants.scaleFactor
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            Layout.fillHeight: true

                            Button {
                                id: purgerTete
                                checkable: true
                                text: qsTr("Purger Tête")
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                Layout.preferredHeight: 60 * Constants.scaleFactor
                                Layout.preferredWidth: 150 * Constants.scaleFactor

                                background: Item {
                                    anchors.fill: parent
                                    Rectangle {
                                        anchors.fill: parent
                                        gradient: Gradient {
                                            orientation: Gradient.Vertical
                                            GradientStop {position: 0.0; color: "#292929" }
                                            GradientStop {position: 1.0; color: "#F0F0F0"}
                                        }
                                        radius: 16 * Constants.scaleFactor
                                        rotation: purgerTete.checked ? 0 : 180
                                    }
                                    Rectangle {
                                        width: parent.width - 2 * Constants.scaleFactor
                                        height: parent.height - 2 * Constants.scaleFactor
                                        radius: 15 * Constants.scaleFactor
                                        anchors.centerIn: parent
                                        color: purgerTete.checked ? Qt.lighter(appTheme.gradientMid, 1.4) : appTheme.bodyText

                                    }

                                }

                                contentItem: Text {
                                    text: parent.text
                                    color: purgerTete.checked ? "#F0F0F0" : "black"
                                    font.pixelSize: 20 * Constants.scaleFactor
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    anchors.centerIn: parent

                                }

                            }
                            StatusIndicator {
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            }
                            Button {
                                id: primerTete
                                checkable: true
                                text: qsTr("Primer Tête")
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                Layout.preferredHeight: 60 * Constants.scaleFactor
                                Layout.preferredWidth: 150 * Constants.scaleFactor

                                background: Item {
                                    anchors.fill: parent
                                    Rectangle {
                                        anchors.fill: parent
                                        gradient: Gradient {
                                            orientation: Gradient.Vertical
                                            GradientStop {position: 0.0; color: "#292929" }
                                            GradientStop {position: 1.0; color: "#F0F0F0"}
                                        }
                                        radius: 16 * Constants.scaleFactor
                                        rotation: primerTete.checked ? 0 : 180
                                    }
                                    Rectangle {
                                        width: parent.width - 2 * Constants.scaleFactor
                                        height: parent.height - 2 * Constants.scaleFactor
                                        radius: 15 * Constants.scaleFactor
                                        anchors.centerIn: parent
                                        color: primerTete.checked ? Qt.lighter(appTheme.gradientMid, 1.4) : appTheme.bodyText

                                    }

                                }

                                contentItem: Text {
                                    text: parent.text
                                    color: primerTete.checked ? "#F0F0F0" : "black"
                                    font.pixelSize: 20 * Constants.scaleFactor
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    anchors.centerIn: parent

                                }
                            }
                            StatusIndicator {
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            }
                            Button {
                                id: cleanSystem
                                checkable: true
                                text: qsTr("Clean système")
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                Layout.preferredHeight: 60 * Constants.scaleFactor
                                Layout.preferredWidth: 150 * Constants.scaleFactor

                                background: Item {
                                    anchors.fill: parent
                                    Rectangle {
                                        anchors.fill: parent
                                        gradient: Gradient {
                                            orientation: Gradient.Vertical
                                            GradientStop {position: 0.0; color: "#292929" }
                                            GradientStop {position: 1.0; color: "#F0F0F0"}
                                        }
                                        radius: 16 * Constants.scaleFactor
                                        rotation: cleanSystem.checked ? 0 : 180
                                    }
                                    Rectangle {
                                        width: parent.width - 2 * Constants.scaleFactor
                                        height: parent.height - 2 * Constants.scaleFactor
                                        radius: 15 * Constants.scaleFactor
                                        anchors.centerIn: parent
                                        color: cleanSystem.checked ? Qt.lighter(appTheme.gradientMid, 1.4) : appTheme.bodyText

                                    }

                                }

                                contentItem: Text {
                                    text: parent.text
                                    color: cleanSystem.checked ? "#F0F0F0" : "black"
                                    font.pixelSize: 20 * Constants.scaleFactor
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    anchors.centerIn: parent

                                }
                            }
                            StatusIndicator {
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            }
                        }
                    }

                }

                Item { Layout.preferredHeight: parent.height / 2 }
            }

        }
        Item {Layout.fillHeight: true}
    }

    Popup {
        id: deepPHMpopup
        modal: true
        focus: false
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        anchors.centerIn: parent
        height: rowLayoutPHMSwitch.height + deepPHMTitle.height + deepPHMAllOffbtn.height + calibratePHMBtn.height + 5 * Constants.dp(20)
        width: rowLayoutPHMSwitch.width + Constants.dp(50)

        background: Rectangle{
            color: appTheme.backgroundColor
            border.width: 2
            border.color: appTheme.bodyText
            radius: 20 * Constants.scaleFactor
        }
        ColumnLayout {
            anchors.margins: Constants.dp(15)
            spacing: Constants.dp(20)
            anchors.centerIn: parent

            Label {
                id: deepPHMTitle
                text: qsTr("Activation des têtes")
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                font.pixelSize: Constants.sp(28)
                font.bold: true
                color: appTheme.bodyText
            }

            ModuleButton {
                id: calibratePHMBtn
                Layout.alignment: Qt.AlignHCenter
                labelText: qsTr("Calibrer")
                Layout.preferredWidth: Constants.dp(130)
                Layout.preferredHeight: Constants.dp(60)
                maxFontSize: Constants.sp(28)
                bordered: true

                onClicked: {

                }
            }

            RowLayout {
                id: rowLayoutPHMSwitch
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                spacing: Constants.dp(22)
                Repeater {
                    model: listModelPHMSelection
                    delegate: ColumnLayout {
                        spacing: Constants.dp(10)
                        Label {
                            text: number
                            color: appTheme.bodyText
                            font.pixelSize: Constants.dp(20)
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        }

                        CustomSwitch {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            Layout.preferredWidth: implicitWidth * 1.5 * Constants.scaleFactor
                            Layout.preferredHeight: implicitHeight * 1.5 * Constants.scaleFactor
                            checked: !!value
                            disactivated: number === 3 || number === 6
                            enabled: !disactivated
                            onClicked: {
                                if (!disactivated) {
                                    listModelPHMSelection.setProperty(number - 1,"value", checked)
                                }
                            }
                        }

                        StatusIndicator {
                            Layout.alignment: Qt.AlignHCenter
                            value: status
                            color: status ? "green" : "red"

                        }
                    }
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                spacing: Constants.dp(22)

                ModuleButton {
                    id: deepPHMAllOffbtn
                    Layout.alignment: Qt.AlignHCenter
                    labelText: qsTr("All Off")
                    Layout.preferredWidth: Constants.dp(120)
                    Layout.preferredHeight: Constants.dp(50)
                    maxFontSize: Constants.sp(28)
                    bordered: false

                    onClicked: {
                        for(var i = 0 ; i < listModelPHMSelection.count ; i++ ){
                            listModelPHMSelection.setProperty(i,"value",false)
                        }
                    }
                }

                ModuleButton {
                    id: deepPHMAllOnbtn
                    Layout.alignment: Qt.AlignHCenter
                    labelText: qsTr("All On")
                    Layout.preferredWidth: Constants.dp(120)
                    Layout.preferredHeight: Constants.dp(50)
                    maxFontSize: Constants.sp(28)
                    bordered: true

                    onClicked: {
                        for(var i = 0 ; i < listModelPHMSelection.count ; i++ ){
                            if (i !== 2 && i !== 5) {
                                listModelPHMSelection.setProperty(i,"value",true)
                            }
                        }
                    }
                }

            }
        }
    }

    ListModel{
        id: listModelPHMSelection
        ListElement{
            number: 1
            value: false
            status: false
        }
        ListElement{
            number: 2
            value: false
            status: false
        }
        ListElement{
            number: 3
            value: false
            status: false
        }
        ListElement{
            number: 4
            value: false
            status: false
        }
        ListElement{
            number: 5
            value: false
            status: false
        }
        ListElement{
            number: 6
            value: false
            status: false
        }
        ListElement{
            number: 7
            value: false
            status: false
        }
        ListElement{
            number: 8
            value: false
            status: false
        }
    }
}


