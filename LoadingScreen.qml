import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Bobink
import "../"
import "./Resources/Components"

Item {
    id: root
    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Qt.darker(appTheme.backgroundColor, 1.2)
    }

    ColumnLayout {
        anchors.fill: parent

        Item {
            Layout.fillHeight: true
        }
        Item {
            Layout.fillHeight: true
        }

        Image {
	sourceSize: Qt.size(width, height) 
            id: logoImage

            source: "Resources/Images/BobinkLogo.svg"
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: 250 * Constants.scaleFactor
            Layout.preferredWidth: height

            smooth: true
            antialiasing: true

            transform: Rotation {
                id: logoRotation
                origin.x: logoImage.width / 2
                origin.y: logoImage.height / 2
                angle: 0
            }

            SequentialAnimation {
                id: rotateAnim
                running: true
                loops: Animation.Infinite

                PropertyAnimation {
                    target: logoRotation
                    property: "angle"
                    from: 0
                    to: 180
                    duration: 500
                    easing.type: Easing.InOutQuad
                }

                PauseAnimation {
                    duration: 1000
                }

                PropertyAnimation {
                    target: logoRotation
                    property: "angle"
                    from: 180
                    to: 360
                    duration: 500
                    easing.type: Easing.InOutQuad
                }

                PauseAnimation {
                    duration: 1000
                }
            }
        }

        Image {
	sourceSize: Qt.size(width, height) 
            id: bobinkTitle
            source: "Resources/Images/BobinkTitle.svg"
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: 150 * Constants.scaleFactor
            Layout.preferredWidth: 500 * Constants.scaleFactor
            fillMode: Image.PreserveAspectFit
        }

        Item {
            width: 300 * Constants.scaleFactor
            height: 15 * Constants.scaleFactor

            Rectangle {
                id: loaderLine
                width: 500
                height: parent.height
                radius: height / 2
                x: -width
                property color color: "white"

                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop {
                        position: 0.0
                        color: "transparent"
                    }
                    GradientStop {
                        position: 0.75
                        color: loaderLine.color
                    }
                    // GradientStop {position: 0.7; color: appTheme.bodyText}
                    // GradientStop {position: 1.0; color: "transparent"}
                }

                SequentialAnimation on x {
                    loops: Animation.Infinite

                    PropertyAnimation {
                        from: 0
                        to: root.width
                        duration: 1500
                        easing.type: Easing.InOutSine
                    }
                }

                SequentialAnimation on width {
                    loops: Animation.Infinite

                    PropertyAnimation {
                        from: 50
                        to: 500
                        duration: 750
                        easing.type: Easing.InOutSine
                    }

                    PropertyAnimation {
                        from: 500
                        to: 50
                        duration: 750
                        easing.type: Easing.InOutSine
                    }
                }

                SequentialAnimation on opacity {
                    loops: Animation.Infinite

                    PropertyAnimation {
                        from: 0.0
                        to: 1.0
                        duration: 750
                        easing.type: Easing.InOutSine
                    }

                    PropertyAnimation {
                        from: 1.0
                        to: 0.0
                        duration: 750
                        easing.type: Easing.InOutSine
                    }
                }

                SequentialAnimation on color {

                    id: colorAnim
                    loops: Animation.Infinite
                    property int duration :250

                    ColorAnimation {
                        target: loaderLine
                        property: "color"
                        to: "red"
                        duration: colorAnim.duration
                    }
                    ColorAnimation {
                        target: loaderLine
                        property: "color"
                        to: "orange"
                        duration: colorAnim.duration
                    }
                    ColorAnimation {
                        target: loaderLine
                        property: "color"
                        to: "yellow"
                        duration: colorAnim.duration
                    }
                    ColorAnimation {
                        target: loaderLine
                        property: "color"
                        to: "green"
                        duration: colorAnim.duration //parent.colorTime
                    }
                    ColorAnimation {
                        target: loaderLine
                        property: "color"
                        to: "cyan"
                        duration: colorAnim.duration
                    }
                    ColorAnimation {
                        target: loaderLine
                        property: "color"
                        to: "blue"
                        duration: colorAnim.duration
                    }
                    ColorAnimation {
                        target: loaderLine
                        property: "color"
                        to: "magenta"
                        duration: colorAnim.duration
                    }
                    ColorAnimation {
                        target: loaderLine
                        property: "color"
                        to: "red"
                        duration: colorAnim.duration
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }

        ListModel {
            id: loadModel
            // states : [loading, done, fail]

            ListElement {
                name: "Connexion au proxy"
                state: "loading"
            }
            ListElement {
                name: "Connexion à la machine"
                state: "loading"
            }
            ListElement {
                name: "Initialisation de l'IHM"
                state: "loading"
            }
            ListElement {
                name: "Connexion aux capteurs"
                state: "loading"
            }
        }

        Timer {
            id: fakeLoadTimer
            running: true
            interval: 500
            repeat: true

            property int maxRun: loadModel.count
            property int i: 0

            onTriggered: {
                    if (i === 2) {
                        interval = 130
                    }

                    if (i < maxRun) {
                        loadModel.set(i, {
                            name: loadModel.get(i).name,
                            state: "done"
                        })
                        i++
                    } else {
                        running = false
                        startBtn.opacity = 1
                    }
                }

        }

        ListView {
            id: listView
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: root.width
            Layout.preferredHeight: 300 * Constants.scaleFactor


            model: loadModel
            delegate: RowLayout {
                id: delegateListView
                required property string state
                required property string name

                spacing: 20 * Constants.scaleFactor
                anchors.left: parent.left

                Item {
                    Layout.preferredWidth: root.width / 2 + tripleDot.width + parent.spacing
                    Layout.preferredHeight: 50 * Constants.scaleFactor
                    Layout.alignment: Qt.AlignLeft

                    Text {
                        id: listText
                        anchors.fill: parent
                        text: delegateListView.name
                        font.pixelSize: 18 * Constants.scaleFactor
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        lineHeight: 1.5
                        font.family: "Object Sans"
                        color: appTheme.bodyText
                    }
                }

                Row {
                    id: tripleDot
                    spacing: 5 * Constants.scaleFactor
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                    visible: delegateListView.state === "loading"


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
	sourceSize: Qt.size(width, height) 
                    source: "Resources/Images/Check.svg"
                    Layout.preferredHeight: tripleDot.width
                    Layout.preferredWidth: height
                    visible: delegateListView.state === "done"
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignRight

                }

                // Item {
                //     id: root
                //     Layout.preferredHeight: 25
                //     Layout.preferredWidth: height

                //     property real angle: 0
                //     property real angle2: 0
                //     property real angle3: 0
                //     property real radius: 8 // Rayon du cercle
                //     property real centerX: width / 2
                //     property real centerY: height / 2

                //     Rectangle {
                //         width: 7.5
                //         height: 7.5
                //         radius: width / 2
                //         color: appTheme.bodyText
                //         opacity: 0.8
                //         x: root.centerX + root.radius * Math.cos(root.angle3 * 0.01745) - width / 2
                //         y: root.centerY + root.radius * Math.sin(root.angle3 * 0.01745) - height / 2
                //     }

                //     Rectangle {
                //         width: 7.75
                //         height: 7.75
                //         radius: width / 2
                //         color: appTheme.bodyText
                //         opacity: 0.9
                //         x: root.centerX + root.radius * Math.cos(root.angle2 * 0.01745) - width / 2
                //         y: root.centerY + root.radius * Math.sin(root.angle2 * 0.01745) - height / 2
                //     }

                //     Rectangle {
                //         id: dot
                //         width: 8
                //         height: 8
                //         radius: width / 2
                //         color: appTheme.bodyText
                //         x: root.centerX + root.radius * Math.cos(root.angle * 0.01745) - width / 2
                //         y: root.centerY + root.radius * Math.sin(root.angle * 0.01745) - height / 2
                //     }

                //     NumberAnimation on angle {
                //         from: 0
                //         to: 360
                //         duration: 1500
                //         loops: Animation.Infinite
                //         easing.type: Easing.InOutSine
                //         running: true
                //     }

                //     NumberAnimation on angle2 {
                //         id: angle2Anim
                //         from: 0
                //         to: 360
                //         duration: 1500
                //         loops: Animation.Infinite
                //         easing.type: Easing.InOutSine
                //         running: false
                //     }

                //     NumberAnimation on angle3 {
                //         id: angle3Anim
                //         from: 0
                //         to: 360
                //         duration: 1500
                //         loops: Animation.Infinite
                //         easing.type: Easing.InOutSine
                //         running: false
                //     }

                //     Timer {
                //         interval: 50
                //         running: true
                //         onTriggered: angle2Anim.running = true
                //     }

                //     Timer {
                //         interval: 100
                //         running: true
                //         onTriggered: angle3Anim.running = true
                //     }
                // }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            ModuleButton {
                id: startBtn
                opacity: 0
                Layout.alignment: Qt.AlignHCenter
                labelText: "Start"
                bordered: true
                Layout.preferredHeight: Constants.dp(60)
                Layout.preferredWidth: Constants.dp(130)
                onClicked: {
                    // stack.push(mainComponent)
                    root.visible = false
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }

}
