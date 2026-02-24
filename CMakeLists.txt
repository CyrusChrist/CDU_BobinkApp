cmake_minimum_required(VERSION 3.16)
project(BobinkQtOpcUaAppTemplate LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# ── Qt setup (must come before BobinkQtOpcUa so AUTOMOC is enabled) ───────
find_package(Qt6 6.10.2 REQUIRED COMPONENTS Quick)
qt_standard_project_setup(REQUIRES 6.10.2)

# ── BobinkQtOpcUa ──────────────────────────────────────────────────────────
# Builds open62541 and QtOpcUa from submodules automatically on first
# configure. Subsequent configures skip the dep builds (delete
# build/deps/*-install/ to force a rebuild).
#
# Prerequisites: Qt 6.10.2+ with qt-cmake in PATH, OpenSSL dev headers,
# Ninja, and initialized submodules:
#   git submodule update --init --recursive
add_subdirectory(deps/BobinkQtOpcUa)

qt_add_executable(BobinkQtOpcUaAppTemplate main.cpp)
qt_add_qml_module(BobinkQtOpcUaAppTemplate URI BobinkQtOpcUaAppTemplate VERSION 1.0 QML_FILES Main.qml NodePage.qml)

# Executable goes to bin/ to avoid clashing with the QML module directory
set_target_properties(BobinkQtOpcUaAppTemplate PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")

# Link against BobinkQtOpcUaplugin (not BobinkQtOpcUa). The "plugin"
# target includes the QML type registration needed for `import Bobink`.
target_link_libraries(BobinkQtOpcUaAppTemplate PRIVATE Qt6::Quick BobinkQtOpcUaplugin)

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
target_compile_definitions(BobinkQtOpcUaAppTemplate PRIVATE
    QTOPCUA_PLUGIN_PATH="${QTOPCUA_INSTALL_DIR}/plugins")
