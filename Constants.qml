pragma Singleton

import QtQuick
// import QtQuick.Studio.Application
import QtQuick.Controls

QtObject {
    id: constants
    readonly property int width: 1920
    readonly property int height: 1080

    property bool fullScreen: false
    property string version: "Alpha.0.6"

    readonly property int spacing: 10 * scaleFactor

    readonly property real uiScale: {
        const w = window ? window.width  : Screen.width
        const h = window ? window.height : Screen.height
        return Math.min(w/width, h/height)
    }

    // Setting this var on App Component.onCompleted
    property var window

    // According of scaling OS + window size
    readonly property real _dpi: window && window.screen
                                 ? window.screen.logicalPixelDensity * 25.4
                                 : Screen.logicalPixelDensity * 25.4

    readonly property real dpScale: _dpi / 96 // (96 : base dpi)

    function dp(x) { return x * dpScale }
    function sp(x) { return Math.round(x * uiScale) }

    property string relativeFontDirectory: "Font"

    /* Edit this comment to add your custom font */
    readonly property font font: Qt.font({
                                             "family": Qt.application.font.family,
                                             "pixelSize": Qt.application.font.pixelSize
                                         })
    readonly property font largeFont: Qt.font({
                                                  "family": Qt.application.font.family,
                                                  "pixelSize": Qt.application.font.pixelSize * 1.6
                                              })

    readonly property color backgroundColor: "#EAEAEA"

    // property StudioApplication application: StudioApplication {
    //     fontPath: Qt.resolvedUrl(
    //                 constants.relativeFontDirectory)
    // }

    property real scaleFactor: Screen.width / 1920
    function refreshScaleFactor(){
        console.log("Scale Factor is freshing")
        constants.scaleFactor = Screen.width / 1920
    }

    function font(px) { return px * scaleFactor }

    function fitTextSize(textString, font, maxWidth, maxHeight,
                         maxFontSize, minFontSize,
                         widthRatio, heightRatio) {
        // Valeurs par défaut si non fournies
        widthRatio = widthRatio || 0.85
        heightRatio = heightRatio || 0.9

        // Crée un FontMetrics temporaire
        var fm = Qt.createQmlObject('import QtQuick 2.15; FontMetrics {}',
                                    Qt.application, "TempFM")
        fm.font = font

        var size = maxFontSize
        while (size > minFontSize) {
            fm.font.pixelSize = size

            // Découpe en lignes si le texte contient des retours à la ligne
            var lines = textString.split("\n")
            var maxLineWidth = 0
            var totalHeight = 0

            for (var i = 0; i < lines.length; i++) {
                var rect = fm.boundingRect(lines[i])
                maxLineWidth = Math.max(maxLineWidth, rect.width)
                totalHeight += rect.height
            }

            // Vérifie largeur ET hauteur (avec marges)
            if (maxLineWidth <= maxWidth * widthRatio &&
                totalHeight <= maxHeight * heightRatio) {
                break
            }
            size -= 1
        }
        return size
    }

    // property real asservBob_offset: -2
    // property real asservBob_erreur: 1.5
    // property real asservBob_gain: 0.2
}
