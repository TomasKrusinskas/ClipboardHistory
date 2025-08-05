#pragma once

#include <QObject>
#include <QStringList>
#include <QClipboard>
#include <QSystemTrayIcon>
#include <QMenu>
#include <QAction>
#include <QTimer>
#include <QString>

class ClipboardManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList clipboardHistory READ clipboardHistory NOTIFY clipboardHistoryChanged)
    Q_PROPERTY(int maxHistorySize READ maxHistorySize WRITE setMaxHistorySize NOTIFY maxHistorySizeChanged)
    Q_PROPERTY(QStringList pinnedItems READ pinnedItems NOTIFY pinnedItemsChanged)

public:
    explicit ClipboardManager(QObject *parent = nullptr);

    QStringList clipboardHistory() const { return m_clipboardHistory; }
    int maxHistorySize() const { return m_maxHistorySize; }
    void setMaxHistorySize(int size);
    QStringList pinnedItems() const { return m_pinnedItems; }

    Q_INVOKABLE void copyToClipboard(const QString &text);
    Q_INVOKABLE void clearHistory();
    Q_INVOKABLE void pinItem(const QString &text);
    Q_INVOKABLE void unpinItem(const QString &text);
    Q_INVOKABLE void removeItem(const QString &text);
    Q_INVOKABLE void saveSettings();
    Q_INVOKABLE void loadSettings();
    Q_INVOKABLE void quitApplication();

signals:
    void clipboardHistoryChanged();
    void maxHistorySizeChanged();
    void pinnedItemsChanged();

private slots:
    void onClipboardChanged();
    void showMainWindow();

private:
    void addToHistory(const QString &text);
    void saveToFile();
    void loadFromFile();

    QStringList m_clipboardHistory;
    QStringList m_pinnedItems;
    int m_maxHistorySize;
    QClipboard *m_clipboard;
    QSystemTrayIcon *m_trayIcon;
    QMenu *m_trayMenu;
    QTimer *m_clipboardTimer;
    QString m_settingsFile;
    bool m_isLoading;
};
