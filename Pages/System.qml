import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VectorImage
import "../Resources/Components"
import "../"
import Bobink

Item {
    buttonUserMouseArea.onClicked: {loginPopup.open()}

    id: _item
    width: Constants.width
    height: Constants.height

    // property Window rootWindow: Qt.application.activeWindow

    //property alias consomationModel: consomationElectriqueModel
    property alias groupBoxConsomationElectrique: groupBoxConsomationElectrique
    property alias gridLayoutGroupBoxConsomationElectrique: columnLayoutGroupBoxConsomationElectrique
    property alias buttonUserMouseArea: buttonUserMouseArea

    property real consoFrameHeight: consoFrame.height

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40 * Constants.scaleFactor
        spacing: 40 * Constants.scaleFactor

        RowLayout {
            id: topTitleLayout
            Text {
                Layout.fillWidth: true

                text: qsTr("Paramètres système")
                font.pixelSize: Math.max(35, parent.width * 0.037)
                font.bold: true
                color: appTheme.bodyText
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10 * Constants.scaleFactor

                Label {
                    text: qsTr("Compte")
                    font.pixelSize: 20 * Constants.scaleFactor
                    font.bold: true
                    color: appTheme.bodyText
                }

                Button {
                    property int userType: 0
                    property bool isHovered: false
                    property list<string> userTypeIcon: ["UserOperateur", "UserOperateur", "UserMaintenance", "UserIngenieur", "UserAdmin"]
                    property list<string> userRoleText: [qsTr("Ahmed"), qsTr(
                            "Opérateur"), qsTr("Maintenance"), qsTr(
                            "Engineer"), qsTr("Admin")]
                    id: buttonUser
                    Layout.preferredHeight: topTitleLayout.height * 0.9
                    Layout.preferredWidth: height
                    Layout.alignment: Qt.AlignHCenter

                    VectorImage {
                        anchors.fill: parent
                        source: "../Resources/Images/" + buttonUser.userTypeIcon[1] + ".svg"
                    }

                    background: Rectangle {
                        color: buttonUser.isHovered ? appTheme.gradientLight1 : "transparent"
                        width: parent.width - 3 * Constants.scaleFactor
                        height: parent.height - 3 * Constants.scaleFactor
                        anchors.centerIn: parent
                        radius: height / 2
                    }

                    MouseArea {
                        id: buttonUserMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onEntered: buttonUser.isHovered = true
                        onExited: buttonUser.isHovered = false
                    }
                }
            }
        }

        RowLayout {
            spacing: 20 * Constants.scaleFactor

            StyledFrame {
                id: consoFrame

                Layout.preferredHeight: _item.height - topTitleLayout.height
                                        - 100 * Constants.scaleFactor
                style: "shadowed"

                GroupBox {
                    id: groupBoxConsomationElectrique
                    anchors.fill: parent
                    contentItem: ColumnLayout {
                        spacing: Constants.spacing * 1.5

                        Label {
                            id: labelTitrePreTraitement
                            color: "#F0F0F0"
                            text: "Consommation Electrique"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                            font.pixelSize: 27 * Constants.scaleFactor
                            Layout.alignment: Qt.AlignHCenter
                        }

                        ColumnLayout {
                            id: columnLayoutGroupBoxConsomationElectrique
                            spacing: Constants.spacing
                        }
                    }

                    background: Rectangle {
                        color: "transparent"
                    }
                }
            }

            ColumnLayout {
                spacing: 20 * Constants.scaleFactor

                StyledFrame {
                    id: frameCmdSyst
                    style: "shadowed"

                    GroupBox {
                        id: groupBoxCommandeSysteme
                        contentItem: ColumnLayout {
                            spacing: Constants.spacing * 1.5

                            Label {

                                text: "Commande Systeme"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.bold: true
                                font.pixelSize: 25 * Constants.scaleFactor
                                color: appTheme.bodyText
                            }
                        }
                        ModuleButton {
                            id: rebootControlleur
                            labelText: "Redémarrer\nControleur"
                            Layout.preferredWidth: parent.width
                            Layout.preferredHeight: 60 * Constants.scaleFactor
                            nodeId: "ns=6;s=Arp.Plc.Eclr/rebootController"
                        }

                        background: Rectangle {
                            color: "transparent"
                        }
                    }
                }

                StyledFrame {
                    style: "shadowed"
                    Layout.preferredWidth: frameCmdSyst.width

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: Constants.spacing * 2
                        Label {

                            text: "Affichage"
                            Layout.alignment: Qt.AlignHCenter
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                            font.pixelSize: 25 * Constants.scaleFactor
                            color: appTheme.bodyText
                        }

                        ModuleButton {
                            id: maximiseButton
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredWidth: frameCmdSyst.width * 0.55
                            Layout.preferredHeight: 65 * Constants.scaleFactor
                            checkable: true

                            labelText: maximiseButton.checked ? qsTr("Plein écran") : qsTr(
                                                                    "Fenêtré")

                            onCheckedChanged: Constants.fullScreen = !Constants.fullScreen
                        }

                        RowLayout {
                            spacing: Constants.spacing
                            // anchors.centerIn: parent
                            Label {
                                text: "Mode\nclair/sombre"
                                Layout.alignment: Qt.AlignHCenter
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.bold: true
                                font.pixelSize: 20 * Constants.scaleFactor
                                color: appTheme.bodyText
                            }
                            CustomSwitch {
                                id: themeSwitch
                                checkable: true
                                checked: true
                                Layout.alignment: Qt.AlignHCenter
                                Layout.preferredHeight: width / 2
                                Layout.preferredWidth: frameCmdSyst.width * 0.35
                                onOffText: false

                                onCheckedChanged: {
                                    if (!checked) {
                                        appTheme.setLightTheme()
                                    }
                                    else {
                                        appTheme.setDarkTheme()
                                    }

                                }
                            }
                        }
                    }
                }

                StyledFrame {
                    style: "shadowed"
                    Layout.preferredWidth: frameCmdSyst.width

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: Constants.dp(8)

                        // Label {
                        //     text: "Autres"
                        //     Layout.alignment: Qt.AlignHCenter
                        //     horizontalAlignment: Text.AlignHCenter
                        //     verticalAlignment: Text.AlignVCenter
                        //     font.bold: true
                        //     font.pixelSize: 25 * Constants.scaleFactor
                        //     color: appTheme.bodyText
                        // }

                        MenuButton {
                            id: sliderBtnAxis
                            buttonImage: "../Images/MENU_axis.svg"
                            btnColor: Qt.darker(appTheme.backgroundColor, 1.3)
                            backgroundOpacity: 1
                            labelText: qsTr("Options des axes")
                            Layout.preferredWidth: frameCmdSyst.width - 2 * frameCmdSyst.padding
                            Layout.preferredHeight: mainWindow.height * 0.06
                            slideBehavior: false
                            onClicked: {
                                checked = false
                                stackLayoutPage.currentIndex = 10
                            }
                        }
                        MenuButton {
                            id: sliderBtnSchema
                            buttonImage: "../Images/MENU_schema.svg"
                            btnColor: Qt.darker(appTheme.backgroundColor, 1.3)
                            backgroundOpacity: 1
                            labelText: qsTr("Schéma")
                            Layout.fillWidth: true
                            Layout.preferredHeight: sliderBtnAxis.height
                            slideBehavior: false
                            onClicked: {
                                checked = false
                                stackLayoutPage.currentIndex = 8
                            }
                        }
                    }
                }

                StyledFrame {
                    style: "shadowed"
                    Layout.preferredWidth: frameCmdSyst.width

                    ColumnLayout {
                        anchors.centerIn: parent
                        Layout.fillWidth: true
                        spacing: Constants.dp(8)

                        Label {
                            text: "Version"
                            Layout.alignment: Qt.AlignHCenter
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                            font.pixelSize: 25 * Constants.scaleFactor
                            color: appTheme.bodyText
                        }

                        Label {
                            id: versionLabel
                            text: "HMI version " + Constants.version
                            font.pixelSize: Constants.sp(18)
                            color: appTheme.bodyText
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                    }
                }

                Item {
                    Layout.fillHeight: true
                }
            }

            StyledFrame {
                id: frameStopHorsTension
                style: "shadowed"

                property bool poweringOn: home.currentState === 2

                GroupBox {
                    contentItem: ColumnLayout {
                        spacing: Constants.spacing * 1.5

                        Label {
                            text: frameStopHorsTension.poweringOn ? "Mise sous tension" : "Mettre hors tension"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                            font.pixelSize: 25 * Constants.scaleFactor
                            color: appTheme.bodyText
                        }

                        PowerButton {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            isGlowing: frameStopHorsTension.poweringOn

                            onCheckedChanged: {
                                if (checked) {
                                    home.onPlayPauseChecked(home.powerButton)
                                }
                            }
                        }
                    }

                    background: Rectangle {
                        color: "transparent"
                    }
                }
            }

        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }


    Repeater {
        id: consoRepeater
        parent: gridLayoutGroupBoxConsomationElectrique
        model: consomationElectriqueModel
        delegate:
            RowLayout {
                spacing: 20 * Constants.scaleFactor

                Label {
                    text: qsTr(model.text)
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    Layout.alignment: Qt.AlignRight
                    Layout.preferredWidth: 150 * Constants.scaleFactor
                    color: appTheme.bodyText
                    rightPadding: 8 * Constants.scaleFactor
                    font.pixelSize: consoFrameHeight * 22 / 750
                }

                NumericInput {
                    id: textFieldkW
                    readOnly: true
                    unit:" kW"
                    horizontalAlignment: Text.AlignLeft
                    selectByMouse: false
                    autoScroll: false
                    activeFocusOnPress: false
                    Layout.preferredWidth: height * 2.5
                    Layout.preferredHeight: (consoFrameHeight - 175 * Constants.scaleFactor) / consoRepeater.count
                    placeholderText: qsTr("kW")
                    min:0
                    max: min
                    nodeId: model.namespace + ".Valeur"
                    digit: 3
                    nodeIdReset: model.namespace + ".RaZ"
                }
            }
    }

    ListModel {
        id: consomationElectriqueModel
        ListElement {
            text: "Cantre"
            namespace: "ns=6;s=Arp.Plc.Eclr/compteurCantre"
            value: 0.0
            RaZ: false
        }
        ListElement {
            text: "Pré-Traitement"
            namespace: "ns=6;s=Arp.Plc.Eclr/compteurPreTraitement"
            value: 0.0
            RaZ: false
        }
        ListElement {
            text: "Fours"
            namespace: "ns=6;s=Arp.Plc.Eclr/compteurFours"
            // value: 0.0
            RaZ: false
        }
        ListElement {
            text: "InfraRouge"
            namespace: "ns=6;s=Arp.Plc.Eclr/compteurFourIR"
            // value: 0.0
            RaZ: false
        }
        ListElement {
            text: "Impression"
            namespace: "ns=6;s=Arp.Plc.Eclr/compteurImpression"
            // value: 0.0
            RaZ: false
        }
        ListElement {
            text: "Bobinoir"
            namespace: "ns=6;s=Arp.Plc.Eclr/compteurBobinoir"
            // value: 0.0
            RaZ: false
        }
        ListElement {
            text: "Total"
            namespace: "ns=6;s=Arp.Plc.Eclr/compteurTotal"
            // value: 0.0
            RaZ: false
        }
    }

    Popup {
        id: loginPopup
        width: 400
        height: 300
        modal: true
        anchors.centerIn: parent
        closePolicy: Popup.NoAutoClose  // L'utilisateur doit cliquer sur "Se connecter" ou "Annuler"

        // Style moderne avec ombres et dégradés
        background: Rectangle {
            radius: 10
            color: "#f5f5f5"
            border.color: "#ddd"
            layer.enabled: true
        }

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 20

            // Titre
            Text {
                text: qsTr("Connexion")
                font.pixelSize: 24
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
                color: "#333"
            }

            // Champ Utilisateur
            TextField {
                id: usernameField
                placeholderText: qsTr("Nom d'utilisateur")
                Layout.fillWidth: true
                background: Rectangle {
                    radius: 5
                    border.color: usernameField.activeFocus ? "#4CAF50" : "#ccc"
                }
            }

            // Champ Mot de passe
            TextField {
                id: passwordField
                placeholderText: qsTr("Mot de passe")
                echoMode: TextInput.Password
                Layout.fillWidth: true
                background: Rectangle {
                    radius: 5
                    border.color: passwordField.activeFocus ? "#4CAF50" : "#ccc"
                }
                Keys.onReturnPressed: {
                        buttonLogin.clicked()  // Déclenche le bouton "Se connecter"
                    }
                Keys.onEnterPressed: {  // Pour certains claviers
                    buttonLogin.clicked()
                }
            }

            // Boutons
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 15

                Button {
                    text: qsTr("Annuler")
                    onClicked: loginPopup.close()
                    background: Rectangle {
                        radius: 5
                        color: "#e74c3c"
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
                Button {
                    text: qsTr("Se déconnecter")
                    onClicked: {

                        if(Authentification.logout()){
                            labelUser.text = Authentification.userTypeToString()
                            usernameField.text=passwordField.text=""
                            loginPopup.close()
                        }
                    }
                    background: Rectangle {
                        radius: 5
                        color: "#e78f3c"
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
                //Authentification.onCurrentUserTypeChanged:{labelUser.text = Authentification.userTypeToString()}
                Button {
                    id: buttonLogin
                    text: qsTr("Se connecter")
                    onClicked: {
                        if(Authentification.login(usernameField.text,passwordField.text)){
                            labelUser.text = Authentification.userTypeToString()
                            usernameField.text=passwordField.text=""
                            loginPopup.close()
                        }
                    }
                    background: Rectangle {
                        radius: 5
                        color: "#2ecc71"
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                    }

                }
            }

            // Message d'erreur
            Text {
                id: errorText
                text: "Identifiants incorrects"
                color: "#e74c3c"
                visible: false
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }

}
