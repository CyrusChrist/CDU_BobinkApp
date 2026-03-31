import QtQuick
import QtQuick.Controls
import Bobink
import QtQuick.Controls.Basic
import QtQuick.Effects
import QtQuick.Layouts
import "../.."

Button {
    id: control
    text: ""
    implicitWidth: 75
    implicitHeight: 75
    checkable: true

    // property bool withImage: false
    property bool disactivated: false
    property string nodeId: ""

    indicator: Item {
        id: indicatorRoot
        implicitWidth: parent.width
        implicitHeight: parent.height
        anchors.centerIn: parent

        Rectangle {
            id: rectangle
            anchors.fill: parent
            radius: height / 2
            gradient: Gradient {
                orientation: control.rotation !== -90 ? Gradient.Vertical : Gradient.Horizontal
                GradientStop {position: 0.0; color: "black" }
                GradientStop {position: 1.0; color: "white"}
            }

            border.width: 0
            anchors.verticalCenter: parent.verticalCenter
            opacity: 0.5
            rotation: control.rotation === -90 ? 180 : 0
        }

        Rectangle {
            id: innerRectangle
            width: rectangle.width - 2 * Constants.scaleFactor
            height: rectangle.height - 2 * Constants.scaleFactor
            radius: height / 2
            border.width: 0
            // anchors.verticalCenter: parent.verticalCenter
            anchors.centerIn: parent
            color: control.checked ? "#36a646" : "#f0f0f0"

            Behavior on color {
                ColorAnimation {
                    duration: 150
                    easing.type: Easing.InOutQuad
                }
            }
        }    

        Item {
            id: loadingArc
            anchors.centerIn: parent
            width: control.height
            height: width
            visible: false

            // Arc de chargement
            Canvas {
                id: arcCanvas
                anchors.fill: parent
                antialiasing: true
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.clearRect(0, 0, width, height);

                    var centerX = width / 2;
                    var centerY = height / 2;
                    var radius = width * 0.4;
                    var startAngle = 0;
                    var endAngle = Math.PI * 1.2; // 216°

                    ctx.beginPath();
                    ctx.arc(centerX, centerY, radius, startAngle, endAngle, false);
                    ctx.lineWidth = width * 0.2;
                    ctx.strokeStyle = "#36a646";
                    ctx.stroke();
                }

                Timer {
                    interval: 16
                    running: control.checked
                    repeat: true
                    onTriggered: {
                        loadingArc.rotation += 3
                        if (loadingArc.rotation >= 360)
                            loadingArc.rotation = 0
                    }
                }
            }

            // Animation de rotation de l'arc
            RotationAnimator on rotation {
                running: control.checked
                loops: Animation.Infinite
                duration: 1500
                from: 0
                to: 360
            }
        }

        Rectangle {
            id: circleToggle
            anchors.centerIn: parent
            width: control.height * 0.82
            height: width
            radius: height / 2
            color: control.down ? Qt.darker(control.checked ? appTheme.bodyText : appTheme.backgroundColor, 1.1)
                                : (control.checked ? appTheme.bodyText : appTheme.backgroundColor)
            border.width: 0
            anchors.verticalCenter: parent.verticalCenter

            Behavior on color {
                ColorAnimation {
                    duration: 150
                    easing.type: Easing.InOutQuad
                }
            }

            // --- Icone Play/Pause classique ---
            Item {
                id: playPauseIcon
                anchors.fill: parent
                // visible: !control.withImage

                RowLayout {
                    visible: control.checked
                    anchors.fill: parent
                    spacing: width * 0.1

                    Item {Layout.fillWidth: true}

                    Rectangle {
                        Layout.preferredHeight: parent.height * 0.5
                        Layout.preferredWidth: height * 0.3
                        radius: width * 0.3
                        color:  "#36a646"
                    }

                    Rectangle {
                        Layout.preferredHeight: parent.height * 0.5
                        Layout.preferredWidth: height * 0.3
                        radius: width * 0.3
                        color: "#36a646"
                    }

                    Item {Layout.fillWidth: true}

                }

                Item {
                    anchors.centerIn: parent
                    width: parent.width * 0.4
                    height: parent.height * 0.5
                    visible: !control.checked

                    Canvas {
                        id: triangleCanvas
                        anchors.fill: parent
                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.clearRect(0, 0, width, height)

                            ctx.fillStyle = "#F0F0F0"
                            ctx.beginPath()

                            // Taille du triangle
                            var side = width
                            var centerX = width / 2
                            var centerY = height / 2

                            // Coordonnées du triangle
                            var heightTriangle = height
                            var x1 = centerX - side * 0.3
                            var y1 = centerY + heightTriangle / 2

                            var x2 = centerX - side * 0.3
                            var y2 = centerY - heightTriangle / 2

                            var x3 = centerX + side / 2
                            var y3 = centerY

                            // Tracer le triangle
                            ctx.moveTo(x1, y1)
                            ctx.lineTo(x2, y2)
                            ctx.lineTo(x3, y3)
                            ctx.closePath()
                            ctx.fill()
                        }
                    }
                }
            }

            // --- Image ---
            // Item {
            //     anchors.fill: parent
            //     visible: control.withImage

            //     Image {
            //         anchors.centerIn: parent
            //         height: parent.height * 0.8
            //         width: height
            //         source: control.checked ? "../Images/Composants/ManualHandOn.svg" : "../Images/Composants/ManualHandOff.svg"
            //         fillMode: Image.PreserveAspectFit
            //     }

            // }

        }

        MultiEffect {
             id: blackShadow
             anchors.fill: source
             source: circleToggle
             blurMax: 6
             shadowEnabled: true
             shadowColor: control.checked ? "dark green" : "black"
             opacity: control.down ? 0 : 0.8
        }

        Rectangle {
            anchors.fill: innerRectangle
            radius: innerRectangle.radius
            anchors.centerIn: innerRectangle
            color: "dark grey"
            opacity: 0.5
            visible: disactivated
        }

    }

    background: Rectangle {
        color: "transparent"
    }

    Loader {
        id: opcuaLoader
        active: control.nodeId !== ""
        sourceComponent: opcuaNodeComponent
    }
    onCheckedChanged: {
        if(opcuaLoader.item){
            opcuaLoader.item.setValue(checked)
        }
    }
    Component {
        id: opcuaNodeComponent
        OpcUaMonitoredNode {
            monitored: control.visible
            nodeId: control.nodeId
            onValueChanged: control.checked = value
        }
    }
}
