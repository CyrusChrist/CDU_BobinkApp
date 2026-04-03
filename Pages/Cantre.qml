
/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../"
import Bobink
import QtQuick.Effects
import "../Resources/Components"

Item {
    id: root

    readonly property int preferedWithTextFieldConsigne: 200
    property alias manuelCantreBtn: manuelCantreBtn

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40 * Constants.scaleFactor
        spacing: 30 * Constants.scaleFactor

        RowLayout {
            Layout.fillWidth: true
            spacing: Constants.dp(15)

            Text {
                text: qsTr("Cantre")
                font.pixelSize: Math.max(35, root.width * 0.037)
                font.bold: true
                color: appTheme.bodyText
            }

            Item { Layout.fillWidth: true }

            ManuelSwitch {
                id: manuelCantreBtn
                nodeId: ""

                onCheckedChanged: {
                    if (checked) {
                        rootApp.currentMode = "Manuel"
                    } else {
                        rootApp.currentMode = "R&D"
                    }
                }
            }

            // StatusIndicatorTricolor {
            //     id: cantreGlobalStatus
            //     Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            //     Layout.preferredWidth: Constants.dp(45)
            //     Layout.preferredHeight: width
            //     nodeIdRed: "Arp.Plc.Eclr/tricolorRougeCantre"
            //     nodeIdYellow: "Arp.Plc.Eclr/tricolorOrangeCantre"
            //     nodeIdGreen: "Arp.Plc.Eclr/tricolorVertCantre"
            // }

        }

        RowLayout{
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignTop
            spacing: Constants.dp(25)


            ////    Consigne    ////
            StyledFrame {
                id: consigneFrame
                style: "shadowed"
                Layout.alignment: Qt.AlignTop

                GroupBox {
                    anchors.fill: parent
                    contentItem: ColumnLayout {
                        id: groupBoxTensionCantre
                        spacing: Constants.dp(20)

                        Label {
                            Layout.preferredWidth: consigneFrame.width * 0.5
                            text: "Consigne générale"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            font.bold: true
                            font.pixelSize: Constants.sp(30)
                            color: appTheme.bodyText
                        }

                        GridLayout {
                            id: gridLayoutConsigne
                            columns: 2
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            columnSpacing: Constants.dp(10)
                            rowSpacing: Constants.dp(20)
                            readonly property int fontSizeTab: Constants.sp(15)

                            Label {
                                text: qsTr("Tension")
                                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                color: appTheme.bodyText
                                font.pixelSize: Constants.sp(20)
                            }
                            NumericInput {
                                id: textfieldTension
                                placeholderText: qsTr("g")
                                Layout.preferredWidth: root.preferedWithTextFieldConsigne
                                Layout.preferredHeight: Constants.dp(50)
                                Layout.alignment: Qt.AlignRight
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                min: 0.5
                                max: 100
                                unit: "g"
                                offset: 0.1
                                nodeId: "ns=6;s=Arp.Plc.Eclr/LGL_Connect.Param.Tension"
                            }


                            Label {
                                text: qsTr("Vitesse moyenne")
                                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                color: appTheme.bodyText
                                font.pixelSize: Constants.sp(20)
                            }
                            NumericInput {
                                id: textFieldVitesseMoyenne
                                readOnly: true
                                Layout.preferredWidth: root.preferedWithTextFieldConsigne
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                min: 0.5
                                max: 100
                                unit: "m/min"
                                nodeId: "ns=6;s=Arp.Plc.Eclr/LGL_Connect.Velocity"
                                digit: 1
                            }

                            Label {
                                text: qsTr("Paramètres avancés")
                                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                color: appTheme.bodyText
                                font.pixelSize: Constants.sp(20)
                            }

                            OptionButton {
                                Layout.preferredWidth: consigneFrame.width * 0.12
                                Layout.preferredHeight: width
                                Layout.alignment: Qt.AlignRight
                                onClicked: consigneDeepPopup.open()
                            }
                        }
                    }

                    background: Rectangle {
                        color: "transparent"
                    }
                }
            }

            StyledFrame {
                id: lGLFrame
                visible: manuelCantreBtn.checked
                style: "shadowed"
                Layout.preferredWidth: root.width * 0.4
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignTop
                shadowColor: "#deae2a"

                ColumnLayout {
                    id: groupBoxLGLCantre
                    spacing: Constants.dp(20)
                    anchors.fill: parent

                    Label {
                        id: lGLFrameTitle
                        text: "Tensioneur"
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font.bold: true
                        font.pixelSize: Constants.sp(30)
                        color: appTheme.bodyText
                    }

                    Item {
                        id: gridBox
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        // -> Paramètres responsive
                        readonly property int rows: feederLGL.count             // nb de lignes de data
                        readonly property real headerH: lGLFrameTitle.implicitHeight + Constants.dp(10)
                        readonly property real rowH: 43 * Constants.scaleFactor // hauteur fixe par ligne
                        readonly property real availableH: Math.max(0, height - headerH)
                        readonly property real computedRowSpacing: // responsive spacing
                                                                   rows > 0 ? Math.max(0, (availableH - rows * rowH) / rows) : 0

                        GridLayout {
                            id: gridLayoutLGL
                            anchors.fill: parent
                            columns: 5
                            columnSpacing: 15 * Constants.scaleFactor
                            rowSpacing: gridBox.computedRowSpacing

                            readonly property int fontSizeHeader: Constants.sp(20)
                            readonly property int fontSizeTab:    Constants.sp(15)

                            // -> Ligne d’en-têtes
                            Label {
                                text: "Fil"
                                Layout.alignment: Qt.AlignHCenter
                                Layout.row: 0; Layout.column: 0
                                color: appTheme.bodyText
                                font.bold: true
                                font.pixelSize: gridLayoutLGL.fontSizeHeader
                                Layout.preferredHeight: gridBox.rowH
                            }
                            Label {
                                text: "Tension"
                                Layout.alignment: Qt.AlignHCenter
                                Layout.row: 0; Layout.column: 1
                                color: appTheme.bodyText
                                font.bold: true
                                font.pixelSize: gridLayoutLGL.fontSizeHeader
                                Layout.preferredHeight: gridBox.rowH
                            }
                            Label {
                                text: "Consigne"
                                Layout.alignment: Qt.AlignHCenter
                                Layout.row: 0; Layout.column: 2
                                color: appTheme.bodyText
                                font.bold: true
                                font.pixelSize: gridLayoutLGL.fontSizeHeader
                                Layout.preferredHeight: gridBox.rowH
                            }
                            Label {
                                text: "Vitesse"
                                Layout.alignment: Qt.AlignHCenter
                                Layout.row: 0; Layout.column: 3
                                color: appTheme.bodyText
                                font.bold: true
                                font.pixelSize: gridLayoutLGL.fontSizeHeader
                                Layout.preferredHeight: gridBox.rowH
                            }
                            Label {
                                text: "Status"
                                Layout.alignment: Qt.AlignHCenter
                                Layout.row: 0; Layout.column: 4
                                color: appTheme.bodyText
                                font.bold: true
                                font.pixelSize: gridLayoutLGL.fontSizeHeader
                                Layout.preferredHeight: gridBox.rowH
                            }

                            // ---- Colonne 0 : Fil ----
                            Repeater {
                                model: feederLGL
                                delegate: Label {
                                    Layout.column: 0
                                    Layout.row: model.index + 1
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    Layout.preferredHeight: gridBox.rowH
                                    text: model.bobine
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    color: appTheme.bodyText
                                    font.pixelSize: gridLayoutLGL.fontSizeTab
                                }
                            }

                            // ---- Colonne 1 : Tension ----
                            Repeater {
                                model: feederLGL
                                delegate: Label {
                                    Layout.column: 1
                                    Layout.row: model.index + 1
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    Layout.preferredHeight: gridBox.rowH
                                    text: model.tension / 10 + " g"
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    color: appTheme.bodyText
                                    font.pixelSize: gridLayoutLGL.fontSizeTab
                                    OpcUaMonitoredNode {
                                        monitored: lGLFrame.visible
                                        nodeId: model.namespace + ".Tension"
                                        onValueChanged: feederLGL.setProperty(index, "tension", value)
                                    }
                                }
                            }

                            // ---- Colonne 2 : Consigne ----
                            Repeater {
                                model: feederLGL
                                delegate: Item {
                                    Layout.column: 2
                                    Layout.row: model.index + 1
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    Layout.preferredWidth: 90 * Constants.scaleFactor
                                    Layout.preferredHeight: gridBox.rowH
                                    NumericInput {
                                        anchors.fill: parent
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        font.pixelSize: gridLayoutLGL.fontSizeTab
                                        unit: "g"; offset: 0.1; min: 0.5; max: 100
                                        nodeId: model.namespace + ".Consigne"
                                    }
                                }
                            }

                            // ---- Colonne 3 : Vitesse ----
                            Repeater {
                                model: feederLGL
                                delegate: Item {
                                    Layout.column: 3
                                    Layout.row: model.index + 1
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    Layout.preferredWidth: 100 * Constants.scaleFactor
                                    Layout.preferredHeight: gridBox.rowH
                                    Label {
                                        anchors.fill: parent
                                        text: model.vitesse + " m/min"
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        color: appTheme.bodyText
                                        font.pixelSize: gridLayoutLGL.fontSizeTab
                                        OpcUaMonitoredNode {
                                            monitored: lGLFrame.visible
                                            nodeId: model.namespace + ".Vitesse"
                                            onValueChanged: feederLGL.setProperty(index, "vitesse", value.toString())
                                        }
                                    }
                                }
                            }

                            // ---- Colonne 4 : Status ----
                            Repeater {
                                model: feederLGL
                                delegate: StatusIndicator {
                                    Layout.column: 4
                                    Layout.row: model.index + 1
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    Layout.preferredHeight: gridBox.rowH * 0.9
                                    Layout.preferredWidth: gridBox.rowH * 0.9
                                    value: model.enable || model.erreur
                                    color: model.erreur ? "red" : "green"
                                    OpcUaMonitoredNode {
                                        monitored: lGLFrame.visible; nodeId: model.namespace + ".Enable";
                                        onValueChanged: feederLGL.setProperty(index + 1, "enable", value) }
                                    OpcUaMonitoredNode {
                                        monitored: lGLFrame.visible; nodeId: model.namespace + ".Erreur";
                                        onValueChanged: feederLGL.setProperty(index + 1, "erreur", value) }
                                }
                            }
                        }
                    }
                }
            }
        }

        Item { Layout.fillHeight: true }
    }

    ListModel {
        id: feederLGL
        ListElement {
            bobine: "1"
            namespace: "ns=6;s=Arp.Plc.Eclr/LGL_Connect.Spin[1]"
            consigne: "0.0"
            tension: 0.0
            vitesse: "0"
            erreurID: "0"
            enable: false
            erreur: false
        }
        ListElement {
            bobine: "2"
            namespace: "ns=6;s=Arp.Plc.Eclr/LGL_Connect.Spin[2]"
            consigne: "0.0"
            tension: 0.0
            vitesse: "0"
            erreurID: "0"
            enable: false
            erreur: false
        }
        ListElement {
            bobine: "3"
            namespace: "ns=6;s=Arp.Plc.Eclr/LGL_Connect.Spin[3]"
            consigne: "0.0"
            tension: 0.0
            vitesse: "0"
            erreurID: "0"
            enable: false
            erreur: false
        }
        ListElement {
            bobine: "4"
            namespace: "ns=6;s=Arp.Plc.Eclr/LGL_Connect.Spin[4]"
            consigne: "0.0"
            tension: 0.0
            vitesse: "0"
            erreurID: "0"
            enable: false
            erreur: false
        }
        ListElement {
            bobine: "5"
            namespace: "ns=6;s=Arp.Plc.Eclr/LGL_Connect.Spin[5]"
            consigne: "0.0"
            tension: 0.0
            vitesse: "0"
            erreurID: "0"
            enable: false
            erreur: false
        }
        ListElement {
            bobine: "6"
            namespace: "ns=6;s=Arp.Plc.Eclr/LGL_Connect.Spin[6]"
            consigne: "0.0"
            tension: 0.0
            vitesse: "0"
            erreurID: "0"
            enable: false
            erreur: false
        }
        ListElement {
            bobine: "7"
            namespace: "ns=6;s=Arp.Plc.Eclr/LGL_Connect.Spin[7]"
            consigne: "0.0"
            tension: 0.0
            vitesse: "0"
            erreurID: "0"
            enable: false
            erreur: false
        }
        ListElement {
            bobine: "8"
            namespace: "ns=6;s=Arp.Plc.Eclr/LGL_Connect.Spin[8]"
            consigne: "0.0"
            tension: 0.0
            vitesse: "0"
            erreurID: "0"
            enable: false
            erreur: false
        }
        ListElement {
            bobine: "9"
            namespace: "ns=6;s=Arp.Plc.Eclr/LGL_Connect.Spin[9]"
            consigne: "0.0"
            tension: 0.0
            vitesse: "0"
            erreurID: "0"
            enable: false
            erreur: false
        }
        ListElement {
            bobine: "10"
            namespace: "ns=6;s=Arp.Plc.Eclr/LGL_Connect.Spin[10]"
            consigne: "0.0"
            tension: 0.0
            vitesse: "0"
            erreurID: "0"
            enable: false
            erreur: false
        }
        ListElement {
            bobine: "11"
            namespace: "ns=6;s=Arp.Plc.Eclr/LGL_Connect.Spin[11]"
            consigne: "0.0"
            tension: 0.0
            vitesse: "0"
            erreurID: "0"
            enable: false
            erreur: false
        }
        ListElement {
            bobine: "12"
            namespace: "ns=6;s=Arp.Plc.Eclr/LGL_Connect.Spin[12]"
            consigne: "0.0"
            tension: 0.0
            vitesse: "0"
            erreurID: "0"
            enable: false
            erreur: false
        }
    }

    Popup {
        id: consigneDeepPopup
        modal: true
        focus: false
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        anchors.centerIn: parent
        height: 400 * Constants.scaleFactor
        width: 600 * Constants.scaleFactor

        background: Rectangle{
            color: appTheme.backgroundColor
            border.width: 2
            border.color: appTheme.bodyText
            radius: 20 * Constants.scaleFactor
        }

        GridLayout {
            id: gridLayoutConsigneDeep
            columns: 2
            anchors.fill: parent
            rowSpacing: columnSpacing * 1.2
            columnSpacing: Constants.dp(15)
            readonly property int fontSizeTab: Constants.sp(20)

            Label {
                text: qsTr("Paramètres consignes avancés")
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                font.bold: true
                color: appTheme.bodyText
                font.pixelSize: gridLayoutConsigneDeep.fontSizeTab * 1.5
                Layout.columnSpan: 2
            }

            Label {
                // visible: (Authentification.currentUserType > 2) ? true : false
                text: qsTr("Bobine length")
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                color: appTheme.bodyText
                font.pixelSize: gridLayoutConsigneDeep.fontSizeTab
            }
            NumericInput {
                readOnly: true
                // visible: (Authentification.currentUserType > 2) ? true : false
                Layout.preferredWidth: root.preferedWithTextFieldConsigne
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: gridLayoutConsigneDeep.fontSizeTab
                min: 0.5
                max: 100
                unit: "m"
            }
            Label {
                // visible: (Authentification.currentUserType > 2) ? true : false
                text: qsTr("Consigne Detection de Tension")
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                color: appTheme.bodyText
                font.pixelSize: gridLayoutConsigneDeep.fontSizeTab
            }
            NumericInput {
                // visible: (Authentification.currentUserType > 2) ? true : false
                id: textfieldConsigneDetectionTension
                placeholderText: qsTr("g")
                Layout.preferredWidth: root.preferedWithTextFieldConsigne
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: gridLayoutConsigneDeep.fontSizeTab
                offset: 0.1
                digit: 1
                min: 0.5
                max: 100
                unit: "g"
                nodeId: "ns=6;s=Arp.Plc.Eclr/LGL_Connect.Param.SeuilDetectionTension"
            }
            Label {
                // visible: (Authentification.currentUserType > 2) ? true : false
                text: qsTr("Consigne Detection de Vitesse")
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                color: appTheme.bodyText
                font.pixelSize: gridLayoutConsigneDeep.fontSizeTab
            }
            NumericInput {
                // visible: (Authentification.currentUserType > 2) ? true : false
                id: textfieldConsigneDetectionVitesse
                placeholderText: qsTr("m/min")
                Layout.preferredWidth: root.preferedWithTextFieldConsigne
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                min: 0.5
                max: 100
                unit: "m/min"
                nodeId: "ns=6;s=Arp.Plc.Eclr/LGL_Connect.Param.SeuilDetectionVitesse"
                font.pixelSize: gridLayoutConsigneDeep.fontSizeTab
            }

        }


    }

    Rectangle {
        id: manualAvertissement
        visible: manuelCantreBtn.checked
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
}


