# Add more folders to ship with the application, here
qvapp.source = qml/qvapp
qvapp.target = qml
DEPLOYMENTFOLDERS = qvapp

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

symbian:TARGET.UID3 = 0xE34AAEDC

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
# symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
# symbian:TARGET.CAPABILITY += NetworkServices

# Define QMLJSDEBUGGER to allow debugging of QML in debug builds
# (This might significantly increase build time)
# DEFINES += QMLJSDEBUGGER

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

android {
    OTHER_FILES += \
        android/src/eu/licentia/necessitas/industrius/QtSurface.java \
        android/src/eu/licentia/necessitas/industrius/QtApplication.java \
        android/src/eu/licentia/necessitas/industrius/QtActivity.java \
        android/src/eu/licentia/necessitas/ministro/IMinistro.aidl \
        android/src/eu/licentia/necessitas/ministro/IMinistroCallback.aidl \
        android/res/drawable-mdpi/icon.png \
        android/res/drawable-ldpi/icon.png \
        android/res/drawable-hdpi/icon.png \
        android/res/values/strings.xml \
        android/res/values/libs.xml \
        android/AndroidManifest.xml
}

RESOURCES += \
    res.qrc
