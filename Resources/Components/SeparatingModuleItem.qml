import QtQuick
import QtQuick.Controls
import Bobink
import QtQuick.Layouts
import QtQuick.Effects
import "../.."


Item {
    id : _item
    width: parent.width
    height: parent.height

    required property string nodeIdEnable
    required property string nodeIdErreurId

    property string title: ""

    property bool hasCF : true
    // onHeightChanged: radialCanvas.requestPaint()
    // onWidthChanged: radialCanvas.requestPaint()
    // Component.onCompleted: radialCanvas.requestPaint()
    Column {
            id: separatorStack
            anchors.fill: parent
            anchors.centerIn: parent
            spacing: parent.width * 0.05

            Repeater {
                model: 7

                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: frameMenuSlider.width / 1.5
                    width: parent.width
                    height: 1.2
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position : 0.0; color: "transparent" }
                        GradientStop { position : 0.1; color: appTheme.moduleGradient5 }
                        GradientStop { position : 0.9; color: appTheme.moduleGradient5}
                        GradientStop { position : 1.0; color: "transparent" }
                    }
                }

                // Rectangle {
                //     width: parent.width
                //     height: 2.2
                //     gradient: Gradient {
                //         orientation: Gradient.Horizontal
                //         GradientStop { position: 0.0; color: appTheme.moduleGradient1 }
                //         GradientStop { position: 0.45; color: appTheme.moduleGradient3 }
                //         GradientStop { position: 1.0; color: appTheme.moduleGradient5 }
                //     }
                // }
            }
        }

    StatusIndicator {
        id: button
        visible: _item.hasCF
        width: separatorStack.height < separatorStack.height ? separatorStack.height * 3/4 : separatorStack.height * 3/4
        anchors.centerIn: _item
        value : true
        onClicked: openAt(button)
        nodeId: nodeIdEnable
    }

    Popup {
        id: lglPopup
        width: 120
        height: 500
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        property int selectedIndex: 0

        // Fonction de positionnement personnalisé
        background: Rectangle {
            color: "#F0F0F0"
            border.color: "#342D36"
            border.width: 3
            radius: 35
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            anchors.fill: parent

            // Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            CasseFilsArray {
                id: cf
                anchors.fill: parent
                title: qsTr(_item.title)
            }
        }
    }

    OpcUaMonitoredNode {
        monitored: _item.visible
        nodeId: nodeIdErreurId
        onValueChanged: {
            cf.erreurID = value
            if(value === 0){
                button.color = "green"
            }else{
                button.color = "red"
            }
        }
    }

    function openAt(button) {
        // Map to global coordinate
        var point = button.mapToItem(_item, 0, 0)
        lglPopup.x = point.x + (button.width - lglPopup.width) / 2
        lglPopup.y = point.y + button.height + 10
        lglPopup.open()
    }
}
