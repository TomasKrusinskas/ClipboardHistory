import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

Window {
    id: mainWindow
    width: 600
    height: 500
    minimumWidth: 500
    minimumHeight: 300
    visible: true
    title: qsTr("Clipboard History Manager")

    flags: Qt.Window | Qt.WindowStaysOnTopHint

    Connections {
        target: clipboardManager
        function onClipboardHistoryChanged() {
        }
    }

    Component.onCompleted: {
        clipboardManager.clipboardHistoryChanged.connect(function() {
            if (!mainWindow.visible) {
                mainWindow.show()
                mainWindow.raise()
                mainWindow.requestActivate()
            }
        })
    }

    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_Escape) {
            mainWindow.hide()
            event.accepted = true
        } else if (event.key === Qt.Key_Q && (event.modifiers & Qt.ControlModifier)) {
            clipboardManager.quitApplication()
            event.accepted = true
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#f5f5f5"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            Rectangle {
                Layout.fillWidth: true
                height: 50
                color: "#2196F3"
                radius: 5

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10

                    Text {
                        text: "📋 Clipboard History Manager"
                        color: "white"
                        font.pixelSize: 18
                        font.bold: true
                    }

                    Item { Layout.fillWidth: true }

                    RowLayout {
                        spacing: 5
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredHeight: 30

                        Button {
                            text: "🗕"
                            width: 30
                            height: 30
                            background: Rectangle {
                                color: parent.pressed ? "#1976D2" : parent.hovered ? "#1E88E5" : "transparent"
                                radius: 3
                            }
                            contentItem: Text {
                                text: parent.text
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: 14
                            }
                            onClicked: mainWindow.visibility = Window.Minimized
                            ToolTip.visible: hovered
                            ToolTip.text: "Minimize"
                        }

                        Button {
                            text: mainWindow.visibility === Window.FullScreen ? "⛶" : "⛶"
                            width: 30
                            height: 30
                            background: Rectangle {
                                color: parent.pressed ? "#1976D2" : parent.hovered ? "#1E88E5" : "transparent"
                                radius: 3
                            }
                            contentItem: Text {
                                text: parent.text
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: 14
                            }
                            onClicked: {
                                if (mainWindow.visibility === Window.FullScreen) {
                                    mainWindow.visibility = Window.Windowed
                                } else {
                                    mainWindow.visibility = Window.FullScreen
                                }
                            }
                            ToolTip.visible: hovered
                            ToolTip.text: mainWindow.visibility === Window.FullScreen ? "Exit Fullscreen" : "Fullscreen"
                        }

                        Button {
                            text: "✕"
                            width: 30
                            height: 30
                            background: Rectangle {
                                color: parent.pressed ? "#D32F2F" : parent.hovered ? "#F44336" : "transparent"
                                radius: 3
                            }
                            contentItem: Text {
                                text: parent.text
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: 14
                            }
                            onClicked: {
                                console.log("Quit button clicked")
                                clipboardManager.quitApplication()
                            }
                            ToolTip.visible: hovered
                            ToolTip.text: "Close Application"
                        }
                    }

                    Button {
                        text: "Clear All"
                        background: Rectangle {
                            color: parent.pressed ? "#1976D2" : parent.hovered ? "#1E88E5" : "#2196F3"
                            radius: 3
                            border.color: "white"
                            border.width: 1
                        }
                        contentItem: Text {
                            text: parent.text
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                        }
                        onClicked: {
                            clearDialog.open()
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 50
                color: "white"
                radius: 8
                border.color: "#ddd"
                border.width: 1

                RowLayout {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 15
                    anchors.rightMargin: 15
                    spacing: 15

                    Text {
                        text: "Max History Size:"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        color: "#444"
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Rectangle {
                        width: 120
                        height: 36
                        color: "#f8f9fa"
                        radius: 6
                        border.color: "#dee2e6"
                        border.width: 1
                        Layout.alignment: Qt.AlignVCenter

                        RowLayout {
                            anchors.fill: parent
                            spacing: 0

                            Button {
                                Layout.preferredWidth: 36
                                Layout.preferredHeight: 34
                                text: "−"
                                background: Rectangle {
                                    color: parent.enabled ? (parent.pressed ? "#e9ecef" : parent.hovered ? "#f1f3f4" : "transparent") : "#f8f9fa"
                                    radius: 5
                                    border.color: "transparent"
                                }
                                contentItem: Text {
                                    text: parent.text
                                    color: parent.enabled ? "#495057" : "#adb5bd"
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    font.pixelSize: 16
                                    font.weight: Font.Bold
                                }
                                onClicked: {
                                    if (clipboardManager.maxHistorySize > 10) {
                                        clipboardManager.maxHistorySize = clipboardManager.maxHistorySize - 1
                                    }
                                }
                                enabled: clipboardManager.maxHistorySize > 10
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: "white"
                                border.color: "#dee2e6"
                                border.width: 1

                                Text {
                                    anchors.centerIn: parent
                                    text: clipboardManager.maxHistorySize
                                    font.pixelSize: 14
                                    font.weight: Font.Medium
                                    color: "#212529"
                                }
                            }

                            Button {
                                Layout.preferredWidth: 36
                                Layout.preferredHeight: 34
                                text: "+"
                                background: Rectangle {
                                    color: parent.enabled ? (parent.pressed ? "#e9ecef" : parent.hovered ? "#f1f3f4" : "transparent") : "#f8f9fa"
                                    radius: 5
                                    border.color: "transparent"
                                }
                                contentItem: Text {
                                    text: parent.text
                                    color: parent.enabled ? "#495057" : "#adb5bd"
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    font.pixelSize: 14
                                    font.weight: Font.Bold
                                }
                                onClicked: {
                                    if (clipboardManager.maxHistorySize < 200) {
                                        clipboardManager.maxHistorySize = clipboardManager.maxHistorySize + 1
                                    }
                                }
                                enabled: clipboardManager.maxHistorySize < 200
                            }
                        }
                    }

                    Item { Layout.fillWidth: true }

                    Rectangle {
                        width: 120
                        height: 28
                        color: "#e3f2fd"
                        radius: 14
                        border.color: "#bbdefb"
                        border.width: 1
                        Layout.alignment: Qt.AlignVCenter

                        Text {
                            anchors.centerIn: parent
                            text: "History: " + clipboardManager.clipboardHistory.length + " items"
                            font.pixelSize: 12
                            font.weight: Font.Medium
                            color: "#1976d2"
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: pinnedItemsList.count > 0 ? Math.min(120, pinnedItemsList.contentHeight + 40) : 0
                visible: pinnedItemsList.count > 0
                color: "white"
                radius: 5
                border.color: "#e0e0e0"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10

                    Text {
                        text: "📌 Pinned Items"
                        font.pixelSize: 14
                        font.bold: true
                        color: "#2196F3"
                    }

                    ListView {
                        id: pinnedItemsList
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        model: clipboardManager.pinnedItems
                        spacing: 5
                        clip: true

                        delegate: Rectangle {
                            width: pinnedItemsList.width
                            height: Math.max(40, textContent.height + 20)
                            color: "#fff3e0"
                            radius: 3
                            border.color: "#ffb74d"

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 8

                                Text {
                                    id: textContent
                                    text: modelData
                                    Layout.fillWidth: true
                                    wrapMode: Text.Wrap
                                    elide: Text.ElideRight
                                    maximumLineCount: 2
                                    font.pixelSize: 12
                                }

                                Button {
                                    text: "📋"
                                    width: 35
                                    height: 30
                                    background: Rectangle {
                                        color: parent.pressed ? "#e0e0e0" : parent.hovered ? "#f0f0f0" : "white"
                                        radius: 3
                                        border.color: "#ccc"
                                    }
                                    onClicked: {
                                        console.log("Copy button clicked (pinned):", modelData)
                                        clipboardManager.copyToClipboard(modelData)
                                    }
                                    ToolTip.visible: hovered
                                    ToolTip.text: "Copy to clipboard"
                                }

                                Button {
                                    text: "📌"
                                    width: 35
                                    height: 30
                                    background: Rectangle {
                                        color: parent.pressed ? "#e0e0e0" : parent.hovered ? "#f0f0f0" : "white"
                                        radius: 3
                                        border.color: "#ccc"
                                    }
                                    onClicked: {
                                        console.log("Unpin button clicked (pinned):", modelData)
                                        clipboardManager.unpinItem(modelData)
                                    }
                                    ToolTip.visible: hovered
                                    ToolTip.text: "Unpin item"
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                z: -1  // Put behind buttons
                                onDoubleClicked: {
                                    console.log("Double-clicked pinned item:", modelData)
                                    clipboardManager.copyToClipboard(modelData)
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "white"
                radius: 5
                border.color: "#e0e0e0"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10

                    Text {
                        text: "📋 Clipboard History"
                        font.pixelSize: 14
                        font.bold: true
                        color: "#2196F3"
                    }

                    ListView {
                        id: historyList
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        model: clipboardManager.clipboardHistory
                        spacing: 2
                        clip: true

                        delegate: Rectangle {
                            width: historyList.width
                            height: Math.max(50, historyTextContent.height + 20)
                            color: index % 2 === 0 ? "#fafafa" : "white"
                            radius: 3

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 8

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 2

                                    Text {
                                        id: historyTextContent
                                        text: modelData
                                        Layout.fillWidth: true
                                        wrapMode: Text.Wrap
                                        elide: Text.ElideRight
                                        maximumLineCount: 3
                                        font.pixelSize: 12
                                    }

                                    Text {
                                        text: "Double-click to copy • " + (clipboardManager.pinnedItems.indexOf(modelData) >= 0 ? "📌 Pinned" : "Click 📌 to pin")
                                        font.pixelSize: 10
                                        color: "#999"
                                    }
                                }

                                Button {
                                    text: "📋"
                                    width: 35
                                    height: 30
                                    background: Rectangle {
                                        color: parent.pressed ? "#e0e0e0" : parent.hovered ? "#f0f0f0" : "white"
                                        radius: 3
                                        border.color: "#ccc"
                                    }
                                    onClicked: {
                                        console.log("Copy button clicked (history):", modelData)
                                        clipboardManager.copyToClipboard(modelData)
                                    }
                                    ToolTip.visible: hovered
                                    ToolTip.text: "Copy to clipboard"
                                }

                                Button {
                                    text: clipboardManager.pinnedItems.indexOf(modelData) >= 0 ? "📌" : "📍"
                                    width: 35
                                    height: 30
                                    background: Rectangle {
                                        color: parent.pressed ? "#e0e0e0" : parent.hovered ? "#f0f0f0" : "white"
                                        radius: 3
                                        border.color: "#ccc"
                                    }
                                    onClicked: {
                                        console.log("Pin/Unpin button clicked:", modelData)
                                        if (clipboardManager.pinnedItems.indexOf(modelData) >= 0) {
                                            console.log("Unpinning item")
                                            clipboardManager.unpinItem(modelData)
                                        } else {
                                            console.log("Pinning item")
                                            clipboardManager.pinItem(modelData)
                                        }
                                    }
                                    ToolTip.visible: hovered
                                    ToolTip.text: clipboardManager.pinnedItems.indexOf(modelData) >= 0 ? "Unpin item" : "Pin item"
                                }

                                Button {
                                    text: "🗑️"
                                    width: 35
                                    height: 30
                                    background: Rectangle {
                                        color: parent.pressed ? "#ffcdd2" : parent.hovered ? "#ffebee" : "white"
                                        radius: 3
                                        border.color: "#ccc"
                                    }
                                    onClicked: {
                                        console.log("Remove item clicked:", modelData)
                                        clipboardManager.removeItem(modelData)
                                    }
                                    ToolTip.visible: hovered
                                    ToolTip.text: "Remove item"
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                z: -1  // Put behind buttons
                                onDoubleClicked: {
                                    console.log("Double-clicked history item:", modelData)
                                    clipboardManager.copyToClipboard(modelData)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Dialog {
        id: clearDialog
        title: "Clear History"
        modal: true
        anchors.centerIn: parent
        width: 300
        height: 150

        contentItem: Rectangle {
            color: "white"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20

                Text {
                    text: "Are you sure you want to clear all clipboard history? This action cannot be undone."
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                }

                RowLayout {
                    Layout.alignment: Qt.AlignRight
                    spacing: 10

                    Button {
                        text: "Cancel"
                        onClicked: clearDialog.close()
                    }

                    Button {
                        text: "Clear All"
                        background: Rectangle {
                            color: parent.pressed ? "#D32F2F" : parent.hovered ? "#F44336" : "#FF5722"
                            radius: 3
                        }
                        contentItem: Text {
                            text: parent.text
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        onClicked: {
                            console.log("Clearing history...")
                            clipboardManager.clearHistory()
                            clearDialog.close()
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 25
        color: "#e0e0e0"

        Text {
            anchors.centerIn: parent
            text: "Running in system tray • Double-click items to copy • Use ✕ to close application • Use tray icon to show"
            font.pixelSize: 10
            color: "#666"
        }
    }
}
