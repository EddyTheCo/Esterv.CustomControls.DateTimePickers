#include <QGuiApplication>
#include <QQmlApplicationEngine>

#if defined(FORCE_STYLE)
#include <QQuickStyle>
#endif

int main(int argc, char *argv[])
{
	QGuiApplication app(argc, argv);
#if defined(FORCE_STYLE)
	QQuickStyle::setStyle(FORCE_STYLE);
#endif

	QQmlApplicationEngine engine;

	engine.addImportPath("qrc:/esterVtech.com/imports");

    const QUrl url=QUrl("qrc:/esterVtech.com/imports/EdatepickerExample/qml/datepickerExample.qml");

	engine.load(url);

	return app.exec();
}

