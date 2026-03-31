import QtQuick
import QtQuick.Controls
import QtWebView
import QtQuick.Layouts
import "../"

Item {
    id: root

    ColumnLayout {
        anchors.fill: parent

        RowLayout {
            visible: false
            Button { text: "←"; onClicked: webView.goBack() }
            Button { text: "→"; onClicked: webView.goForward() }
            Button { text: "⟳"; onClicked: webView.reload() }
            TextField {
                id: urlBar
                Layout.fillWidth: true
                text: webView.url
                onAccepted: webView.url = text
            }
            Button {
                text: "Go"
                onClicked: webView.url = urlBar.text
            }
        }

        WebView {
            id: webView
            Layout.fillWidth: true
            Layout.fillHeight: true
            url: "http://192.168.1." + (stackLayoutPage.numeroCognex + 2).toString()

            onUrlChanged: urlBar.text = url
            onLoadingChanged: function(loadRequest) {
                if (loadRequest.status === WebView.LoadStarted) {
                    statusText.text = "Chargement..."
                } else if (loadRequest.status === WebView.LoadSucceededStatus) {
                    statusText.text = "Chargement terminé"
                } else {
                    statusText.text = "Erreur: " + loadRequest.errorString
                }
                debugText.text = loadRequest.status
            }
        }
        RowLayout{

            visible: false
            Layout.fillWidth: true
            Text {
                id: statusText
                Layout.fillWidth: true
            }
            Text {
                id: debugText
                Layout.fillWidth: true
            }
        }
    }
}
