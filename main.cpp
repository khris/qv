#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockLandscape);
    viewer.setMainQmlFile(QLatin1String("qrc:/qml/qvapp/qv.qml"));
    viewer.showExpanded();

    return app.exec();
}
