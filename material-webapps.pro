TEMPLATE = subdirs

deployment.files += modules/Material/WebApps
deployment.path = $$[QT_INSTALL_QML]/Material

INSTALLS += deployment
