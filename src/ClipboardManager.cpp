#include "ClipboardManager.h"
#include <QApplication>
#include <QStandardPaths>
#include <QDir>
#include <QSettings>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QFile>
#include <QIODevice>

ClipboardManager::ClipboardManager(QObject *parent)
    : QObject(parent)
    , m_maxHistorySize(50)
    , m_clipboard(QApplication::clipboard())
    , m_trayIcon(new QSystemTrayIcon(this))
    , m_trayMenu(new QMenu())
    , m_clipboardTimer(new QTimer(this))
    , m_isLoading(false)
{
    m_settingsFile = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/clipboard_history.json";

    QDir().mkpath(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));

    connect(m_clipboard, &QClipboard::dataChanged, this, &ClipboardManager::onClipboardChanged);

    if (QSystemTrayIcon::isSystemTrayAvailable()) {
        m_trayIcon->setIcon(QIcon(":/icon.svg"));
        m_trayIcon->setToolTip("Clipboard History Manager");

        QAction *showAction = new QAction("Show", this);
        QAction *quitAction = new QAction("Quit", this);
        
        connect(showAction, &QAction::triggered, this, &ClipboardManager::showMainWindow);
        connect(quitAction, &QAction::triggered, this, &ClipboardManager::quitApplication);
        
        m_trayMenu->addAction(showAction);
        m_trayMenu->addSeparator();
        m_trayMenu->addAction(quitAction);
        
        m_trayIcon->setContextMenu(m_trayMenu);
        m_trayIcon->show();
    } else {
        m_trayIcon->hide();
    }

    loadSettings();
}

void ClipboardManager::setMaxHistorySize(int size)
{
    if (m_maxHistorySize != size) {
        m_maxHistorySize = size;
        emit maxHistorySizeChanged();

        while (m_clipboardHistory.size() > m_maxHistorySize) {
            m_clipboardHistory.removeLast();
        }
        emit clipboardHistoryChanged();
    }
}

void ClipboardManager::copyToClipboard(const QString &text)
{
    m_clipboard->setText(text);
}

void ClipboardManager::clearHistory()
{
    m_clipboardHistory.clear();
    emit clipboardHistoryChanged();
    saveToFile();
}

void ClipboardManager::pinItem(const QString &text)
{
    if (!m_pinnedItems.contains(text)) {
        m_pinnedItems.append(text);
        emit pinnedItemsChanged();
        saveToFile();
    }
}

void ClipboardManager::unpinItem(const QString &text)
{
    if (m_pinnedItems.removeOne(text)) {
        emit pinnedItemsChanged();
        saveToFile();
    }
}

void ClipboardManager::removeItem(const QString &text)
{
    if (m_clipboardHistory.removeOne(text)) {
        emit clipboardHistoryChanged();
        saveToFile();
    }
}

void ClipboardManager::onClipboardChanged()
{
    QString text = m_clipboard->text();
    if (!text.isEmpty() && !m_isLoading) {
        addToHistory(text);
    }
}

void ClipboardManager::addToHistory(const QString &text)
{
    if (!m_clipboardHistory.isEmpty() && m_clipboardHistory.first() == text) {
        return;
    }

    m_clipboardHistory.removeOne(text);

    m_clipboardHistory.prepend(text);

    while (m_clipboardHistory.size() > m_maxHistorySize) {
        m_clipboardHistory.removeLast();
    }
    
    emit clipboardHistoryChanged();
    saveToFile();
}

void ClipboardManager::showMainWindow()
{
    emit clipboardHistoryChanged();
}

void ClipboardManager::quitApplication()
{
    saveSettings();
    QApplication::quit();
}

void ClipboardManager::saveSettings()
{
    saveToFile();
}

void ClipboardManager::loadSettings()
{
    loadFromFile();
}

void ClipboardManager::saveToFile()
{
    QJsonObject root;
    QJsonArray historyArray;
    QJsonArray pinnedArray;
    
    for (const QString &item : m_clipboardHistory) {
        historyArray.append(item);
    }
    
    for (const QString &item : m_pinnedItems) {
        pinnedArray.append(item);
    }
    
    root["history"] = historyArray;
    root["pinned"] = pinnedArray;
    root["maxHistorySize"] = m_maxHistorySize;
    
    QJsonDocument doc(root);
    QFile file(m_settingsFile);
    if (file.open(QIODevice::WriteOnly)) {
        file.write(doc.toJson());
    }
}

void ClipboardManager::loadFromFile()
{
    m_isLoading = true;
    
    QFile file(m_settingsFile);
    if (file.open(QIODevice::ReadOnly)) {
        QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
        QJsonObject root = doc.object();
        
        m_clipboardHistory.clear();
        m_pinnedItems.clear();
        
        if (root.contains("history")) {
            QJsonArray historyArray = root["history"].toArray();
            for (const QJsonValue &value : historyArray) {
                m_clipboardHistory.append(value.toString());
            }
        }
        
        if (root.contains("pinned")) {
            QJsonArray pinnedArray = root["pinned"].toArray();
            for (const QJsonValue &value : pinnedArray) {
                m_pinnedItems.append(value.toString());
            }
        }
        
        if (root.contains("maxHistorySize")) {
            m_maxHistorySize = root["maxHistorySize"].toInt();
        }
        
        emit clipboardHistoryChanged();
        emit pinnedItemsChanged();
        emit maxHistorySizeChanged();
    }
    
    m_isLoading = false;
} 
