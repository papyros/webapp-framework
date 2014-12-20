import QtQuick 2.0
import Material 0.1
import QtWebEngine 1.0

ApplicationWindow {
    id: webapp

    property url url
    property alias loadingImage: loadingImage.source

    initialPage: page

    theme.backgroundColor: "white"

    Page {
        id: page

        actionBar.hidden: true

        WebEngineView {
            id: webView

            url: webapp.url
            anchors.fill: parent
            visible: false

            onLoadingChanged: {
                print("Loading!", loading)
                if (!loading) {
                    loadingImage.opacity = 0
                    webView.visible = true
                }
            }
        }

        Image {
            id: loadingImage

            anchors.centerIn: parent

            property int maxWidth: Math.min(units.dp(600), parent.width * 2/3)
            property int maxHeight: Math.min(units.dp(400), parent.height * 2/3)

            property real scale: Math.min(maxWidth/sourceSize.width, maxHeight/sourceSize.height)

            width: sourceSize.width * scale
            height: sourceSize.height * scale

            Behavior on opacity {

                NumberAnimation {
                    duration: 600
                }
            }
        }
    }
}

