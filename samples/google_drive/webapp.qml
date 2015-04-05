import QtQuick 2.0
import Material 0.1
import Material.WebApps 0.1

WebApp {
    title: "Google Drive"
    url: "https://drive.google.com"
    loadingImage: Qt.resolvedUrl("drive.png")

    width: units.dp(1010)
    height: units.dp(650)

    showAppName: true

    theme {
        primaryColor: "#4285F4"
        primaryDarkColor: "#345ecc"
    }
}
