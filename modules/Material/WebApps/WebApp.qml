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

    property bool showAppName

    Page {
        id: page

        actionBar.hidden: true

        state: "loading"

        states: [
            State {
                name: "loading"

                PropertyChanges {
                    target: webView
                    visible: false
                }

                PropertyChanges {
                    target: errorView
                    visible: false
                }

            },

            State {
                name: "success"

                PropertyChanges {
                    target: loadingView
                    opacity: 0
                }

                PropertyChanges {
                    target: errorView
                    visible: false
                }
            },

            State {
                name: "error"

                PropertyChanges {
                    target: webView
                    visible: false
                }

                PropertyChanges {
                    target: loadingIndicator
                    visible: false
                }
            }
        ]

        transitions: Transition {
            from: "*"; to: "*"

            NumberAnimation {
                target: loadingView; property: "opacity"; duration: 600
            }
        }

        WebEngineView {
            id: webView

            url: webapp.url
            anchors.fill: parent

            onLoadingChanged: {
                print("Loading!", loading)
                if (!loading) {
                    if (loadRequest.status == WebEngineView.LoadSucceededStatus) {
                        page.state = "success"
                    } else if (loadRequest.status == WebEngineView.LoadFailedStatus) {
                        print(loadRequest.errorString, loadRequest.errorCode)
                        if (loadRequest.errorCode == -106) {
                            // No internet connection
                            errorLabel.text = "No internet connection available"
                        } else if (loadRequest.errorCode == -105) {
                            // Unable to resolve the requested domain
                            errorLabel.text = "The app has been moved or no longer exists"
                        } else {
                            errorLabel.text = "The app is currently unreachable"
                        }

                        page.state = "error"
                    }
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

        Rectangle {
            id: loadingView
            anchors.fill: parent

            property bool hasErrors

            Column {
                id: loadingColumn

                anchors.centerIn: parent

                spacing: units.dp(30)

                Image {
                    id: loadingImage
                    anchors.horizontalCenter: parent.horizontalCenter

                    width: implicitWidth/Screen.devicePixelRatio
                    height: implicitHeight/Screen.devicePixelRatio

                    sourceSize {
                        width: units.dp(400) * Screen.devicePixelRatio
                        height: (webapp.showAppName ? units.dp(150) : units.dp(200))
                                * Screen.devicePixelRatio
                    }
                }

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: webapp.title
                    style: "subheading"
                    font.pixelSize: units.dp(27)
                    visible: webapp.showAppName
                }
            }

            Item {
                anchors {
                    top: loadingColumn.bottom
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }

                ProgressCircle {
                    id: loadingIndicator

                    anchors.centerIn: parent
                }

                Row {
                    id: errorView

                    anchors.centerIn: parent
                    spacing: units.dp(20)

                    Icon {
                        name: "alert/warning"
                        color: Palette.colors["red"]["500"]
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Label {
                        id: errorLabel
                        anchors.verticalCenter: parent.verticalCenter
                        text: "The app is currently unreachable"

                        style: "subheading"
                        font.pixelSize: units.dp(20)
                        color: Theme.light.subTextColor
                    }
                }
            }
        }
    }
}
