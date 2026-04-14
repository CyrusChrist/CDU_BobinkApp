pragma Singleton

import QtQuick
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

    readonly property var stateNames: [
        "Undefined", "Clearing", "Stopped", "Starting", "Idle",
        "Suspended", "Execute", "Stopping", "Aborting", "Aborted",
        "Holding", "Held", "UnHolding", "Suspending", "UnSuspending",
        "Resetting", "Completing", "Completed"
    ]

    readonly property var emNames: [
        "Global", "Cantre", "Pré-Traitement", "Four 1", "Fours IR",
        "Impression", "Four 2", "Bobinoir", "Chauffe"
    ]

    property var cmNames: {
        var names = {}
        names[0] = ["System", "Maitre Fours"]
        names[1] = ["LGL"]
        names[2] = ["Plasma", "PreTraitement", "Purge"]
        names[3] = ["Maître Four1", "Camera", "Servo Rouleau", "Servo Dépose Fils", "Servo Tapis", "Casse Fils"]
        names[4] = ["Maître IR", "Capteur Tension", "Servo Rouleau", "Servo PreAlimenteur", "Verins", "Casse Fils"]
        names[5] = []
        names[6] = ["Maître Four2", "Camera", "Servo Rouleau", "Servo Dépose Fils", "Servo Tapis", "Casse Fils"]
        names[7] = ["Servo Bobinoir", "Servo Bobinage", "Servo Trancanage", "Capteur Vitesse", "Casse Fils"]
        names[8] = ["Ventillations", "Chauffe"]
        return names
    }

    property var cmImages: {
        var src = {}
        src[0] = ["WarningSign", "WarningSign"]
        src[1] = ["MENU_cantre"]
        src[2] = ["MENU_pretraitement", "MENU_pretraitement", "MENU_pretraitement"]
        src[3] = ["MENU_four", "Camera", "MENU_four", "MENU_four", "MENU_four", "MENU_four"]
        src[4] = ["MENU_IR", "MENU_IR", "MENU_IR", "MENU_IR", "MENU_IR", "MENU_IR"]
        src[5] = ["WarningSign"]
        src[6] = ["MENU_four", "Camera", "MENU_four", "MENU_four", "MENU_four", "MENU_four"]
        src[7] = ["MENU_bobinoir", "MENU_bobinoir", "MENU_bobinoir", "MENU_bobinoir", "MENU_bobinoir"]
        src[8] = ["MENU_four", "MENU_four"]
        return src
    }

    property int selectedEM: -1
    property int selectedCM: -1

    // Masques d'inactivité (pour configuration)
    property int emInactiveMask: 0xFFFF
    property var cmInactiveMasks: [
        0xFFFE, 0xFFFE, 0xFFFF, 0xFFC0,
        0xFF80, 0xFFFF, 0xFFC0, 0xFFE0,
        0xFFFC, 0xFFFF, 0xFFFF, 0xFFFF,
        0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF
    ]

    // Sauvegarde des masques d'inactivé des cm lors du mode Manuel
    property var cmInactiveMasksManuelBuffer: [
        0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF,
        0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF,
        0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF,
        0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF
    ]

    // Status actifs (lecture depuis PLC)
    property int emsActive: 0x0000
    property var cmsActive: [
        0x0000, 0x0000, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000
    ]

    // Status NotDone (lecture depuis PLC)
    property int emsNotDone: 0x0000
    property var cmsNotDone: [
        0x0000, 0x0000, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000
    ]

}
