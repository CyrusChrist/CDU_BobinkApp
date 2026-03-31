// Demo.qml — Demo app for Bobink library.
// Connects to an OPC UA server, then pushes NodePage for node interaction.

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import Bobink

ApplicationWindow {
    id: root
    width: 800
    height: 900
    visible: true
    title: "Bobink Demo"
    visibility: Window.Maximized

    property bool autoConnectFailed: false
    property bool showPkiSettings: false

    AppTheme {
        id: appTheme
    }

    Connections {
        target: Bobink
        function onServersChanged() {
            debugConsole.appendLog("Discovered server list updated");
        }
        function onConnectedChanged() {
            debugConsole.appendLog("Connected: " + Bobink.connected);
            if (Bobink.connected) {
                root.autoConnectFailed = false;
                Bobink.stopDiscovery();
                stack.push("NodePage.qml", {
                    stackRef: stack,
                    pageNumber: 1,
                    logFunction: debugConsole.appendLog
                });
            } else {
                stack.pop(null);
            }
        }
        function onConnectionError(message) {
            debugConsole.appendLog("Connection error: " + message);
            root.autoConnectFailed = true;
        }
        function onStatusMessage(message) {
            debugConsole.appendLog(message);
        }
        function onDiscoveringChanged() {
            debugConsole.appendLog("Discovering: " + Bobink.discovering);
        }
        function onCertificateTrustRequested(certInfo) {
            certTrustDialog.certInfo = certInfo;
            certTrustDialog.open();
        }
    }

    Dialog {
        id: certTrustDialog
        property string certInfo
        anchors.centerIn: parent
        title: "Certificate Trust"
        modal: true
        standardButtons: Dialog.Yes | Dialog.No
        Label {
            text: certTrustDialog.certInfo
        }
        onAccepted: Bobink.acceptCertificate()
        onRejected: Bobink.rejectCertificate()
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        StackView {
            id: stack
            Layout.fillWidth: true
            Layout.fillHeight: true

            initialItem: Page {
                id: connectionPage
                Component.onCompleted: {
                    Bobink.discoveryUrl = discoveryUrlField.text;
                    Bobink.startDiscovery();
                }

                OpcUaAuth {
                    id: auth
                    mode: authModeCombo.currentValue
                    username: usernameField.text
                    password: passwordField.text
                    certPath: Bobink.certFile
                    keyPath: Bobink.keyFile
                }

                FileDialog {
                    id: certFileDialog
                    title: "Select Certificate"
                    currentFolder: "file://" + trustFolderField.text
                    nameFilters: ["DER certificates (*.der)", "All files (*)"]
                    onAccepted: certFileField.text = selectedFile.toString().replace("file://", "")
                }
                FileDialog {
                    id: keyFileDialog
                    title: "Select Private Key"
                    currentFolder: "file://" + trustFolderField.text
                    nameFilters: ["Key files (*.pem *.crt)", "All files (*)"]
                    onAccepted: keyFileField.text = selectedFile.toString().replace("file://", "")
                }
                FolderDialog {
                    id: trustFolderDialog
                    title: "Select Trust Folder"
                    currentFolder: "file://" + trustFolderField.text
                    onAccepted: trustFolderField.text = selectedFolder.toString().replace("file://", "")
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 12

                    RowLayout {

                        Label {
                            text: "Discovery URL"
                            font.bold: true
                            Layout.fillWidth: true
                        }

                        Button {
                            text: "Hard Launch"
                            onClicked: { stack.push("NodePage.qml", {
                                               stackRef: stack,
                                               pageNumber: 1,
                                               logFunction: debugConsole.appendLog
                                           })
                            }
                        }

                    }

                    RowLayout {
                        TextField {
                            id: discoveryUrlField
                            Layout.fillWidth: true
                            text: "opc.tcp://ThinkPad-P53:4840"
                        }
                        Button {
                            text: Bobink.discovering ? "Stop" : "Discover"
                            onClicked: {
                                if (Bobink.discovering) {
                                    Bobink.stopDiscovery();
                                } else {
                                    Bobink.discoveryUrl = discoveryUrlField.text;
                                    Bobink.startDiscovery();
                                }
                            }
                        }
                    }

                    Label {
                        text: Bobink.discovering ? "Discovering... (" + Bobink.servers.length + " found)" : Bobink.servers.length + " server(s)"
                        font.italic: true
                    }

                    ListView {
                        id: serverListView
                        Layout.fillWidth: true
                        Layout.preferredHeight: 100
                        clip: true
                        model: Bobink.servers
                        delegate: ItemDelegate {
                            id: serverDelegate
                            required property var modelData
                            width: ListView.view.width
                            contentItem: ColumnLayout {
                                spacing: 2
                                Label {
                                    text: serverDelegate.modelData.serverName
                                }
                                Label {
                                    text: serverDelegate.modelData.applicationUri
                                    color: "gray"
                                    font.italic: true
                                    font.pointSize: 8
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                            }
                            onClicked: {
                                if (modelData.discoveryUrls.length > 0)
                                    serverUrlField.text = modelData.discoveryUrls[0];
                            }
                        }
                        ScrollBar.vertical: ScrollBar {
                            policy: ScrollBar.AsNeeded
                        }
                    }

                    RowLayout {
                        Label {
                            text: "PKI"
                            font.bold: true
                        }
                        Label {
                            text: Bobink.certFile ? "  (" + Bobink.certFile.split("/").pop() + ")" : "  (no certificate found)"
                            font.italic: true
                            color: Bobink.certFile ? "green" : "gray"
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        Button {
                            text: root.showPkiSettings ? "Hide" : "Configure"
                            onClicked: root.showPkiSettings = !root.showPkiSettings
                        }
                    }

                    GridLayout {
                        columns: 3
                        Layout.fillWidth: true
                        visible: root.showPkiSettings

                        Label {
                            text: "Certificate:"
                        }
                        TextField {
                            id: certFileField
                            Layout.fillWidth: true
                            text: Bobink.certFile
                            placeholderText: "Client certificate (.der)"
                        }
                        Button {
                            text: "Browse"
                            onClicked: certFileDialog.open()
                        }

                        Label {
                            text: "Private key:"
                        }
                        TextField {
                            id: keyFileField
                            Layout.fillWidth: true
                            text: Bobink.keyFile
                            placeholderText: "Private key (.pem, .crt)"
                        }
                        Button {
                            text: "Browse"
                            onClicked: keyFileDialog.open()
                        }

                        Label {
                            text: "Trust folder:"
                        }
                        TextField {
                            id: trustFolderField
                            Layout.fillWidth: true
                            text: Bobink.pkiDir
                        }
                        Button {
                            text: "Browse"
                            onClicked: trustFolderDialog.open()
                        }
                    }

                    Button {
                        text: "Apply PKI"
                        Layout.fillWidth: true
                        visible: root.showPkiSettings
                        onClicked: {
                            Bobink.pkiDir = trustFolderField.text;
                            Bobink.certFile = certFileField.text;
                            Bobink.keyFile = keyFileField.text;
                            Bobink.applyPki();
                        }
                    }

                    Label {
                        text: "Server URL"
                        font.bold: true
                    }

                    TextField {
                        id: serverUrlField
                        Layout.fillWidth: true
                        placeholderText: "opc.tcp://..."
                    }

                    Label {
                        text: "Authentication"
                        font.bold: true
                    }

                    ComboBox {
                        id: authModeCombo
                        Layout.fillWidth: true
                        textRole: "text"
                        valueRole: "mode"
                        model: [
                            {
                                text: "Anonymous",
                                mode: OpcUaAuth.Anonymous
                            },
                            {
                                text: "Username / Password",
                                mode: OpcUaAuth.UserPass
                            },
                            {
                                text: "Certificate",
                                mode: OpcUaAuth.Certificate
                            }
                        ]
                    }

                    GridLayout {
                        columns: 2
                        visible: authModeCombo.currentValue === OpcUaAuth.UserPass
                        Layout.fillWidth: true

                        Label {
                            text: "Username:"
                        }
                        TextField {
                            id: usernameField
                            Layout.fillWidth: true
                        }
                        Label {
                            text: "Password:"
                        }
                        TextField {
                            id: passwordField
                            Layout.fillWidth: true
                            echoMode: TextInput.Password
                        }
                    }

                    Button {
                        text: "Connect"
                        Layout.fillWidth: true
                        onClicked: {
                            root.autoConnectFailed = false;
                            Bobink.auth = auth;
                            Bobink.serverUrl = serverUrlField.text;
                            Bobink.connectToServer();
                        }
                    }

                    Label {
                        text: "Direct Connect"
                        font.bold: true
                        visible: root.autoConnectFailed
                    }

                    GridLayout {
                        columns: 2
                        Layout.fillWidth: true
                        visible: root.autoConnectFailed

                        Label {
                            text: "Security policy:"
                        }
                        ComboBox {
                            id: securityPolicyCombo
                            Layout.fillWidth: true
                            textRole: "text"
                            valueRole: "policy"
                            model: [
                                {
                                    text: "Basic256Sha256",
                                    policy: Bobink.Basic256Sha256
                                },
                                {
                                    text: "Aes128-Sha256-RsaOaep",
                                    policy: Bobink.Aes128_Sha256_RsaOaep
                                },
                                {
                                    text: "Aes256-Sha256-RsaPss",
                                    policy: Bobink.Aes256_Sha256_RsaPss
                                }
                            ]
                        }

                        Label {
                            text: "Security mode:"
                        }
                        ComboBox {
                            id: securityModeCombo
                            Layout.fillWidth: true
                            textRole: "text"
                            valueRole: "mode"
                            model: [
                                {
                                    text: "Sign & Encrypt",
                                    mode: Bobink.SignAndEncrypt
                                },
                                {
                                    text: "Sign",
                                    mode: Bobink.Sign
                                },
                                {
                                    text: "None",
                                    mode: Bobink.None
                                }
                            ]
                        }
                    }

                    Button {
                        text: "Direct Connect"
                        Layout.fillWidth: true
                        visible: root.autoConnectFailed
                        onClicked: {
                            Bobink.auth = auth;
                            Bobink.serverUrl = serverUrlField.text;
                            Bobink.connectDirect(securityPolicyCombo.currentValue, securityModeCombo.currentValue);
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                    }
                }
            }
        }

        Rectangle {
            id: debugConsole
            visible: false
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            color: "#1e1e1e"
            border.color: "#444"
            radius: 4

            function appendLog(msg) {
                let ts = new Date().toLocaleTimeString(Qt.locale(), "HH:mm:ss");
                debugLog.text += "[" + ts + "] " + msg + "\n";
                debugLog.cursorPosition = debugLog.text.length;
            }

            ScrollView {
                anchors.fill: parent
                anchors.margins: 4
                TextArea {
                    id: debugLog
                    readOnly: true
                    color: "#cccccc"
                    font.family: "monospace"
                    font.pointSize: 9
                    wrapMode: TextEdit.Wrap
                    background: null
                }
            }
        }
    }
}
