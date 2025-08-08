# Clipboard History Manager

A Qt Quick application that keeps track of clipboard history and allows you to easily access and manage copied items.

## Features

- **Automatic Clipboard Monitoring**: Automatically captures text copied to clipboard
- **History Management**: Keeps the last N clips in a list (configurable, default: 50)
- **Double-click to Copy**: Double-click any item to copy it back to clipboard
- **Pin Favorites**: Pin important items so they stay at the top and don't get removed
- **Clear History**: Clear all clipboard history with confirmation dialog
- **System Tray**: Runs in system tray with context menu
- **Persistent Storage**: Saves clipboard history and pinned items between sessions
- **Modern UI**: Clean, modern interface with Material Design-inspired styling

## Building the Application

### Prerequisites
- Qt 6.8 or later
- CMake 3.16 or later
- C++ compiler with C++17 support

### Build Instructions

1. **Clone or download the project**
   ```bash
   git clone <repository-url>
   cd Clipboard-History-Manager
   ```

2. **Create build directory**
   ```bash
   mkdir build
   cd build
   ```

3. **Configure with CMake**
   ```bash
   cmake ..
   ```

4. **Build the application**
   ```bash
   cmake --build .
   ```

5. **Run the application**
   ```bash
   ./appClipboard-History-Manager
   ```

## Usage

### Main Window
- The application window shows your clipboard history in a list
- Each item displays the copied text with action buttons
- Use the spin box to adjust maximum history size (10-200 items)

### Actions
- ** Copy Button**: Click to copy item to clipboard
- ** Pin Button**: Click to pin/unpin an item (pinned items stay at top)
- ** Delete Button**: Remove individual items from history
- **Clear All**: Remove all items from history (with confirmation)

### System Tray
- The application runs in the system tray
- Right-click the tray icon for options:
  - **Show**: Show/hide the main window
  - **Quit**: Exit the application

### Keyboard Shortcuts
- **Double-click**: Copy item to clipboard
- **Window stays on top**: Easy access while working

## Features in Detail

### Clipboard Monitoring
- Automatically detects when you copy text to clipboard
- Adds new items to the top of the history list
- Prevents duplicate consecutive items

### Pinned Items
- Pinned items appear in a separate section at the top
- Pinned items have a different background color (orange)
- Pinned items persist even when history is cleared
- Use the pin button to pin/unpin items

### History Management
- Configurable maximum history size (10-200 items)
- Older items are automatically removed when limit is reached
- History is saved between application sessions
- Individual items can be removed with the delete button

### Data Persistence
- Clipboard history and pinned items are saved to JSON file
- Data is stored in application data directory
- Settings are automatically loaded on startup

## File Structure

```
Clipboard-History-Manager/
├── main.cpp              # Main application logic and ClipboardManager class
├── Main.qml             # QML user interface
├── CMakeLists.txt       # CMake build configuration
├── resources.qrc        # Qt resource file
├── icon.svg            # Application icon
└── README.md           # This file
```

## Technical Details

### Qt Components Used
- **QClipboard**: For clipboard monitoring and manipulation
- **QSystemTrayIcon**: For system tray functionality
- **QListWidget/QTableView**: Implemented as ListView in QML
- **QJsonDocument**: For data persistence
- **QStandardPaths**: For application data storage

### Architecture
- **C++ Backend**: ClipboardManager class handles all clipboard operations
- **QML Frontend**: Modern, responsive user interface
- **Signal/Slot**: Communication between C++ and QML
- **JSON Storage**: Persistent data storage

## Customization

### Changing History Size
- Use the spin box in the settings row
- Range: 10-200 items
- Changes are applied immediately

### Styling
- The application uses a modern, flat design
- Colors can be modified in the QML file
- Icons use Unicode emoji for cross-platform compatibility

## Troubleshooting

### Build Issues
- Ensure Qt 6.8+ is installed and properly configured
- Check that all required Qt modules are available
- Verify CMake version is 3.16 or later

### Runtime Issues
- Application requires system tray support
- Clipboard monitoring works on all supported platforms
- Data is saved in user's application data directory
- This project is provided as-is for educational and personal use.
