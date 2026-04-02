import QtQuick
import QtQuick.Controls
import Bobink
import QtQuick.Layouts
import "../Resources/Components"
import "../"

Item {
    id: root
    width: Constants.width
    height: Constants.height

    property bool read: true
    property bool pageLoaded: stackLayoutPage.currentIndex === 13

    function colorCat(cat) {
        switch (cat) {
        case 0 : return "#AC7BBE"
        case 1 : return "#92400E"
        case 2 : return "#7F1D1D"
        case 3 : return "#F59EOB"
        case 4 : return "#DC2626"
        case 5 : return "#EF4444"
        case 15: return "#AC7BBE"
        default: appTheme.gradientDark
        }
    }

    property var stampDateFirstOut: {
        let stamp = nodeFirstOutDateStamp.value
        var date = {}
        date[0] = stamp.slice(8, 13)
        date[1] = stamp.slice(14, 22)
        return date
    }

    OpcUaMonitoredNode { id: nodeNumActiveEvent;     nodeId: "ns=6;s=Arp.Plc.Eclr/UN_Bobink_Event.Status.NumActiveEvent" }
    readonly property int numActive: {
        var v = Number(nodeNumActiveEvent.value)
        return isNaN(v) || v < 0 ? 0 : v
    }

    // OpcUaMonitoredNode { id: nodeNumHistoryEvent;     nodeId: "ns=6;s=Arp.Plc.Eclr/UN_Bobink_Event.Status.NumActiveEvent" }
    // readonly property int numHistory: {
    //     var v = Number(nodeNumHistoryEvent.value)
    //     return isNaN(v) || v < 0 ? 0 : v
    // }

    OpcUaMonitoredNode { id: nodeFirstOutActive;      nodeId: "ns=6;s=Arp.Plc.Eclr/UN_Bobink_Event.Status.FirstOutEvent.Active"; onValueChanged: value ? openWarningPopup() : null}
    OpcUaMonitoredNode { id: nodeFirstOutCategory;    nodeId: "ns=6;s=Arp.Plc.Eclr/UN_Bobink_Event.Status.FirstOutEvent.Category" }
    OpcUaMonitoredNode { id: nodeFirstOutMessage;     nodeId: "ns=6;s=Arp.Plc.Eclr/UN_Bobink_Event.Status.FirstOutEvent.Message" }
    OpcUaMonitoredNode { id: nodeFirstOutMessage2;    nodeId: "ns=6;s=Arp.Plc.Eclr/UN_Bobink_Event.Status.FirstOutEvent.Message2" }
    OpcUaMonitoredNode { id: nodeFirstOutDescription; nodeId: "ns=6;s=Arp.Plc.Eclr/UN_Bobink_Event.Status.FirstOutEvent.Description" }
    OpcUaMonitoredNode { id: nodeFirstOutEM;          nodeId: "ns=6;s=Arp.Plc.Eclr/UN_Bobink_Event.Status.FirstOutEvent.EM" }
    OpcUaMonitoredNode { id: nodeFirstOutCM;          nodeId: "ns=6;s=Arp.Plc.Eclr/UN_Bobink_Event.Status.FirstOutEvent.CM" }
    OpcUaMonitoredNode { id: nodeFirstOutDateStamp;   nodeId: "ns=6;s=Arp.Plc.Eclr/UN_Bobink_Event.Status.FirstOutEvent.DateTime.DT_Stamp" }
    OpcUaMonitoredNode { id: nodeCmdResetFirstOut;    monitored: false; nodeId: "ns=6;s=Arp.Plc.Eclr/UN_Bobink_Event.Cmd.ResetFirstOut" }

    property var acquitterEvent: {
        var ID = {}
        ID[90] = ["", "", "", "casseFilsFour1.Cmd.Reset", "casseFilsFourIR.Cmd.Reset", "", "casseFilsFour2.Cmd.Reset", "casseFilsBobinoir.Cmd.Reset"]
        ID[100] = ["", "", "", "casseFilsFour1.Cmd.Reset", "casseFilsFourIR.Cmd.Reset", "", "casseFilsFour2.Cmd.Reset", "casseFilsBobinoir.Cmd.Reset"]
        ID[140] = ["", "LGL_Connect.Acquitter", "", "", "", "", "", ""]
        return ID
    }

    function openWarningPopup() {
        let cat = nodeFirstOutCategory.value
        if ([1, 2, 4, 5].includes(cat)) {
            notificationPopup.text = nodeFirstOutMessage.value + " - " + nodeFirstOutMessage2.value;
            notificationPopup.subText = nodeFirstOutDescription.value;
            notificationPopup.warningColor = root.colorCat(cat);
            notificationPopup.importance = 1;
            notificationPopup.em = nodeFirstOutEM.value;
            notificationPopup.cm = nodeFirstOutCM.value;
            notificationPopup.date = stampDateFirstOut[0];
            notificationPopup.time = stampDateFirstOut[1];
            notificationPopup.open();
        }
    }

    property int numActiveOld: 0

    onNumActiveChanged: {
        if (numActive > numActiveOld) {
            root.read = false
        }
        numActiveOld = numActive
        blockingEvents = getBlockingEvents()
        updateModel()
    }

    function updateModel() {
        listModel.clear()

        for (var i = 0; i < root.numActive; i++) {
            listModel.append({
                                 evtCat: 0,
                                 message: "",
                                 message2: "",
                                 timestamp: ""
                             })
        }
    }

    property int blockingEvents: 0

    onBlockingEventsChanged: {
        console.log("Nb d'erreurs bloquantes : " + blockingEvents)

        // State = aborted
        if (home.currentState === 9 && blockingEvents === 0) {
            notificationPopup.text = "Réarmer la machine"
            notificationPopup.subText = "Erreurs fixées"
            notificationPopup.importance = 1
            notificationPopup.warningColor = "green"
            notificationPopup.open()
        }
    }

    function getBlockingEvents() {
        var k = 0
        for (var i=0; i < listModel.count; i++) {
            let cat = listModel.get(i).evtCat
            if ([1, 2, 3, 4, 5].includes(cat)) {
                k++
            }
        }
        return k
    }

    onPageLoadedChanged:
        if (pageLoaded) {
            root.read = true
        }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40 * Constants.scaleFactor
        spacing: 40 * Constants.scaleFactor


        RowLayout {
            Layout.fillWidth: true
            spacing: Constants.dp(15)

            Text {
                Layout.alignment: Qt.AlignVCenter
                text: qsTr("Centre des notifications")
                font.pixelSize: Math.max(35, parent.width * 0.037)
                font.bold: true
                color: appTheme.bodyText
            }

            Rectangle { Layout.preferredWidth: 2; Layout.preferredHeight: parent.height; color: "#555" }

            // Pastille clignotante
            Rectangle {
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 20; Layout.preferredHeight: 20; radius: 10
                color: root.numActive > 0 ? "#f44336" : "#4CAF50"
                SequentialAnimation on opacity {
                    running: root.numActive > 0
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.3; duration: 650 }
                    NumberAnimation { to: 1.0; duration: 650 }
                }
            }

            Text {
                Layout.alignment: Qt.AlignVCenter
                text: root.numActive > 0 ? root.numActive + " événement(s) actif(s)" : "Aucun événement"
                font.pixelSize: Constants.sp(30)
                color:root.numActive > 0 ? "#f44336" : "#4CAF50"
            }
        }

        ScrollView {
            id: notifScroll
            Layout.fillHeight: true
            Layout.fillWidth: true
            ScrollBar.vertical.policy: ScrollBar.AsNeeded

            Item {
                anchors.fill: parent

                ListModel {
                    id: listModel
                }

                ListView {
                    id: listView
                    anchors.fill: parent
                    model: listModel

                    delegate: Rectangle {
                        id: notifDelegate
                        property int newNotifCount: listView.count - notifDelegate.index - 1

                        // property int eventIndexHistory: index <= root.numHistory ? index : -100
                        property int eventIndex: index /*> root.numHistory ? root.numHistory - index : -100*/

                        property var stampDate: {
                            if (index >= 0) {
                                let stamp = notifDelegate.timeStamp
                                var date = {}
                                date[0] = stamp.slice(8, 13)
                                date[1] = stamp.slice(14, 22)
                                return date
                            } else { return "" }
                        }

                        readonly property string baseNodeId: index >= 0 ? "Arp.Plc.Eclr/UN_Bobink_Event.Status.ActiveList[" + index + "]"
                                                                        : ""

                        // === OPC-UA Nodes ===
                        OpcUaMonitoredNode { id: nodeActive;    nodeId: index >= 0 ? "ns=6;s=" + baseNodeId + ".Active"  : "" }
                        OpcUaMonitoredNode { id: nodeEvtId;     nodeId: index >= 0 ? "ns=6;s=" + baseNodeId + ".ID" : "" }
                        OpcUaMonitoredNode { id: nodeMessage;   nodeId: index >= 0 ? "ns=6;s=" + baseNodeId + ".Message" : "" }
                        OpcUaMonitoredNode { id: nodeMessage2;  nodeId: index >= 0 ? "ns=6;s=" + baseNodeId + ".Message2" : "" }
                        OpcUaMonitoredNode { id: nodeCategory;  nodeId: index >= 0 ? "ns=6;s=" + baseNodeId + ".Category" : "";
                            onValueChanged: listModel.setProperty(index, "evtCat", value)
                        }
                        OpcUaMonitoredNode { id: nodeEM;        nodeId: index >= 0 ? "ns=6;s=" + baseNodeId + ".EM" : "" }
                        OpcUaMonitoredNode { id: nodeCM;        nodeId: index >= 0 ? "ns=6;s=" + baseNodeId + ".CM" : "" }
                        OpcUaMonitoredNode { id: nodeTimeStamp; nodeId: index >= 0 ? "ns=6;s=" + baseNodeId + ".DateTime.DT_Stamp" : "" }

                        property int cat: nodeCategory.value !== undefined ? nodeCategory.value : 0
                        property int em: nodeEM.value !== undefined ? nodeEM.value : 0
                        property int cm: nodeCM.value !== undefined ? nodeCM.value : 0
                        property var timeStamp: nodeTimeStamp.value !== undefined ? nodeTimeStamp.value : ""
                        property string message: nodeMessage.value !== undefined ? String(nodeMessage.value) : ""
                        property string message2: nodeMessage2.value !== undefined ? String(nodeMessage2.value) : ""
                        property int evtID: nodeEvtId.value !== undefined ? nodeEvtId.value : 0

                        // readonly property string baseNodeIdHistory: "Arp.Plc.Eclr/UN_Bobink_Event.History[" + index + "]"

                        // // === OPC-UA Nodes HISTORY ===
                        // OpcUaMonitoredNode { id: nodeHistoryEvtId;     nodeId: "ns=6;s=" + baseNodeIdHistory + ".ID" }
                        // OpcUaMonitoredNode { id: nodeHistoryMessage;   nodeId: "ns=6;s=" + baseNodeIdHistory + ".Message" }
                        // OpcUaMonitoredNode { id: nodeHistoryMessage2;  nodeId: "ns=6;s=" + baseNodeIdHistory + ".Message2" }
                        // OpcUaMonitoredNode { id: nodeHistoryCategory;  nodeId: "ns=6;s=" + baseNodeIdHistory + ".Category" }
                        // OpcUaMonitoredNode { id: nodeHistoryEM;        nodeId: "ns=6;s=" + baseNodeIdHistory + ".EM" }
                        // OpcUaMonitoredNode { id: nodeHistoryCM;        nodeId: "ns=6;s=" + baseNodeIdHistory + ".CM" }
                        // OpcUaMonitoredNode { id: nodeHistoryTimeStamp; nodeId: "ns=6;s=" + baseNodeIdHistory + ".DateTime.DT_Stamp" }

                        height: eventIndex === -1 ? 60 * Constants.scaleFactor : 110 * Constants.scaleFactor
                        width: listView.width
                        color: eventIndex === -1 ? "transparent" : /*eventIndex > root.numHistory ?*/ root.colorCat(cat) /*: "#6B6B6B"*/
                        radius: 25 * Constants.scaleFactor
                        border.width: 6 * Constants.scaleFactor
                        border.color: appTheme.backgroundColor

                        RowLayout {
                            width: parent.width
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 10 * Constants.scaleFactor
                            visible: eventIndex !== -1

                            Item { Layout.preferredWidth: 10 * Constants.scaleFactor}

                            Rectangle {
                                Layout.preferredHeight: parent.height
                                Layout.preferredWidth: height
                                radius: 15 * Constants.scaleFactor
                                color: "#8E0801"
                                border.width: 2 * Constants.scaleFactor
                                border.color: appTheme.bodyText

                                Image {
                                    sourceSize: Qt.size(width, height)
                                    anchors.centerIn: parent
                                    height: parent.height * 0.8
                                    width: height
                                    source: !isNaN(nodeCM.value) && !isNaN(nodeEM.value) ?
                                                "../Resources/Images/" + Constants.cmImages[notifDelegate.em][notifDelegate.cm] + ".svg" :
                                                "../Resources/Images/Info.svg"
                                    fillMode: Image.PreserveAspectCrop
                                }
                            }

                            ColumnLayout {
                                spacing: 8 * Constants.scaleFactor
                                Layout.fillWidth: true

                                RowLayout {
                                    spacing: Constants.dp(10)
                                    Layout.fillWidth: true

                                    Text {
                                        text: !isNaN(nodeEM.value) ? Constants.emNames[notifDelegate.em] : "Module indéfini"
                                        font.pixelSize: 20 * Constants.scaleFactor
                                        font.family: "Object Sans"
                                        font.bold: true
                                        color: appTheme.bodyText
                                    }

                                    Rectangle { Layout.preferredHeight: parent.height; Layout.preferredWidth: 1; color: "white"; opacity: 0.8 }

                                    Text {
                                        text: !isNaN(nodeCM.value) && !isNaN(nodeEM.value) ? Constants.cmNames[notifDelegate.em][notifDelegate.cm] : ""
                                        font.pixelSize: 20 * Constants.scaleFactor
                                        font.family: "Object Sans"
                                        color: appTheme.bodyText
                                    }

                                    Item { Layout.fillWidth: true }

                                    Text {
                                        text: notifDelegate.stampDate[0] + " - " + notifDelegate.stampDate[1]
                                        font.pixelSize: 20 * Constants.scaleFactor
                                        font.family: "Object Sans"
                                        color: appTheme.bodyText
                                        Layout.alignment: Qt.AlignRight
                                    }
                                }

                                Text {
                                    text: /*eventIndex > root.numHistory ?*/ notifDelegate.message + " - " + notifDelegate.message2
                                    // : String(nodeHistoryMessage.value) + " - " + String(nodeHistoryMessage2.value)
                                    font.pixelSize: 28 * Constants.scaleFactor
                                    font.family: "Object Sans"
                                    font.bold: true
                                    color: appTheme.bodyText
                                }
                            }

                            Item {
                                Layout.fillWidth: true
                            }

                            Button {
                                id: infoButton
                                visible: false
                                Layout.preferredHeight: parent.height * 0.8
                                Layout.preferredWidth: height

                                onClicked: notificationPopup.open()

                                background: Image {
                                    sourceSize: Qt.size(width, height)
                                    source: "../Resources/Images/Info.svg"
                                }

                            }

                            Button {
                                id: crossButton
                                Layout.preferredHeight: parent.height * 0.8
                                Layout.preferredWidth: height
                                visible: [90, 100, 140].includes(notifDelegate.evtID)

                                onPressed: {
                                    console.log("Event ID : " + notifDelegate.evtID + " Trying to acquitter : " + root.acquitterEvent[notifDelegate.evtID][notifDelegate.em])
                                    nodeIDAcquitter.writeValue(true)
                                    nodeCmdResetFirstOut.writeValue(true)
                                    acquitterDelay.start()
                                }

                                onReleased: {
                                    nodeIDAcquitter.writeValue(false)
                                }

                                OpcUaMonitoredNode {
                                    id: nodeIDAcquitter;
                                    nodeId: index >= 0 && nodeEvtId.value !== undefined ? "ns=6;s=Arp.Plc.Eclr/" + root.acquitterEvent[notifDelegate.evtID][notifDelegate.em] : "";
                                    monitored: nodeEvtId.value !== undefined;
                                    onValueChanged: {
                                        if (nodeEvtId.value !== undefined) {
                                            console.log("Acquitter : " + root.acquitterEvent[notifDelegate.evtID][notifDelegate.em] + " -> " + value);
                                        }
                                    }
                                }

                                Timer {
                                    id: acquitterDelay
                                    interval: 200
                                    onTriggered: {
                                        nodeIDAcquitter.writeValue(false)
                                        nodeCmdResetFirstOut.writeValue(false)
                                    }
                                }

                                property real thickness: Math.max(2, height * 0.12)
                                property real length: Math.min(width, height) * 0.6

                                background: Rectangle {
                                    id: cross
                                    anchors.fill: parent
                                    radius: height / 2
                                    color: "transparent"
                                    border.color: appTheme.bodyText
                                    border.width: crossButton.thickness

                                    Rectangle {
                                        anchors.centerIn: parent
                                        width: crossButton.length
                                        height: crossButton.thickness
                                        radius: height / 2
                                        color: appTheme.bodyText
                                        rotation: 45
                                        antialiasing: true
                                    }

                                    Rectangle {
                                        anchors.centerIn: parent
                                        width: crossButton.length
                                        height: crossButton.thickness
                                        radius: height / 2
                                        color: appTheme.bodyText
                                        rotation: -45
                                        antialiasing: true
                                    }
                                }

                            }

                            Item { Layout.preferredWidth: 10 * Constants.scaleFactor}
                        }

                        RowLayout {
                            visible: eventIndex === -1
                            anchors.horizontalCenter: parent.horizontalCenter
                            // width: parent.width
                            // height: parent.height
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 15 * Constants.scaleFactor
                            Canvas {
                                width: root.width / 2 - newNotifText.width / 2 - parent.spacing * 2
                                height: 20
                                onPaint: {
                                    var ctx = getContext("2d")
                                    ctx.clearRect(0, 0, width, height)

                                    ctx.strokeStyle = appTheme.bodyText
                                    ctx.lineWidth = 2 * Constants.scaleFactor

                                    var amplitude = parent.height * 0.2
                                    var frequency = 2 * Math.PI / width * 7   // 12 cycles across width
                                    var centerY = height / 2

                                    ctx.beginPath()
                                    for (var x = 0; x <= width; x++) {
                                        var y = centerY + amplitude * Math.sin(frequency * x)
                                        if (x === 0)
                                            ctx.moveTo(x, y)
                                        else
                                            ctx.lineTo(x, y)
                                    }
                                    ctx.stroke()

                                }
                                onWidthChanged: requestPaint()
                                onHeightChanged: requestPaint()
                            }

                            Text {
                                id: newNotifText
                                text: notifDelegate.newNotifCount > 1 ? notifDelegate.newNotifCount + " new notifications" :
                                                                        notifDelegate.newNotifCount + " new notification"
                                font.pixelSize: 28 * Constants.scaleFactor
                                font.family: "Object Sans"
                                color: appTheme.bodyText
                            }

                            Canvas {
                                width: root.width / 2 - newNotifText.width / 2 - parent.spacing * 2
                                height: 20
                                onPaint: {
                                    var ctx = getContext("2d")
                                    ctx.clearRect(0, 0, width, height)

                                    ctx.strokeStyle = appTheme.bodyText
                                    ctx.lineWidth = 2 * Constants.scaleFactor

                                    var amplitude = parent.height * 0.2
                                    var frequency = 2 * Math.PI / width * 7   // 12 cycles across width
                                    var centerY = height / 2

                                    ctx.beginPath()
                                    for (var x = 0; x <= width; x++) {
                                        var y = centerY + amplitude * Math.sin(frequency * x)
                                        if (x === 0)
                                            ctx.moveTo(x, y)
                                        else
                                            ctx.lineTo(x, y)
                                    }
                                    ctx.stroke()
                                }

                                onWidthChanged: requestPaint()
                                onHeightChanged: requestPaint()
                            }
                        }


                    }
                }

            }
            // Dégradé haut
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 80 * Constants.scaleFactor
                opacity: listView.contentY > 0 ? 1 : 0
                z: 10
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.darker(appTheme.backgroundColor, 1.5) }
                    GradientStop { position: 0.1; color: "transparent" }
                }

                Behavior on opacity {
                    NumberAnimation { duration: 200 }
                }
            }

            // Dégradé bas
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 80 * Constants.scaleFactor
                opacity: listView.contentY < listView.contentHeight - notifScroll.height - 1 ? 1 : 0
                z: 10
                gradient: Gradient {
                    GradientStop { position: 0.90; color: "transparent" }
                    GradientStop { position: 1.0; color: Qt.darker(appTheme.backgroundColor, 1.5) }
                }

                Behavior on opacity {
                    NumberAnimation { duration: 200 }
                }
            }

        }

    }
}
