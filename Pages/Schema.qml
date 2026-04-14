import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../Resources/Components"
import "../"
import Bobink

Item {
    id: root
    property real scale: 0.8
    property int selectedIndex: 0
    property int pageOpen: stackLayoutPage.currentIndex === 8

    onPageOpenChanged: centerOnSelectedZone()

    function centerOnSelectedZone() {
        if (selectedIndex < 0 || selectedIndex >= zoneModelPassageFil.count)
            return;

        var zone = zoneModelPassageFil.get(selectedIndex);
        var zoneCenterX = zone.x + zone.width / 2;
        var viewportCenterX = flick.width / 2;
        var newContentX = zoneCenterX * scale - viewportCenterX;

        // Clamp pour éviter les dépassements
        newContentX = Math.max(0, Math.min(newContentX, flick.contentWidth - flick.width));
        scrollAnim.to = newContentX
        scrollAnim.start()

    }

    NumberAnimation {
        id: scrollAnim
        target: flick
        property: "contentX"
        duration: 300
        easing.type: Easing.InOutQuad
    }

    // Liste des coorodonnées des zones interactives
    ListModel {
        id: zoneModelPassageFil
        ListElement { x: 4134; y: 397; width: 161; height: 427; label: "LGL Cantre" }
        ListElement { x: 3454; y: 570; width: 511; height: 125; label: "Pré-traitement" }
        ListElement { x: 3134; y: 575; width: 242; height: 235; label: "Entrée Four 1" }
        ListElement { x: 2102; y: 468; width: 661; height: 322; label: "Sortie Four 1" }
        ListElement { x: 855; y: 556; width: 169; height: 210; label: "Pré-alimenteur" }
        ListElement { x: 825; y: 452; width: 563; height: 190; label: "Entrée Fours IRs" }
        ListElement { x: 2164; y: 217; width: 221; height: 231; label: "Entrée Four 2" }
        ListElement { x: 3214; y: 255; width: 229; height: 314; label: "Sortie Four 2" }
        ListElement { x: 4633; y: 523; width: 411; height: 195; label: "Paraffines" }
        ListElement { x: 5165; y: 576; width: 162; height: 238; label: "Bobinoir" }
    }

    ListModel {
        id: zoneModelInfo
        ListElement { x: 4134; y: 397; width: 161; height: 427; label: "LGL Cantre" }
    }

    Flickable {
        id: flick
        anchors.fill: parent
        contentWidth: 5700 * root.scale
        contentHeight: height //1106 * scale
        clip: true

        Item {

            Image {
                sourceSize: Qt.size(width, height)
                id: svgImage
                source: "../Resources/Images/Schema3D.svg"
                width: 5700 * root.scale
                height: 1106 * root.scale
                // transform: Scale { xScale: scale; yScale: scale }

                // MouseArea {
                //     anchors.fill: parent
                //     onClicked: {
                //         var pdfX = mouse.x / scale
                //         var pdfY = mouse.y / scale
                //         console.log("Clic détecté à", pdfX.toFixed(0), pdfY.toFixed(0))
                //     }
                // }
            }

            // Zones cliquables
            Repeater {
                id: repeaterZone
                model: passageFilBtn.checked ? zoneModelPassageFil : zoneModelInfo
                delegate: Rectangle {
                    width: model.width * root.scale
                    height: model.height * root.scale
                    x: model.x * root.scale
                    y: model.y * root.scale
                    color: index === selectedIndex ? "#5FBEB055" : "#5FBEB0ff"
                    border.color: "#288282"
                    border.width: 2
                    radius: Constants.dp(15)
                    z: 10 + index

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            selectedIndex = index
                            contextualInfoTxt.text = "🔍 " + model.label
                            centerOnSelectedZone()
                        }
                        hoverEnabled: true
                        onEntered: parent.opacity = 1.0
                        onExited: parent.opacity = 0.7
                    }

                    Behavior on color { ColorAnimation { duration: 150 } }
                    Behavior on opacity { NumberAnimation { duration: 100 } }
                }
            }

        }

        PinchArea {
            anchors.fill: parent
            pinch.minimumScale: 0.5
            pinch.maximumScale: 4.0
            onPinchUpdated: scale = pinch.scale
        }
    }

    RowLayout {
        x: 40 * Constants.scaleFactor
        y: 40 * Constants.scaleFactor
        spacing: Constants.dp(15)

        Text {
            text: qsTr("Schéma Machine")
            font.pixelSize: Math.max(35, root.width * 0.037)
            Layout.alignment: Qt.AlignVCenter
            font.bold: true
            color: appTheme.bodyText
        }

        ButtonGroup { id: schemaSelection }

        Button {
            id: passageFilBtn
            ButtonGroup.group: schemaSelection
            text: qsTr("Passage\ndu fil")
            Layout.preferredHeight: Constants.dp(45)
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: Constants.dp(120)
            checked: true
            checkable: true
            onClicked: root.selectedIndex = 0
        }

        Button {
            id: infoBtn
            ButtonGroup.group: schemaSelection
            text: qsTr("Informations")
            Layout.preferredHeight: Constants.dp(45)
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: Constants.dp(120)
            checkable: true
            onClicked: root.selectedIndex = 0
        }
    }

    Rectangle {
        id: contextualInfo
        width: Constants.dp(360)
        height: parent.height
        color: "#f0f0f0"
        anchors.right: parent.right
        anchors.top: parent.top
        border.color: "#ccc"

        TextArea {
            id: contextualInfoTxt
            anchors.fill: parent
            anchors.topMargin: Constants.dp(40)
            wrapMode: TextEdit.Wrap
            readOnly: true
            text: "Cliquez sur une zone pour voir les infos."
        }
    }

    ColumnLayout {
        anchors.horizontalCenter: root.horizontalCenter
        anchors.bottom: parent.bottom

        RowLayout {
            spacing: Constants.dp(15)

            ModuleButton {
                Layout.preferredWidth: Constants.dp(60)
                bordered: true
                labelText: "<"
                onClicked: {
                    if (root.selectedIndex !== 0) {
                        root.selectedIndex -= 1
                    } else {
                        root.selectedIndex = repeaterZone.model.count - 1
                    }
                    centerOnSelectedZone()
                }
            }

            Item {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.preferredWidth: Constants.dp(200)
                Layout.preferredHeight: Constants.dp(60)

                Text {
                    anchors.centerIn: parent
                    text: repeaterZone.model.get(root.selectedIndex).label
                    font.pixelSize: Constants.dp(25)
                    font.bold: true
                    color: appTheme.bodyText
                }

            }

            ModuleButton {
                Layout.preferredWidth: Constants.dp(60)
                bordered: true
                labelText: ">"
                onClicked: {
                    if (root.selectedIndex !== repeaterZone.model.count - 1) {
                        root.selectedIndex += 1
                    } else {
                        root.selectedIndex = 0
                    }
                    centerOnSelectedZone()
                }

            }

        }

        PageIndicator {
            Layout.alignment: Qt.AlignHCenter
            currentIndex: root.selectedIndex
            count: repeaterZone.model.count

            delegate: Rectangle {
                implicitWidth: index === root.selectedIndex ? jobView.width * 0.05 : jobView.width * 0.04
                implicitHeight: width
                anchors.verticalCenter: parent.verticalCenter

                radius: width / 2
                color: appTheme.pageIndColor

                opacity: index === root.selectedIndex ? 0.95 : pressed ? 0.7 : 0.45

                Behavior on opacity {
                    OpacityAnimator {
                        duration: 100
                    }
                }
            }

        }

    }

}

