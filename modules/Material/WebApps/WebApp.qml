import QtQuick 2.0
import QtQuick.Window 2.0
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
                    loadingView.opacity = 0
                    webView.visible = true
                }
            }
        }

        Rectangle {
            anchors.bottom: parent.bottom

            width: parent.width * webView.loadProgress/100
            height: units.dp(3)
            color: Theme.primaryColor

            opacity: webView.loading ? 1 : 0

            Behavior on opacity {
                NumberAnimation {
                    duration: 300
                }
            }
        }

        Item {
            id: loadingView
            anchors.fill: parent

            Behavior on opacity {
                NumberAnimation {
                    duration: 600
                }
            }

            Image {
                id: loadingImage
                anchors.centerIn: parent

                width: implicitWidth/Screen.devicePixelRatio
                height: implicitHeight/Screen.devicePixelRatio

                sourceSize {
                    width: units.dp(500) * Screen.devicePixelRatio
                    height: units.dp(200) * Screen.devicePixelRatio
                }
            }

            Item {
                anchors {
                    top: loadingImage.bottom
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }

                ProgressCircle {
                    anchors.centerIn: parent
                }
            }
        }
    }
}
