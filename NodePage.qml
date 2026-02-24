// NodePage.qml — Displays 10 OPC UA nodes per page with tooltips.

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Bobink

Page {
    id: nodePage

    required property StackView stackRef
    required property int pageNumber
    required property var logFunction

    readonly property var pages: [
        {
            title: "Server Info",
            description: "Standard OPC UA server nodes (namespace 0)."
                + " CurrentTime updates live via monitoring.",
            nodes: [
                "ns=0;i=2258",  // CurrentTime
                "ns=0;i=2257",  // StartTime
                "ns=0;i=2259",  // State
                "ns=0;i=2261",  // ProductName
                "ns=0;i=2264"   // SoftwareVersion
            ]
        },
        {
            title: "Read-Write Scalars",
            description: "Single-value nodes with read and write access.",
            nodes: [
                "ns=1;s=bool_rw_scalar",
                "ns=1;s=int16_rw_scalar",
                "ns=1;s=uint16_rw_scalar",
                "ns=1;s=int32_rw_scalar",
                "ns=1;s=uint32_rw_scalar",
                "ns=1;s=int64_rw_scalar",
                "ns=1;s=uint64_rw_scalar",
                "ns=1;s=float_rw_scalar",
                "ns=1;s=double_rw_scalar",
                "ns=1;s=string_rw_scalar",
                "ns=1;s=sbyte_rw_scalar",
                "ns=1;s=byte_rw_scalar",
                "ns=1;s=datetime_rw_scalar",
                "ns=1;s=guid_rw_scalar",
                "ns=1;s=bytestring_rw_scalar"
            ]
        },
        {
            title: "Read-Only Scalars",
            description: "Single-value nodes with read-only access.",
            nodes: [
                "ns=1;s=bool_ro_scalar",
                "ns=1;s=int16_ro_scalar",
                "ns=1;s=uint16_ro_scalar",
                "ns=1;s=int32_ro_scalar",
                "ns=1;s=uint32_ro_scalar",
                "ns=1;s=int64_ro_scalar",
                "ns=1;s=uint64_ro_scalar",
                "ns=1;s=float_ro_scalar",
                "ns=1;s=double_ro_scalar",
                "ns=1;s=string_ro_scalar",
                "ns=1;s=sbyte_ro_scalar",
                "ns=1;s=byte_ro_scalar",
                "ns=1;s=datetime_ro_scalar",
                "ns=1;s=guid_ro_scalar",
                "ns=1;s=bytestring_ro_scalar"
            ]
        },
        {
            title: "Read-Write Arrays",
            description: "Array nodes. Values are displayed comma-separated."
                + " To write, enter comma-separated values (e.g. \"1, 2, 3\")."
                + " Commas cannot appear inside individual values.",
            nodes: [
                "ns=1;s=bool_rw_array",
                "ns=1;s=int16_rw_array",
                "ns=1;s=uint16_rw_array",
                "ns=1;s=int32_rw_array",
                "ns=1;s=uint32_rw_array",
                "ns=1;s=int64_rw_array",
                "ns=1;s=uint64_rw_array",
                "ns=1;s=float_rw_array",
                "ns=1;s=double_rw_array",
                "ns=1;s=string_rw_array",
                "ns=1;s=sbyte_rw_array",
                "ns=1;s=byte_rw_array",
                "ns=1;s=datetime_rw_array",
                "ns=1;s=guid_rw_array",
                "ns=1;s=bytestring_rw_array"
            ]
        },
        {
            title: "Index Range Write",
            description: "Write to specific array elements using OPC UA index"
                + " range syntax. Examples: \"0\" = first element,"
                + " \"0:2\" = elements 0–2. Enter the range and the value(s)"
                + " to write (comma-separated for multi-element ranges).",
            indexRange: true,
            nodes: [
                "ns=1;s=int32_rw_array",
                "ns=1;s=float_rw_array",
                "ns=1;s=string_rw_array"
            ]
        },
        {
            title: "Non-Existent Nodes",
            description: "These node IDs do not exist on the server."
                + " The row should show no value and no metadata in the tooltip.",
            nodes: [
                "ns=1;s=does_not_exist",
                "ns=99;i=12345",
                "ns=1;s=also_missing"
            ]
        },
        {
            title: "Empty (Monitoring Test)",
            description: "No nodes on this page. All previous pages are inactive,"
                + " so the server log should show zero active monitored items.",
            nodes: []
        }
    ]

    readonly property var currentPage: pages[pageNumber - 1]

    // OPC UA ServerState enum (Part 4, Table 120).
    readonly property var serverStates: [
        "Running", "Failed", "NoConfiguration", "Suspended",
        "Shutdown", "Test", "CommunicationFault", "Unknown"
    ]

    function formatValue(node) {
        var v = node.value;
        if (v === undefined || String(v) === "")
            return "—";
        // Map ServerState enum to human-readable string.
        if (node.nodeId === "ns=0;i=2259" && !isNaN(v))
            return serverStates[v] || String(v);
        return String(v);
    }

    Component.onCompleted: nodePage.logFunction(
        currentPage.title + " page loaded (" + currentPage.nodes.length + " nodes)")

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 4

        // Header
        RowLayout {
            Label {
                text: currentPage.title
                font.bold: true
                font.pointSize: 14
            }
            Label {
                text: "(" + nodePage.pageNumber + "/" + nodePage.pages.length + ")"
                color: "gray"
            }
            Item { Layout.fillWidth: true }
            Button {
                text: "Disconnect"
                onClicked: Bobink.disconnectFromServer()
            }
        }

        Label {
            id: pageDescription
            visible: currentPage.description !== undefined
            text: currentPage.description || ""
            wrapMode: Text.WordWrap
            color: "gray"
            font.italic: true
            Layout.fillWidth: true
        }

        // Column headers
        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 12
            Layout.rightMargin: 12
            spacing: 12
            Label {
                text: "Identifier"
                font.bold: true
                Layout.preferredWidth: 160
            }
            Label {
                text: "Value"
                font.bold: true
                Layout.preferredWidth: 300
            }
            Label {
                text: "Write"
                font.bold: true
                Layout.fillWidth: true
            }
        }

        Rectangle {
            id: separator
            Layout.fillWidth: true
            height: 1
            color: "#ccc"
        }

        // Nodes
        Repeater {
            model: currentPage.nodes

            ItemDelegate {
                id: delegate
                required property string modelData
                required property int index
                Layout.fillWidth: true
                padding: 4
                leftPadding: 12
                rightPadding: 12

                OpcUaMonitoredNode {
                    id: node
                    nodeId: delegate.modelData
                    monitored: nodePage.StackView.status === StackView.Active
                    onWriteCompleted: (success, message) => {
                        var short_id = node.nodeId.substring(node.nodeId.indexOf(";s=") + 3);
                        nodePage.logFunction(short_id + ": " + message);
                    }
                }

                background: Rectangle {
                    color: delegate.index % 2 === 0 ? "#f8f8f8" : "transparent"
                    radius: 2
                }

                contentItem: RowLayout {
                    spacing: 12

                    // Column 1: Display name if available, otherwise short ID.
                    Label {
                        text: {
                            if (node.info.displayName)
                                return node.info.displayName;
                            var idx = node.nodeId.indexOf(";s=");
                            return idx >= 0 ? node.nodeId.substring(idx + 3) : node.nodeId;
                        }
                        Layout.preferredWidth: 160
                        elide: Text.ElideRight
                    }

                    // Column 2: Live value (always visible)
                    Label {
                        text: nodePage.formatValue(node)
                        Layout.preferredWidth: 300
                        elide: Text.ElideRight
                    }

                    // Column 3: Edit area (writable) or READ-ONLY label

                    // Normal write controls (non-index-range pages)
                    TextField {
                        id: editField
                        visible: node.writable && !currentPage.indexRange
                        Layout.fillWidth: true
                        placeholderText: "Enter value..."
                        onAccepted: node.writeValue(text)
                    }
                    Button {
                        visible: node.writable && !currentPage.indexRange
                        text: "Write"
                        onClicked: node.writeValue(editField.text)
                    }

                    // Index range write controls
                    TextField {
                        id: rangeField
                        visible: node.writable && currentPage.indexRange === true
                        Layout.preferredWidth: 60
                        placeholderText: "Range"
                    }
                    TextField {
                        id: rangeValueField
                        visible: node.writable && currentPage.indexRange === true
                        Layout.fillWidth: true
                        placeholderText: "Value(s)..."
                        onAccepted: node.writeValueAtRange(text, rangeField.text)
                    }
                    Button {
                        visible: node.writable && currentPage.indexRange === true
                        text: "Write Range"
                        onClicked: node.writeValueAtRange(rangeValueField.text, rangeField.text)
                    }

                    Label {
                        visible: !node.writable
                        text: "(READ-ONLY)"
                        color: "gray"
                        font.italic: true
                        Layout.fillWidth: true
                    }
                }

                ToolTip.visible: hovered
                ToolTip.delay: 400
                ToolTip.text:
                    "Display Name: " + (node.info.displayName || "—")
                    + "\nDescription: " + (node.info.description || "—")
                    + "\nNode Class: " + (node.info.nodeClass || "—")
                    + "\nData Type: " + (node.info.dataType || "—")
                    + "\nValue Rank: " + (node.info.valueRank || "—")
                    + "\nArray Dimensions: " + (node.info.arrayDimensions || "—")
                    + "\nAccess Level: " + node.info.accessLevel
                    + "\nStatus: " + (node.info.status || "—")
                    + "\nSource Time: " + (node.info.sourceTimestamp.toLocaleString() || "—")
                    + "\nServer Time: " + (node.info.serverTimestamp.toLocaleString() || "—")
            }
        }

        Item { Layout.fillHeight: true }

        // Navigation
        RowLayout {
            Layout.fillWidth: true
            Button {
                text: "← Previous"
                visible: nodePage.pageNumber > 1
                onClicked: nodePage.stackRef.pop()
            }
            Item { Layout.fillWidth: true }
            Button {
                text: "Next →"
                visible: nodePage.pageNumber < nodePage.pages.length
                onClicked: nodePage.stackRef.push("NodePage.qml", {
                    stackRef: nodePage.stackRef,
                    pageNumber: nodePage.pageNumber + 1,
                    logFunction: nodePage.logFunction
                })
            }
        }
    }
}
