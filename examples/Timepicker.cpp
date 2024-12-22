#include <QGuiApplication>
#include <QQmlApplicationEngine>

#if defined(FORCE_STYLE)
#include <QQuickStyle>
#endif
int main(int argc, char *argv[]) {
  QGuiApplication app(argc, argv);

#if defined(FORCE_STYLE)
  QQuickStyle::setStyle(FORCE_STYLE);
#endif
  QQmlApplicationEngine engine;

  engine.addImportPath("qrc:/esterVtech.com/imports");

  engine.loadFromModule("ExamplesTimepicker", "Timepicker");

  return app.exec();
}
