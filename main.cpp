#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockLandscape);
    viewer.setMainQmlFile(QLatin1String("qrc:/qml/qvapp/qv.qml"));
    viewer.setSource(QUrl(QLatin1String("qrc:/qml/qvapp/qv.qml")));

#ifdef Q_OS_SYMBIAN
    viewer.setResizeMode(QDeclarativeView::SizeRootObjectToView);
    viewer.showFullScreen();
#elif defined(Q_WS_MAEMO_5)
    viewer.setResizeMode(QDeclarativeView::SizeRootObjectToView);
    viewer.showMaximized();
#elif defined(Q_OS_ANDROID)
    viewer.setResizeMode(QDeclarativeView::SizeRootObjectToView);
    viewer.showFullScreen();
#else
    Qt::WindowFlags flags = Qt::MSWindowsFixedSizeDialogHint
            | Qt::CustomizeWindowHint
            | Qt::WindowCloseButtonHint
            | Qt::WindowMinimizeButtonHint;
    viewer.setWindowFlags(flags);
    viewer.setResizeMode(QDeclarativeView::SizeViewToRootObject);
    viewer.show();
#endif

    return app.exec();
}
