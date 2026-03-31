import QtQuick
import QtQuick.Controls
import Bobink
import QtQuick.Effects
import QtQuick.Layouts
import "."
import "../.."

Item {
    id: root
    implicitWidth: 180
    implicitHeight: 65

    property string labelText: ""
    property string runningText: ""
    property bool razButton: false

    property string nodeIdExec: ""
    property string nodeIdEnd: ""
    property string nodeIdEnd2: "" // si nodeIdEnd2 !== "", alors la condition d'arret de la nodeIdEnd ET la nodeIdEnd2 sont necessaires pour stopper le scenario
    property string nodeIdReset: ""
    required property var endValue

    onLabelTextChanged: {
        label.text = root.labelText
        button.optimalPixelSizeLabelText = button.calculateFontSize(root.labelText, button.width * 0.12 )
        button.optimalPixelSizeRunningText = button.calculateFontSize(root.runningText, (button.width - button.height) * 0.15)
    }

    property string timerMode: ""

    function startScenario() {
        if (button.progressState === "Stop") {
            opcuaLoaderExec.item.setValue(true)
            timerMode = "Stop"
            delay.restart()
            button.progressState = "Loading"
        }
    }

    function stopScenario() {
        if (button.progressState === "Loading") {
            opcuaLoaderExec.item.setValue(true)
            timerMode = "Stop"
            delay.restart()
            button.progressState = "Stop"

        }
    }

    function resetScenario() {
        opcuaLoaderReset.item.setValue(true)
        timerMode = "Reset"
        delay.restart()
        button.progressState = "Stop"
    }

    Timer {
        id: delay
        interval: 500
        running: false
        onTriggered: {
            if (root.timerMode === "Start") {
                console.log("Ending start scenario")
                opcuaLoaderExec.item.setValue(false)

            }
            else if (root.timerMode === "Stop") {
                console.log("Ending stop scenario")
                opcuaLoaderExec.item.setValue(false)

            }
            else if (root.timerMode === "Reset") {
                console.log("Ending reset scenario")
                opcuaLoaderReset.item.setValue(false)

            } else {
                console.log("Timer triggered with unknown timerMode")
            }

            root.timerMode = ""

        }
    }

    RowLayout {
        anchors.fill: parent

        Button {
            id: button
            Layout.preferredWidth: parent.width * 0.7
            Layout.preferredHeight: parent.height
            enabled: !(endCondition2 !== "" ? endCondition1 && endCondition2 : endCondition1) && root.enabled

            property bool clickable: true

            property real maxFontSize: width * 0.12  // taille max
            property real minFontSize: 12            // taille min pour pas être illisible
            property int optimalPixelSizeLabelText: button.calculateFontSize(root.labelText, button.width * 0.12 )
            property int optimalPixelSizeRunningText: button.calculateFontSize(root.runningText, (button.width - button.height) * 0.15)

            checkable: true

            property string progressState: "Stop"

            // property int totalCondition: 0
            property bool endCondition1
            property bool endCondition2

            onEndCondition1Changed: {
                if ((endCondition1 && endCondition2) && root.nodeIdEnd2 !== "") {
                    button.progressState = "Done"
                }
            }

            onEndCondition2Changed: {
                if ((endCondition1 && endCondition2) && root.nodeIdEnd2 !== "") {
                    button.progressState = "Done"
                }
            }

            onProgressStateChanged: {
                // console.log("ProgressState =\t" + button.progressState)
                if (progressState === "Stop") {
                    button.checked = false
                } else if (progressState === "Loading") {
                    button.checked = true
                } else if (progressState === "Done") {
                    resetTimer.restart()
                }
            }

            Timer {
                id: resetTimer
                interval: 1000
                running: false
                onTriggered: {button.progressState = "Stop"}
            }

            function calculateFontSize(text, size) {
                while (size > button.minFontSize) {
                    fm.font.pixelSize = size  // Ceci est toujours "à risque", voir plus bas
                    var lines = text.split("\n")
                    var maxLineWidth = 0
                    var totalHeight = 0

                    for (var i = 0; i < lines.length; i++) {
                        var rect = fm.boundingRect(lines[i])
                        maxLineWidth = Math.max(maxLineWidth, rect.width)
                        totalHeight += rect.height
                    }

                    if (maxLineWidth <= button.width * 0.85 &&
                            totalHeight <= button.height * 0.9) {
                        break
                    }
                    size -= 1
                }
                return size
            }

            indicator: Item {
                id: indicatorRoot
                implicitWidth: parent.width
                implicitHeight: parent.height
                anchors.centerIn: parent

                Rectangle {
                    id: rectangleLoad
                    anchors.fill: parent
                    radius: height / 2
                    color: appTheme.bodyText

                    border.width: 0.5
                    border.color: appTheme.backgroundColor
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: root.runningText
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        rightPadding: Constants.dp(14)
                        color: "black"
                        font.pixelSize: button.optimalPixelSizeRunningText


                    }
                }

                Rectangle {
                    id: rectangleText
                    anchors.centerIn: button.checked ? undefined : parent
                    anchors.left: button.checked ? parent.left : undefined
                    width: button.checked ? height : parent.width
                    height: parent.height
                    radius: height / 2
                    color: Qt.darker(appTheme.backgroundColor, button.pressed ? 1.2 : 1.4)

                    border.width: 0
                    anchors.verticalCenter: parent.verticalCenter

                    Behavior on width {
                        NumberAnimation { duration: 200 }
                    }

                    Row {
                        id: tripleDot
                        anchors.centerIn: parent
                        spacing: 5 * Constants.scaleFactor
                        visible: button.progressState === "Loading"
                        Item {
                            width: 7 * Constants.scaleFactor
                            height: width
                            Rectangle {
                                id: dot1
                                width: parent.width
                                height: width
                                radius: width / 2
                                anchors.verticalCenter: parent.verticalCenter
                                color: "white"
                                opacity: width < parent.width ? 0.8 : 1
                            }
                        }

                        Item {
                            width: 7 * Constants.scaleFactor
                            height: width
                            Rectangle {
                                id: dot2
                                width: parent.width
                                height: width
                                radius: width / 2
                                anchors.verticalCenter: parent.verticalCenter
                                color: "white"
                                opacity: width < parent.width ? 0.8 : 1
                            }
                        }
                        Item {
                            width: 7 * Constants.scaleFactor
                            height: width
                            Rectangle {
                                id: dot3
                                width: parent.width
                                height: width
                                radius: width / 2
                                anchors.verticalCenter: parent.verticalCenter
                                color: "white"
                                opacity: width < parent.width ? 0.8 : 1
                            }
                        }

                        SequentialAnimation {
                            running: true
                            loops: Animation.Infinite

                            PropertyAnimation {
                                target: dot1
                                property: "width"
                                from: 7 * Constants.scaleFactor
                                to: 5 * Constants.scaleFactor
                                duration: 80
                            }

                            PauseAnimation { duration: 0 }

                            PropertyAnimation {
                                target: dot1
                                property: "width"
                                from: 5 * Constants.scaleFactor
                                to: 7 * Constants.scaleFactor
                                duration: 80
                            }
                            PauseAnimation { duration: 0 }

                            PropertyAnimation {
                                target: dot2
                                property: "width"
                                from: 7 * Constants.scaleFactor
                                to: 5 * Constants.scaleFactor
                                duration: 80
                            }

                            PauseAnimation { duration: 0 }

                            PropertyAnimation {
                                target: dot2
                                property: "width"
                                from: 5 * Constants.scaleFactor
                                to: 7 * Constants.scaleFactor
                                duration: 80
                            }
                            PauseAnimation { duration: 0 }

                            PropertyAnimation {
                                target: dot3
                                property: "width"
                                from: 7 * Constants.scaleFactor
                                to: 5 * Constants.scaleFactor
                                duration: 80
                            }

                            PauseAnimation { duration: 0 }

                            PropertyAnimation {
                                target: dot3
                                property: "width"
                                from: 5 * Constants.scaleFactor
                                to: 7 * Constants.scaleFactor
                                duration: 80
                            }
                            PauseAnimation { duration: 1020 }
                        }



                    }

                    Image {
                        source: "../Images/Check.svg"
                        height: tripleDot.width
                        width: height
                        visible: button.checked && button.progressState === "Done"
                        anchors.centerIn: parent
                    }

                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: startScenario()

                Loader {
                    id: opcuaLoaderExec
                    active: root.nodeIdExec !== ""
                    sourceComponent: opcuaNodeComponentExec
                }

                Component {
                    id: opcuaNodeComponentExec
                    OpcUaMonitoredNode {
                        monitored: root.visible
                        nodeId: root.nodeIdExec
                    }
                }

                Loader {
                    id: opcuaLoaderEnd
                    active: root.nodeIdEnd !== ""
                    sourceComponent: opcuaNodeComponentEnd
                }

                Component {
                    id: opcuaNodeComponentEnd
                    OpcUaMonitoredNode {
                        monitored: root.visible
                        nodeId: root.nodeIdEnd
                        onValueChanged: {
                            button.endCondition1 = (value === root.endValue)
                            // console.log("End condition 1 changed : " + button.endCondition1)
                            if (nodeIdEnd2 === "") {
                                if (value === root.endValue && button.progressState === "Loading") {
                                    button.progressState = "Done"
                                }
                            }
                        }
                    }
                }

                Loader {
                    id: opcuaLoaderEnd2
                    active: root.nodeIdEnd2 !== ""
                    sourceComponent: opcuaNodeComponentEnd2
                }

                Component {
                    id: opcuaNodeComponentEnd2
                    OpcUaMonitoredNode {
                        monitored: root.visible
                        nodeId: root.nodeIdEnd2
                        onValueChanged: {
                            button.endCondition2 = (value === root.endValue)
                            // console.log("End condition 2 changed : " + button.endCondition2)
                        }
                    }
                }
            }

            states: State {
                name: "pressed"
                when: button.pressed
                PropertyChanges {
                    target: button
                    opacity: 1
                }
            }

            transitions: Transition {
                from: "*"
                to: "pressed"
                reversible: true
                NumberAnimation {
                    properties: "opacity"
                    duration: 100
                }
            }

            FontMetrics {
                id: fm
                font: label.font
            }

            Text {
                id: label
                anchors.centerIn: parent
                color: appTheme.moduleText
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                visible: !button.checked
                font.bold: true
                font.pixelSize: button.optimalPixelSizeLabelText
                text: root.labelText


                // Timer utilisé pour déclencher le calcul de la taille du texte après le rendu initial.
                // Permet d’éviter un binding loop qui surviendrait si le font.pixelSize était calculé
                // dynamiquement à partir de FontMetrics dans une propriété liée.
                Timer {
                    id: fontCalcTimer
                    interval: 1
                    running: true
                    repeat: false
                    onTriggered: {
                        button.optimalPixelSizeLabelText = button.calculateFontSize(root.labelText, button.width * 0.12 )
                        button.optimalPixelSizeRunningText = button.calculateFontSize(root.runningText, (button.width - button.height) * 0.15)
                    }
                }

                Rectangle {
                    width: button.width
                    height: button.height
                    anchors.centerIn: parent
                    radius: height / 2
                    color: "#606060"
                    border.width: 0
                    opacity: 0.45
                    visible: !button.enabled
                }
            }

            background: Rectangle{
                color: "transparent"
            }

        }


        Item {
            Layout.fillWidth: true
        }

        Button {
            id: stopCross
            Layout.preferredHeight: button.height * 0.9
            Layout.preferredWidth: height

            property color barColor: appTheme.bodyText
            property real thickness: Math.max(2, height * 0.12)
            property real length: Math.min(width, height) * 0.6

            background: Rectangle {
                anchors.fill: parent
                radius: height / 2
                color: Qt.darker(appTheme.gradientMid, stopCross.pressed ? 1.2 : 1 )

                Item {
                    id: cross
                    anchors.fill: parent
                    visible: !raz.visible

                    Rectangle {
                        anchors.centerIn: parent
                        width: stopCross.length
                        height: stopCross.thickness
                        radius: height / 2
                        color: stopCross.barColor
                        rotation: 45
                        antialiasing: true
                    }

                    Rectangle {
                        anchors.centerIn: parent
                        width: stopCross.length
                        height: stopCross.thickness
                        radius: height / 2
                        color: stopCross.barColor
                        rotation: -45
                        antialiasing: true
                    }
                }

                Label {
                    id: raz
                    anchors.centerIn: parent
                    text: "Reset"
                    color: appTheme.bodyText
                    font.pixelSize: Constants.sp(14)
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    visible: root.razButton && button.progressState !== "Loading"
                }

                Rectangle {
                    radius: width / 2
                    anchors.fill: parent
                    color: "#606060"
                    border.width: 0
                    opacity: 0.45
                    visible: !root.enabled
                }
            }

            opacity: root.razButton ? 1 : button.checked ? 1 : 0

            Behavior on opacity {
                NumberAnimation { duration: 120 }
            }

            onClicked: {
                if (opcuaLoaderReset.item) {
                    resetScenario()
                    console.log("Reset button clicked")
                }
                else if (opcuaLoaderExec.item){
                    stopScenario()
                }

            }

            Loader {
                id: opcuaLoaderReset
                active: root.nodeIdReset !== ""
                sourceComponent: opcuaNodeComponentReset
            }

            Component {
                id: opcuaNodeComponentReset
                OpcUaMonitoredNode {
                    monitored: root.visible
                    nodeId: root.nodeIdReset
                }
            }

            OpcUaMonitoredNode {
                monitored: root.visible
                id: opcuaNodeAcquitter
                nodeId: "Arp.Plc.Eclr/acquitterTout"
                onValueChanged: {
                    if (!opcuaNodeMaitreFours.value) { root.enabled = true }
                }
            }

            OpcUaMonitoredNode {
                monitored: root.visible
                id: opcuaNodeMaitreFours
                nodeId: "Arp.Plc.Eclr/startMaitreFours"
                onValueChanged: {
                    if (root.nodeIdExec !== "Arp.Plc.Eclr/windingEnd" && root.nodeIdExec !== "Arp.Plc.Eclr/impulsionBobbinRecovery") {
                        if (value) { root.enabled = false } else { root.enabled = true }
                    }
                }
            }
        }
    }
}
