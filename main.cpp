#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"
#include <QLibraryInfo>
#include <QDebug>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    qDebug() << QLibraryInfo::location(QLibraryInfo::ImportsPath);

    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/qvapp/qv.qml"));
    viewer.showExpanded();

    return app.exec();
}
