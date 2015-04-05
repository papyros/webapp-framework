#!/usr/bin/python

import json, sys, os, os.path, shutil

def block(string):
    if string[0] != '\n':
        return

    index = 0
    while string[index] == '\n':
        index += 1

    count = 0
    while string[index] == ' ':
        count += 1
        index += 1

    return string.replace('\n' + (' ' * count), '\n')[1:]

class WebApp(object):
    def __init__(self, json):
        self.json = json

    def from_file(file):
        return WebApp(json.load(file))

    def install(self, path):
        path = os.path.expanduser(path)
        webapp_path = path + '/webapps/' + self.json['short_name']

        if not os.path.exists(webapp_path):
            os.makedirs(webapp_path)

        with open(webapp_path + '/webapp.qml', 'w') as file:
            file.write(self.webapp_file())

        with open(path + '/applications/' + self.json['short_name'] + '.desktop', 'w') as file:
            file.write(self.desktop_file(webapp_path))

        shutil.copy(self.json['loading_image'], webapp_path)
        shutil.copy(self.json['icon'], webapp_path)

    def desktop_file(self, path):
        qml_path = path + '/webapp.qml'
        icon_path = path + '/' + self.json['icon']

        return block('''
        #!/usr/bin/env xdg-open
        [Desktop Entry]
        Version=1.0
        Name={name}
        Comment={description}
        Exec=qmlscene {qml_path}
        Icon={icon_path}
        Terminal=False
        Type=Application
        ''').format(qml_path=qml_path, icon_path=icon_path, **self.json)

    def webapp_file(self):
        return block('''
        import QtQuick 2.0
        import Material.WebApps 0.1

        WebApp {{
            title: "{name}"
            url: "{url}"
            loadingImage: Qt.resolvedUrl("{loading_image}")

            theme {{
                primaryColor: "{primary_color}"
                primaryDarkColor: "{primary_dark_color}"
            }}
        }}
        ''').format(**self.json)


if __name__=='__main__':
    with open(sys.argv[1]) as file:
        webapp = WebApp.from_file(file)
        webapp.install('~/.local/share')
