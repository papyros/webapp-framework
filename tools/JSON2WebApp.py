#!/usr/bin/python

import json, sys

file = open(sys.argv[1], 'r')
data = json.load(file)
file.close()
qmlFile = open(data["title"] + ".qml", 'w')
qmlFile.write('import QtQuick 2.0\nimport Material.WebApps 0.1\n\nWebApp {\n\ttitle: "%s"\n\turl: "%s"\n\tloadingImage: Qt.resolvedUrl("%s")\n\n\ttheme: {\n\t\tprimaryDarkColor: "%s"\n\t}\n}' % (data["title"], data["url"], data["loadingImage"], data["color"]))
