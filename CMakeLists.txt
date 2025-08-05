cmake_minimum_required(VERSION 3.16)
project(Clipboard-History-Manager VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Widgets Core)
qt_standard_project_setup(REQUIRES 6.8)

set(CMAKE_AUTOMOC ON)

set(SOURCES
    main.cpp
    src/ClipboardManager.cpp
)

set(HEADERS
    inc/ClipboardManager.h
)

qt_add_executable(appClipboard-History-Manager
    ${SOURCES}
    ${HEADERS}
    resources.qrc
)

qt_add_qml_module(appClipboard-History-Manager
    URI Clipboard-History-Manager
    VERSION 1.0
    QML_FILES
        Main.qml
)

set_target_properties(appClipboard-History-Manager PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_include_directories(appClipboard-History-Manager PRIVATE inc)

target_link_libraries(appClipboard-History-Manager
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Widgets
)

include(GNUInstallDirs)
install(TARGETS appClipboard-History-Manager
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
