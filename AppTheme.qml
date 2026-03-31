import QtQuick
import QtQuick.Controls
import Bobink
import QtQuick 2.15

QtObject {
    id: appTheme

    property string currentTheme: "dark"

    property color appBarColor: "#2D262E"
    property color backgroundColor: "#4A4A4A"

    property color bodyText: "#F0f0f0"
    property color moduleText: "#F0f0f0"
    property color inversedText: "#000000"

    property color gradientDark: "#2D262E"
    property color gradientMid: "#342D36"
    property color gradientLight1: "#323033"
    property color gradientLight2: "#454545"
    property color gradientBorder: "#8F8F8F"

    property color moduleGradient1: "#6B6B6B"
    property color moduleGradient2: "#595959"
    property color moduleGradient3: "#545454"
    property color moduleGradient4: "#454545"
    property color moduleGradient5: "#7e7e7e"

    property color pageIndColor: "#F0F0F0"

    property color stopButtonWhite: "transparent"

    readonly property color colorWait: "#4CAF50"
    readonly property color colorActing: "#2196F3"
    readonly property color colorExecute: "#FF9800"
    readonly property color colorAbort: "#f44336"
    readonly property color colorHeld: "#9C27B0"
    readonly property color colorSuspended: "#FF5722"

    function getStateColor(state) {
        switch(state) {
            case 2: case 4: case 17: return appTheme.colorWait
            case 6: return appTheme.colorExecute
            case 9: case 8: return appTheme.colorAbort
            case 10: case 11: case 12: return appTheme.colorHeld
            case 5: case 13: case 14: return appTheme.colorSuspended
            default: return appTheme.colorActing
        }
    }

    function setLightTheme() {
        currentTheme = "light"

        appBarColor = "#cccccc"
        backgroundColor = "#ffffff"

        bodyText = "#000000"
        moduleText = "#2D262E"
        inversedText = "#F0F0F0"

        gradientDark = "#bfbfbf"
        gradientMid = "#cccccc"
        gradientLight1 = "#B7B1B9"
        gradientLight2 = "#e7e2e9"
        gradientBorder = "#d9d9d9"

        moduleGradient1 = "#BCBCBC"
        moduleGradient2 = "#A3A3A3"
        moduleGradient3 = "#989898"
        moduleGradient4 = "#888888"
        moduleGradient5 = Qt.lighter("#7e7e7e",1)

        stopButtonWhite = "white"

    }

    function setDarkTheme() {
        currentTheme = "dark"

        appBarColor = "#2D262E"
        backgroundColor = "#4A4A4A"

        bodyText = "#F0f0f0"
        moduleText = "#F0f0f0"
        inversedText = "#2D262E"

        gradientDark = "#2D262E"
        gradientMid = "#2c2c2c"
        gradientLight1 = "#323033"
        gradientLight2 = "#454545"
        gradientBorder = "#8F8F8F"

        moduleGradient1 = "#6B6B6B"
        moduleGradient2 = "#595959"
        moduleGradient3 = "#545454"
        moduleGradient4 = "#454545"
        moduleGradient5 = "#7e7e7e"

        stopButtonWhite = "transparent"
    }

}
