import Bobink
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Resources/Components"
import "motorData.js" as MotorModel
import "../"

Item {
    id: root

    readonly property int textFieldWidth: 100
    readonly property int textFieldHeight: 40
    property var motorSelected: MotorModel.motorData[axisSelection.currentIndex]//null

    ScrollView {
        id: scrollView
        ScrollBar.vertical.policy: ScrollBar.AsNeeded
        ScrollBar.horizontal.policy: ScrollBar.AsNeeded
        ScrollBar.horizontal.interactive: true
        anchors.fill: parent
        anchors.leftMargin: Constants.dp(40)

        ColumnLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: Constants.dp(10)

            RowLayout {
                Layout.preferredWidth: dataView.width
                Layout.alignment: Qt.AlignHCenter

                ColumnLayout {
                    spacing: Constants.dp(10)
                    Text {
                        Layout.leftMargin: 0 * Constants.scaleFactor
                        Layout.topMargin: 0 * Constants.scaleFactor
                        text: qsTr("Paramètres des axes")
                        font.pixelSize: Math.max(30, root.width * 0.03)
                        font.bold: true
                        color: appTheme.bodyText
                    }

                    ComboBox {
                        id: axisSelection
                        Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                        implicitWidth: 300

                        model: MotorModel.motorData.map(axis => axis.moteur)

                        onCurrentIndexChanged: {
                            root.motorSelected = MotorModel.motorData[axisSelection.currentIndex]
                            //makeOPCUANode(root.motorSelected)
                            // BobinkMachineModel.connected_to_proxy()
                        }

                    }
                }



                StyledFrame {
                    id: retourArmoireElectrique
                    Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                    style: "shadowed"

                    RowLayout {
                        anchors.fill: parent
                        GridLayout {
                            rowSpacing: Constants.spacing / 3
                            columnSpacing: Constants.spacing
                            columns: 2
                            Label {
                                color: appTheme.bodyText
                                text: qsTr("Contact Auxiliaire")
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            StatusIndicator {
                                id: statusIndicatorContactAuxiliaire
                                color: "green"
                                nodeId: motorSelected.contactAuxiliaire
                            }

                            Label {
                                color: appTheme.bodyText
                                text: qsTr("Retour de Marche")
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            StatusIndicator {
                                id: statusIndicatorRetourDeMarche
                                color: "green"
                                nodeId: motorSelected.RDMContacteur
                            }
                        }

                        ToolSeparator {
                            Layout.fillHeight: true
                            // Layout.rowSpan: 2

                            // Layout.column: 2
                        }
                        GridLayout {
                            rowSpacing: Constants.spacing / 3
                            columnSpacing: Constants.spacing
                            columns: 2
                            // anchors.fill: parent
                            Label {
                                color: appTheme.bodyText
                                text: qsTr("Erreur Disjoncteur")
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            StatusIndicator {
                                id: statusIndicatorErreurDisjoncteur
                                color: "red"
                                nodeId: motorSelected.erreurDisjoncteur
                            }

                            Label {
                                color: appTheme.bodyText
                                text: qsTr("Erreur Contacteur")
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            StatusIndicator {
                                id: statusIndicatorErreurContacteur
                                color: "red"
                                nodeId: motorSelected.erreurContacteur
                            }
                        }
                    }
                }
            }

            StyledFrame {
                id: dataView
                scale: 1
                Layout.alignment: Qt.AlignHCenter
                style: "shadowed"

                RowLayout {
                    anchors.fill: parent
                    Item {
                        Layout.fillWidth: true
                    }

                    ColumnLayout {
                        id: firstColumn
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignTop
                        spacing: Constants.spacing / 2

                        StyledFrame {
                            id: axisControl
                            Layout.fillWidth: true
                            ColumnLayout {
                                Label {
                                    text:"Axis Control"
                                    color: appTheme.bodyText
                                }
                                GridLayout {
                                    rowSpacing: Constants.spacing / 2
                                    columnSpacing: Constants.spacing
                                    columns: 3

                                    GridLayout {
                                        rowSpacing: Constants.spacing / 2
                                        columnSpacing: Constants.spacing
                                        columns: 2
                                        Layout.alignment: Qt.AlignTop

                                        // uniformCellWidths: true
                                        Label {
                                            text: qsTr("Enable")
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        CustomSwitch {
                                            id: switchEnableAxisControl
                                            //
                                        }

                                        Label {
                                            text: qsTr("AlarmClear")
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        CustomSwitch {
                                            id: swicthAlarmClearAxisControl
                                            //
                                        }
                                    }

                                    ToolSeparator {
                                        Layout.fillHeight: true
                                    }

                                    GridLayout {
                                        rowSpacing: Constants.spacing / 2
                                        columnSpacing: Constants.spacing
                                        columns: 2

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Status")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            id: statusIndicatorStatusAxisControl
                                            color: "green"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.axisControlEnable
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("AxisAlarm")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            id: statusIndicatorAxisAlarmAxisControl
                                            color: "yellow"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.axisControlAlarmClear
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("DriveWarning")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            id: statusIndicatorDriveWarningAxisControl
                                            color: "yellow"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.axisControlDriveWarning
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Error")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            id: statusIndicatorErrorAxisControl
                                            color: "red"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.axisControlError
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("ErrorID")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        NumericInput {
                                            id: textFieldErrorIDAxisControl
                                            min:0
                                            max:2000
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            Layout.preferredWidth: textFieldWidth
                                            Layout.preferredHeight: textFieldHeight
                                            selectByMouse: false
                                            readOnly: true
                                            text: qsTr("0")
                                            OpcUaMonitoredNode {
                                                monitored: root.visible
                                                nodeId: motorSelected.axisControlErrorID
                                                onValueChanged: parent.text = value
                                            }
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("DriveWarningID")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        NumericInput {
                                            id: textFieldDriveWarningIDAxisControl
                                            min:0
                                            max:2000
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            Layout.preferredWidth: textFieldWidth
                                            Layout.preferredHeight: textFieldHeight
                                            horizontalAlignment: Text.AlignHCenter
                                            selectByMouse: false
                                            readOnly: true
                                            text: qsTr("0")
                                            OpcUaMonitoredNode {
                                                monitored: root.visible
                                                nodeId: motorSelected.axisControlDriveWarningID
                                                onValueChanged: parent.text = value
                                            }
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("DriveAlarmID")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        NumericInput {
                                            id: textFieldDriveAlarmIDAxisControl
                                            min:0
                                            max:2000
                                            Layout.preferredWidth: textFieldWidth
                                            Layout.preferredHeight: textFieldHeight
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            selectByMouse: false
                                            readOnly: true
                                            text: qsTr("0")
                                            OpcUaMonitoredNode {
                                                monitored: root.visible
                                                nodeId: motorSelected.axisControlDriveAlarmID
                                                onValueChanged: parent.text = value
                                            }
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("ControlAlarmID")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        NumericInput {
                                            id: textFieldControlAlarmIDAxisControl
                                            min:0
                                            max:2000
                                            Layout.preferredWidth: textFieldWidth
                                            Layout.preferredHeight: textFieldHeight
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            selectByMouse: false
                                            readOnly: true
                                            text: qsTr("0")
                                            OpcUaMonitoredNode {
                                                monitored: root.visible
                                                nodeId: motorSelected.axisControlControlAlarmID
                                                onValueChanged: parent.text = value
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        StyledFrame {
                            id: status
                            Layout.fillWidth: true
                            ColumnLayout {
                                Label {
                                    text:"Status"
                                    color: appTheme.bodyText
                                }
                                RowLayout {

                                    GridLayout {
                                        rowSpacing: Constants.spacing / 2
                                        columnSpacing: Constants.spacing
                                        columns: 2

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Valid")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            id: statusIndicatorValidStatus
                                            color: "green"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.statusValid
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Busy")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            id: statusIndicatorBusyStatus
                                            color: "green"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.statusBusy
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("ErrorStop")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            id: statusIndicatorErrorStopStatus
                                            color: "red"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.statusErrorStop
                                        }

                                        ToolSeparator {
                                            Layout.fillWidth: true
                                            Layout.columnSpan: 2
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            orientation: Qt.Horizontal
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("ConstantVelocity")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            id: statusIndicatorConstantVelocityStatus
                                            color: "green"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.statusConstantVelocity
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Accelerating")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            id: statusIndicatorAcceleratingStatus
                                            color: "green"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.statusAccelerating
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Decelerating")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            id: statusIndicatorDeceleratingStatus
                                            color: "green"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.statusDecelerating
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Error")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            id: statusIndicatorErrorStatus
                                            color: "red"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.statusError
                                        }

                                        Label {
                                            color: appTheme.bodyText

                                            text: qsTr("ErrorID")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        NumericInput {
                                            min:0
                                            max:2000
                                            id: textFieldControlAlarmIDStatus
                                            Layout.preferredWidth: textFieldWidth
                                            Layout.preferredHeight: textFieldHeight
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            selectByMouse: false
                                            readOnly: true
                                            text: qsTr("0")

                                            OpcUaMonitoredNode {
                                                monitored: root.visible
                                                nodeId: motorSelected.statusErrorID
                                                onValueChanged: parent.text = value

                                            }
                                        }
                                    }

                                    ToolSeparator {
                                        Layout.fillHeight: true
                                    }

                                    GridLayout {
                                        rowSpacing: Constants.spacing / 2
                                        columnSpacing: Constants.spacing
                                        columns: 2

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Disable")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            id: statusIndicatorDisableStatus
                                            color: "green"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.statusDisable
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Stopping")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            id: statusIndicatorStoppingStatus
                                            color: "green"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.statusStopping
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("StandStill")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            id: statusIndicatorStandStillStatus
                                            color: "green"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.statusStandStill
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("DiscreteMotion")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            id: statusIndicatorDiscreteMotionStatus
                                            color: "green"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.statusDiscreteMotion
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("ContinuousMotion")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            id: statusIndicatorContinuousMotionStatus
                                            color: "green"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.statusContinuousMotion
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("SynchronizedMotion")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            id: statusIndicatorSynchronizedMotionStatus
                                            color: "green"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.statusSynchronizedMotion
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Homing")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            id: statusIndicatorHomingStatus
                                            color: "green"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.statusHoming
                                        }
                                    }
                                }
                            }
                        }


                    }

                    ColumnLayout {
                        id: secondColumn
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignTop
                        spacing: Constants.spacing / 2

                        StyledFrame {
                            id: gearIn
                            Layout.fillWidth: true
                            ColumnLayout {
                                Label {
                                    text:"GearIn"
                                    color: appTheme.bodyText
                                }
                                // anchors.left: parent.left
                                // anchors.right: parent.right
                                RowLayout {


                                    // rowSpacing: Constants.spacing / 2
                                    // columnSpacing: Constants.spacing
                                    // columns: 3
                                    GridLayout {
                                        rowSpacing: Constants.spacing / 2
                                        columnSpacing: Constants.spacing
                                        columns: 2
                                        Layout.alignment: Qt.AlignTop

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Execute")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        CustomSwitch {
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("RatioNumerator")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        NumericInput {
                                            min:0
                                            max:2000
                                            Layout.preferredWidth: textFieldWidth
                                            Layout.preferredHeight: textFieldHeight
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            unit: qsTr("1000 ‰")
                                            text: qsTr("0")
                                            OpcUaMonitoredNode {
                                                monitored: root.visible
                                                nodeId: motorSelected.gearInRatioNumerator
                                                onValueChanged: parent.text = value + " ‰"
                                            }
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Velocity")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        NumericInput {
                                            min:0
                                            max:2000
                                            Layout.preferredWidth: textFieldWidth
                                            Layout.preferredHeight: textFieldHeight
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            unit: qsTr("mm/s")
                                            text: qsTr("0")
                                            OpcUaMonitoredNode {
                                                monitored: root.visible
                                                nodeId: motorSelected.gearInVelocity
                                                onValueChanged: parent.text = value.toFixed(3) + " mm/s"
                                            }
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Acceleration")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        NumericInput {
                                            min:0
                                            max:2000
                                            Layout.preferredWidth: textFieldWidth
                                            Layout.preferredHeight: textFieldHeight
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            unit: qsTr("mm/s2")
                                            text: qsTr("mm/s2")
                                            OpcUaMonitoredNode {
                                                monitored: root.visible
                                                nodeId: motorSelected.gearInAcceleration
                                                onValueChanged: parent.text = value + " mm/s2"
                                            }
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Deceleration")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        NumericInput {
                                            min:0
                                            max:2000
                                            Layout.preferredWidth: textFieldWidth
                                            Layout.preferredHeight: textFieldHeight
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            unit: qsTr("mm/s2")
                                            text: qsTr("mm/s2")

                                            OpcUaMonitoredNode {
                                                monitored: root.visible
                                                nodeId: motorSelected.gearInDeceleration
                                                onValueChanged: parent.text = value + " mm/s2"
                                            }
                                        }
                                    }

                                    ToolSeparator {
                                        Layout.fillHeight: true
                                    }

                                    GridLayout {
                                        rowSpacing: Constants.spacing / 2
                                        columnSpacing: Constants.spacing
                                        columns: 2

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("InGear")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            color: "green"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.gearInInGear
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Busy")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            color: "yellow"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.gearInBusy
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Active")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            color: "yellow"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.gearInActive
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("CommandAborted")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            color: "green"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.gearInCommandAborted
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Error")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            color: "red"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                                            nodeId: motorSelected.gearInError
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("ErrorID")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        NumericInput {
                                            min:0
                                            max:2000
                                            Layout.preferredWidth: textFieldWidth
                                            Layout.preferredHeight: textFieldHeight
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            selectByMouse: false
                                            readOnly: true
                                            text: qsTr("0")

                                            OpcUaMonitoredNode {
                                                monitored: root.visible
                                                nodeId: motorSelected.gearInErrorID
                                                onValueChanged: parent.text = value
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        StyledFrame {
                            id: jog
                            Layout.fillWidth: true
                            ColumnLayout {
                                Label {
                                    text:"Jog"
                                    color: appTheme.bodyText
                                }
                                RowLayout {
                                    GridLayout {
                                        rowSpacing: Constants.spacing / 2
                                        columnSpacing: Constants.spacing
                                        columns: 2
                                        Layout.alignment: Qt.AlignTop

                                        Button {
                                            text: "Jog ?"
                                            Layout.columnSpan: 2
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Reverse")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        CustomSwitch {

                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Velocity")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        NumericInput {
                                            min:0
                                            max:2000
                                            Layout.preferredWidth: textFieldWidth
                                            Layout.preferredHeight: textFieldHeight
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            unit: qsTr("mm/s")
                                            text: qsTr("0")

                                            OpcUaMonitoredNode {
                                                monitored: root.visible
                                                nodeId: motorSelected.jogVelocity
                                                onValueChanged: parent.text = value.toFixed(3) + " mm/s"
                                            }
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Acceleration")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        NumericInput {
                                            min:0
                                            max:2000
                                            Layout.preferredWidth: textFieldWidth
                                            Layout.preferredHeight: textFieldHeight
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            unit: qsTr("mm/s2")
                                            text: qsTr("mm/s2")
                                            OpcUaMonitoredNode {
                                                monitored: root.visible
                                                nodeId: motorSelected.jogAcceleration
                                                onValueChanged: parent.text = value + " mm/s2"
                                            }
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Deceleration")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        NumericInput {
                                            min:0
                                            max:2000
                                            Layout.preferredWidth: textFieldWidth
                                            Layout.preferredHeight: textFieldHeight
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            unit: qsTr("mm/s2")
                                            text: qsTr("mm/s2")
                                            OpcUaMonitoredNode {
                                                monitored: root.visible
                                                nodeId: motorSelected.jogDeceleration
                                                onValueChanged: parent.text = value + " mm/s2"
                                            }
                                        }
                                    }

                                    ToolSeparator {
                                        Layout.fillHeight: true
                                    }

                                    GridLayout {
                                        rowSpacing: Constants.spacing / 2
                                        columnSpacing: Constants.spacing
                                        columns: 2

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("InVelocity")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            color: "green"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.jogInVelocity
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Done")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            color: "green"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.jogDone
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Busy")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            color: "yellow"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.jogBusy
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Error")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            color: "red"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.jogError
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("ErrorID")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        NumericInput {
                                            min:0
                                            max:2000
                                            Layout.preferredWidth: textFieldWidth
                                            Layout.preferredHeight: textFieldHeight
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            selectByMouse: false
                                            readOnly: true
                                            text: qsTr("0")
                                            OpcUaMonitoredNode {
                                                monitored: root.visible
                                                nodeId: motorSelected.jogErrorID
                                                onValueChanged: parent.text = value
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        StyledFrame {
                            id: stop
                            ColumnLayout {
                                Label {
                                    text:"Stop"
                                    color: appTheme.bodyText
                                }
                                Layout.fillWidth: true
                                RowLayout {
                                    GridLayout {
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                                        rowSpacing: Constants.spacing / 2
                                        columnSpacing: Constants.spacing
                                        columns: 2
                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Execute")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }

                                        CustomSwitch {

                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Deceleration")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        NumericInput {
                                            min:0
                                            max:2000
                                            Layout.preferredWidth: textFieldWidth
                                            Layout.preferredHeight: textFieldHeight
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            unit: qsTr("mm/s2")
                                            text: qsTr("mm/s2")
                                            OpcUaMonitoredNode {
                                                monitored: root.visible
                                                nodeId: "" //motorSelected.stopDeceleration
                                                onValueChanged: parent.text = value + " mm/s2"
                                            }
                                        }
                                    }

                                    ToolSeparator {
                                        Layout.fillHeight: true
                                    }

                                    GridLayout {
                                        rowSpacing: Constants.spacing / 2
                                        columnSpacing: Constants.spacing
                                        columns: 2

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Done")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            color: "green"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.stopAxisDone
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Busy")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            color: "yellow"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.stopAxisBusy
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Active")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            color: "yellow"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.stopAxisActive
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("CommandAborted")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            color: "green"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.stopAxisCommandAborted
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Error")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            color: "red"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.stopAxisError
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("ErrorID")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        NumericInput {
                                            min:0
                                            max:2000
                                            Layout.preferredWidth: textFieldWidth
                                            Layout.preferredHeight: textFieldHeight
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            selectByMouse: false
                                            readOnly: true
                                            text: qsTr("0")
                                            OpcUaMonitoredNode {
                                                monitored: root.visible
                                                nodeId: motorSelected.stopAxisErrorID
                                                onValueChanged: parent.text = value
                                            }
                                        }
                                    }
                                }
                            }
                        }


                    }

                    ColumnLayout {
                        id: thirdColumn
                        Layout.alignment: Qt.AlignTop
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        spacing: Constants.spacing / 2

                        StyledFrame {
                            id: valueFrame
                            Layout.fillWidth: true
                            ColumnLayout {
                                Label {
                                    text:"Value"
                                    color: appTheme.bodyText
                                }
                                RowLayout {

                                    Item {
                                        Layout.fillWidth: true
                                    }

                                    ColumnLayout{
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Position")
                                            Layout.preferredHeight: textFieldHeight
                                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                        }
                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Torque")
                                            Layout.preferredHeight: textFieldHeight
                                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                        }
                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Velocity")
                                            Layout.preferredHeight: textFieldHeight
                                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                        }
                                    }
                                    Item {
                                        Layout.preferredWidth: 30
                                    }

                                    ColumnLayout{
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                                        NumericInput {
                                            min:0
                                            max:2000
                                            Layout.preferredWidth: textFieldWidth
                                            Layout.preferredHeight: textFieldHeight
                                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            selectByMouse: false
                                            readOnly: true
                                            text: qsTr("0")
                                            OpcUaMonitoredNode {
                                                monitored: root.visible
                                                nodeId: motorSelected.valuePosition
                                                onValueChanged: parent.text = value.toFixed(5)
                                            }
                                        }




                                        NumericInput {
                                            min:0
                                            max:2000
                                            Layout.preferredWidth: textFieldWidth
                                            Layout.preferredHeight: textFieldHeight
                                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            selectByMouse: false
                                            readOnly: true
                                            text: qsTr("0")

                                            OpcUaMonitoredNode {
                                                monitored: root.visible
                                                nodeId: motorSelected.valueTorque
                                                onValueChanged: parent.text = value.toFixed(3) + " %"
                                            }
                                        }



                                        NumericInput {
                                            min:0
                                            max:2000
                                            Layout.preferredWidth: textFieldWidth
                                            Layout.preferredHeight: textFieldHeight
                                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            selectByMouse: false
                                            readOnly: true
                                            text: qsTr("0")

                                            OpcUaMonitoredNode {
                                                monitored: root.visible
                                                nodeId: motorSelected.valueVelocity
                                                onValueChanged: parent.text = value.toFixed(3) + " mm/s"
                                            }
                                        }
                                    }
                                    Item {
                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }

                        StyledFrame {
                            id: gearOut
                            Layout.fillWidth: true
                            ColumnLayout {
                                Label {
                                    text:"GearOut"
                                    color: appTheme.bodyText
                                }
                                RowLayout {

                                    // rowSpacing: Constants.spacing / 2
                                    // columnSpacing: Constants.spacing
                                    // columns: 3

                                    RowLayout {
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Execute")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        CustomSwitch {
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                    }

                                    ToolSeparator {
                                        Layout.fillHeight: true
                                    }

                                    GridLayout {
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                                        rowSpacing: Constants.spacing / 2
                                        columnSpacing: Constants.spacing
                                        columns: 2

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Done")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            color: "yellow"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.gearOutDone
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Busy")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            color: "yellow"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.gearOutBusy
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Error")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            color: "red"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.gearOutError
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("ErrorID")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        NumericInput {
                                            min:0
                                            max:2000
                                            Layout.preferredWidth: textFieldWidth
                                            Layout.preferredHeight: textFieldHeight
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            selectByMouse: false
                                            readOnly: true
                                            text: qsTr("0")
                                            OpcUaMonitoredNode {
                                                monitored: root.visible
                                                nodeId: motorSelected.gearOutErrorID
                                                onValueChanged: parent.text = value
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        StyledFrame {
                            id: resetAxis
                            Layout.fillWidth: true
                            ColumnLayout {
                                Label {
                                    text:"ResetAxis"
                                    color: appTheme.bodyText
                                }
                                RowLayout {

                                    RowLayout {
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop


                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Execute")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        CustomSwitch {

                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                                        }
                                    }

                                    ToolSeparator {
                                        Layout.fillHeight: true
                                    }

                                    GridLayout {
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

                                        rowSpacing: Constants.spacing / 2
                                        columnSpacing: Constants.spacing
                                        columns: 2

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Done")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                        }
                                        StatusIndicator {
                                            color: "yellow"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.resetAxisDone
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Busy")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                        }
                                        StatusIndicator {
                                            color: "yellow"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.resetAxisBusy
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Error")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                        }
                                        StatusIndicator {
                                            color: "red"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.resetAxisError
                                        }

                                        Label {
                                            text: qsTr("ErrorID")
                                            color: appTheme.bodyText
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                        }
                                        NumericInput {
                                            min:0
                                            max:2000
                                            Layout.preferredWidth: textFieldWidth
                                            Layout.preferredHeight: textFieldHeight
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            selectByMouse: false
                                            readOnly: true
                                            text: qsTr("0")

                                            OpcUaMonitoredNode {
                                                monitored: root.visible
                                                nodeId: motorSelected.resetAxisErrorID
                                                onValueChanged: parent.text = value
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        StyledFrame {
                            id: resetEncodeur
                            Layout.fillWidth: true
                            ColumnLayout {
                                Label {
                                    text:"ResetEncodeur"
                                    color: appTheme.bodyText
                                }
                                RowLayout {

                                    RowLayout {
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

                                        // anchors.top: parent.top
                                        Label {
                                            text: qsTr("Execute")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        CustomSwitch {

                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                    }

                                    ToolSeparator {
                                        Layout.fillHeight: true
                                    }

                                    GridLayout {
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                                        rowSpacing: Constants.spacing / 2
                                        columnSpacing: Constants.spacing
                                        columns: 2

                                        Label {
                                            text: qsTr("Done")
                                            color: appTheme.bodyText
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            color: "yellow"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.resetEncodeurDone
                                        }

                                        Label {
                                            text: qsTr("Busy")
                                            color: appTheme.bodyText
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            color: "yellow"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.resetEncodeurBusy
                                        }

                                        Label {
                                            text: qsTr("Error")
                                            color: appTheme.bodyText
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            color: "red"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.resetEncodeurError
                                        }

                                        Label {
                                            text: qsTr("ErrorID")
                                            color: appTheme.bodyText
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        NumericInput {
                                            min:0
                                            max:2000
                                            Layout.preferredWidth: textFieldWidth
                                            Layout.preferredHeight: textFieldHeight
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            selectByMouse: false
                                            readOnly: true
                                            text: qsTr("0")
                                            OpcUaMonitoredNode {
                                                monitored: root.visible
                                                nodeId: motorSelected.resetEncodeurErrorID
                                                onValueChanged: parent.text = value
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        StyledFrame {
                            id: rebootServo
                            Layout.fillWidth: true
                            ColumnLayout {
                                Label {
                                    text:"RebootServo"
                                    color: appTheme.bodyText
                                }
                                RowLayout {
                                    // rowSpacing: Constants.spacing / 2
                                    // columnSpacing: Constants.spacing
                                    // columns: 3

                                    RowLayout {
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Execute")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        CustomSwitch {
                                            id: switchExecuteRebootServo
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                    }

                                    ToolSeparator {
                                        Layout.fillHeight: true
                                    }

                                    GridLayout {
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                                        rowSpacing: Constants.spacing / 2
                                        columnSpacing: Constants.spacing
                                        columns: 2

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Done")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            id: statusIndicatorDoneRebootServo
                                            color: "yellow"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.rebootServoDone
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Busy")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            id: statusIndicatorBusyRebootServo
                                            color: "yellow"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            nodeId: motorSelected.rebootServoBusy
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("Error")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        StatusIndicator {
                                            color: "red"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                                            nodeId: motorSelected.rebootServoError
                                        }

                                        Label {
                                            color: appTheme.bodyText
                                            text: qsTr("ErrorID")
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                        NumericInput {
                                            min:0
                                            max:2000
                                            Layout.preferredWidth: textFieldWidth
                                            Layout.preferredHeight: textFieldHeight
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            selectByMouse: false
                                            readOnly: true
                                            text: qsTr("0")
                                            OpcUaMonitoredNode {
                                                monitored: root.visible
                                                nodeId: motorSelected.rebootServoErrorID
                                                onValueChanged: parent.text = value
                                            }
                                        }
                                    }
                                }
                            }
                        }


                    }
                }
            }
        }

    }
}
