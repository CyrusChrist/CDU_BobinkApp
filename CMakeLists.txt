cmake_minimum_required(VERSION 3.16)
project(BobinkQtOpcUaHMIApp LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# ── Qt setup (must come before BobinkQtOpcUa so AUTOMOC is enabled) ───────
find_package(Qt6 6.10.2 REQUIRED COMPONENTS Quick QuickControls2)
qt_standard_project_setup(REQUIRES 6.10.2)

# ── QML tooling ────────────────────────────────────────────────────────────
# Generate .qmlls.ini for QML Language Server
set(QT_QML_GENERATE_QMLLS_INI
    ON
    CACHE BOOL "")

# ── BobinkQtOpcUa ──────────────────────────────────────────────────────────
# Builds open62541 and QtOpcUa from submodules automatically on first
# configure. Subsequent configures skip the dep builds (delete
# build/deps/*-install/ to force a rebuild).
#
# Prerequisites: Qt 6.10.2+ with qt-cmake in PATH, OpenSSL dev headers,
# Ninja, and initialized submodules:
#   git submodule update --init --recursive
add_subdirectory(deps/BobinkQtOpcUa)

# Ensure the qml/ import directory exists before qmlimportscanner runs
file(MAKE_DIRECTORY "${CMAKE_BINARY_DIR}/qml")

set_source_files_properties(Constants.qml
    PROPERTIES
        QT_QML_SINGLETON_TYPE true
)

qt_add_executable(BobinkQtOpcUaHMIApp main.cpp)
qt_add_qml_module(BobinkQtOpcUaHMIApp URI BobinkQtOpcUaHMIApp VERSION 1.0
    QML_FILES

              Demo.qml
              App.qml
              NodePage.qml
              MachineSelection.qml
              LoadingScreen.qml
              AppTheme.qml
              Constants.qml
              utils.js

              Pages/Home.qml
              Pages/Cantre.qml
              Pages/PreTraitement.qml
              Pages/Fours.qml
              Pages/IR.qml
              Pages/Impression.qml
              Pages/Bobinoir.qml
              Pages/AxisSettings.qml
              Pages/motorData.js
              Pages/Schema.qml
              Pages/System.qml
              Pages/JobHistory.qml
              Pages/JobList.qml
              Pages/WebEngine.qml
              Pages/Ventilation.qml
              Pages/ventilationData.js
              Pages/Test.qml
              Pages/Notification.qml

    RESOURCES

              Resources/Components/StyledFrame.qml
              Resources/Components/ManuelSwitch.qml
              Resources/Components/ModuleButton.qml
              Resources/Components/StatusIndicator.qml
              Resources/Components/StatusIndicatorTricolor.qml
              Resources/Components/SeparatingModuleItem.qml
              Resources/Components/NumericInput.qml
              Resources/Components/CustomPlayPause.qml
              Resources/Components/CustomOnOff.qml
              Resources/Components/CustomSwitch.qml
              Resources/Components/ScenarioButton.qml
              Resources/Components/ChainAsservissement.qml
              Resources/Components/CasseFilsArray.qml
              Resources/Components/OptionButton.qml
              Resources/Components/CustomCheckbox.qml
              Resources/Components/GaugeProgress.qml
              Resources/Components/TapisSwitch.qml
              Resources/Components/GaugeBar.qml
              Resources/Components/ConnexionPopup.qml
              Resources/Components/MenuFrame.qml
              Resources/Components/MenuButton.qml
              Resources/Components/NotificationPopup.qml
              Resources/Components/PowerButton.qml

              Resources/Images/BobinkLogo.svg
              Resources/Images/BobinkTitle.svg
              Resources/Images/Schema3D.svg
              Resources/Images/Link.svg
              Resources/Images/LinkBroken.svg
              Resources/Images/Check.svg
              Resources/Images/ButtonPause.svg
              Resources/Images/ButtonPlay.svg
              Resources/Images/Engrenage.svg
              Resources/Images/TapisDroitWhite.svg
              Resources/Images/TapisGreen.svg
              Resources/Images/TapisRed.svg
              Resources/Images/Camera.svg
              Resources/Images/IR_Fond.svg
              Resources/Images/IR_Off.svg
              Resources/Images/IR_On.svg
              Resources/Images/Egout.svg
              Resources/Images/ConnexionError.svg
              Resources/Images/Notification.svg
              Resources/Images/Info.svg
              Resources/Images/ButtonStopMain.svg
              Resources/Images/ButtonStopMainDown.svg
              Resources/Images/MENU_systeme.svg
              Resources/Images/MENU_home.svg
              Resources/Images/MENU_cantre.svg
              Resources/Images/MENU_factory.svg
              Resources/Images/MENU_four.svg
              Resources/Images/MENU_machine.svg
              Resources/Images/MENU_IR.svg
              Resources/Images/MENU_impression.svg
              Resources/Images/MENU_pretraitement.svg
              Resources/Images/MENU_bobinoir.svg
              Resources/Images/MENU_jobHistory.svg
              Resources/Images/MENU_jobList.svg
              Resources/Images/MENU_jobs.svg
              Resources/Images/MENU_axis.svg
              Resources/Images/MENU_schema.svg
              Resources/Images/UserAdmin.svg
              Resources/Images/UserIngenieur.svg
              Resources/Images/UserMaintenance.svg
              Resources/Images/UserOperateur.svg
              Resources/Images/PowerWhite.svg
              Resources/Images/WarningSign.svg

              IMPORT_PATH "${CMAKE_BINARY_DIR}/deps/BobinkQtOpcUa/qml"
)

# Executable goes to bin/ to avoid clashing with the QML module directory
set_target_properties(BobinkQtOpcUaHMIApp PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")

# Link against BobinkQtOpcUaplugin (not BobinkQtOpcUa). The "plugin"
# target includes the QML type registration needed for `import Bobink`.
target_link_libraries(BobinkQtOpcUaHMIApp PRIVATE Qt6::Quick Qt6::QuickControls2 BobinkQtOpcUaplugin)

# ── Runtime quirks ──────────────────────────────────────────────────────────
# BobinkQtOpcUa builds open62541 as a shared library. The QtOpcUa backend
# plugin (loaded at runtime via dlopen) needs to find it. These two lines
# make that work during development:

# 1. RPATH: embed the dep lib dirs so the dynamic linker finds libopen62541
#    and libQt6OpcUa at runtime without installing them system-wide.
set(CMAKE_BUILD_RPATH "${QTOPCUA_INSTALL_DIR}/lib"
                      "${OPEN62541_INSTALL_DIR}/lib")

# 2. Plugin path: Qt's plugin loader doesn't know about our locally-built
#    QtOpcUa backend. Pass the path as a compile definition and call
#    QCoreApplication::addLibraryPath(QTOPCUA_PLUGIN_PATH) in main.cpp
#    *before* creating the QGuiApplication.
target_compile_definitions(BobinkQtOpcUaHMIApp PRIVATE
    QTOPCUA_PLUGIN_PATH="${QTOPCUA_INSTALL_DIR}/plugins")
