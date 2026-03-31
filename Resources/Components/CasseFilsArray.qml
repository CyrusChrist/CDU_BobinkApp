import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Bobink
// import QtQuick.Studio.Components
import QtQuick3D 6.8
import "../.."

Item {
    id: _item
    height: parent.height
    width: parent.width

    property string title   : "title"
    property var    value   : Array(12).fill(false)
    property var    enable  : Array(12).fill(false)
    property int    erreurID: 0


    ListModel {
        id: statusModel
        Component.onCompleted: {
            if (statusModel.count < 12) {
                for (var f = 0; f < 12; f++) {
                    statusModel.append({ "value": false, "text": f+1, "enable": true, "color": "green"});
                }
            }
        }
    }

    Frame {
        anchors.centerIn: parent

        contentItem: ColumnLayout {
            spacing: Constants.spacing / 2

            Label {
                id: _titre
                text: qsTr(_item.title)
                color: "black"
                //Layout.preferredHeight: 12 * 5
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop | Qt.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
                font.pointSize: 12
            }

            Repeater {
                model: statusModel
                StatusIndicator {
                    text: model.text
                    value: model.value
                    enable: model.enable
                    color: model.color
                    Layout.row: model.index + 1
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    MouseArea{
                        id: mouseArea
                        anchors.fill: parent

                        // Connections {
                        //     target: mouseArea
                            onClicked: {
                                statusModel.setProperty(index,"value", !statusModel.get(index).value)
                            }
                        // }

                    }
                }
            }

        }

        background: Rectangle {
            color: "transparent"
        }
    }
    Connections {
        target: _item
        function onErreurIDChanged(erreurID) {
            updateErreur(erreurID)
        }

        function onValueChanged(value) {
            updateValue(value)
        }
        function onEnableChanged(enable) {
            updateEnable(enable)
        }
    }

    Item {
        id: __materialLibrary__
    }

    function updateErreur(entier) {
        let binaire = (entier >>> 0).toString(2).padStart(16, '0');
        let max = Math.min(statusModel.count, binaire.length);
        for (let i = 0; i < max; i++) {
            statusModel.setProperty(i, "color", binaire[15-i] === '1' ? "red" : "green");
        }
    }

    function updateValue(tab){
        for (var i = 0; i < tab.length; i++) {
            statusModel.setProperty(i,"value",tab[i])
        }
    }
    function upDateEnable(tab){
        for (var i = 0; i < tab.length; i++) {
            statusModel.setProperty(i,"enable",tab[i])
        }
    }
}
