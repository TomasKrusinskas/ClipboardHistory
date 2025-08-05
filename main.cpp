#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "ClipboardManager.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setApplicationName("Clipboard History Manager");
    app.setApplicationVersion("1.0");

    QQmlApplicationEngine engine;

    ClipboardManager *clipboardManager = new ClipboardManager();
    engine.rootContext()->setContextProperty("clipboardManager", clipboardManager);
    
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("Clipboard-History-Manager", "Main");

    return app.exec();
}
