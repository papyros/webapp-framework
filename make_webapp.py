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

    def build(self, path, force=False):
        path = os.path.expanduser(path)
        webapp_path = path + '/webapps/' + self.json['short_name']

        if os.path.exists('webapp.qml') and not force:
            print('webapp.qml already built. Use --force to override.')
        else:
            with open('webapp.qml', 'w') as file:
                file.write(self.webapp_file())

        if os.path.exists(self.json['short_name'] + '.desktop') and not force:
            print(self.json['short_name'] + '.desktop already built. Use --force to override.')
        else:
            with open(self.json['short_name'] + '.desktop', 'w') as file:
                file.write(self.desktop_file(webapp_path))

    def install(self, path):
        path = os.path.expanduser(path)
        webapp_path = path + '/webapps/' + self.json['short_name']

        if not os.path.exists(webapp_path):
            os.makedirs(webapp_path)

        shutil.copy(self.json['short_name'] + '.desktop', path + '/applications')
        shutil.copy('webapp.qml', webapp_path)
        shutil.copy(self.json['loading_image'], webapp_path)
        shutil.copy(self.json['icon'], webapp_path)

    def run(self):
        os.system('qmlscene webapp.qml')

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
    cmd = sys.argv[1]

    with open("webapp.json") as file:
        webapp = WebApp.from_file(file)

    if cmd == 'build':
        force = len(sys.argv) == 3 and sys.argv[2] == '--force'

        webapp.build('~/.local/share', force)
    if cmd == 'install':
        webapp.install('~/.local/share')
    if cmd == 'run':
        webapp.run()
