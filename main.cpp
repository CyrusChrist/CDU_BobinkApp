/**
 * @file   main.cpp
 * @brief  Entry point for the Bobink demo application.
 */
#include <QDateTime>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QtQml/QQmlExtensionPlugin>
Q_IMPORT_QML_PLUGIN (BobinkPlugin)

/** @brief Custom log handler matching open62541 server log format. */
static void
logHandler (QtMsgType type, const QMessageLogContext &ctx, const QString &msg)
{
  // Color only the type/category tag.
  const char *color = "";
  const char *label = "debug";
  switch (type)
    {
    case QtDebugMsg:
      label = "debug";
      break;
    case QtInfoMsg:
      color = "\x1b[32m";
      label = "info";
      break;
    case QtWarningMsg:
      color = "\x1b[33m";
      label = "warning";
      break;
    case QtCriticalMsg:
      color = "\x1b[31m";
      label = "critical";
      break;
    case QtFatalMsg:
      color = "\x1b[1;31m";
      label = "fatal";
      break;
    }

  // Shorten "qt.opcua.plugins.open62541.sdk.client" → "client".
  QLatin1StringView cat (ctx.category ? ctx.category : "default");
  qsizetype dot = cat.lastIndexOf (QLatin1Char ('.'));
  if (dot >= 0)
    cat = cat.sliced (dot + 1);

  // "debug/client", "warning/network", etc. — padded to 20 chars.
  QByteArray tag
      = QByteArray (label) + '/' + QByteArray (cat.data (), cat.size ());

  // Format UTC offset as "(UTC+0100)" to match open62541 server logs.
  QDateTime now = QDateTime::currentDateTime ();
  qint32 offset = now.offsetFromUtc ();
  QChar sign = offset >= 0 ? u'+' : u'-';
  offset = qAbs (offset);
  QString ts = now.toString (u"yyyy-MM-dd HH:mm:ss.zzz")
               + QStringLiteral (" (UTC%1%2%3)")
                     .arg (sign)
                     .arg (offset / 3600, 2, 10, QLatin1Char ('0'))
                     .arg ((offset % 3600) / 60, 2, 10, QLatin1Char ('0'));

  fprintf (stderr, "[%s] %s%-20.*s\x1b[0m %s\n", qPrintable (ts), color,
           static_cast<int> (tag.size ()), tag.data (), qPrintable (msg));
}

int
main (int argc, char *argv[])
{
  // Load the locally-built OpcUa backend plugin (open62541).
  QCoreApplication::addLibraryPath (QStringLiteral (QTOPCUA_PLUGIN_PATH));

  qInstallMessageHandler (logHandler);

  QGuiApplication app (argc, argv);

  QQmlApplicationEngine engine;
  QObject::connect (
      &engine, &QQmlApplicationEngine::objectCreationFailed, &app,
      [] () { QCoreApplication::exit (1); }, Qt::QueuedConnection);

  engine.loadFromModule ("BobinkQtOpcUaAppTemplate", "Main");
  return app.exec ();
}
