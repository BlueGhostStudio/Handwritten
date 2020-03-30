import QtQuick 2.13
import QtQuick.Controls 2.13
import BGMRPC 1.0
import Handwritten 1.1
import QtQuick.Window 2.13

ApplicationWindow {
    id: rootWindow
    visible: true
    width: 640
    height: 480
    title: qsTr("Handwritten")
    property alias rootWindowStackView: rootWindowStackView
    property alias inboxFrom: rootWindowStackView.initialItem
    property real uiRatio: Properties.mis.paperRatio
    property string loginUser: Properties.user.user
    property string loginUserNick: Properties.user.nick

    font.pixelSize: 14 * Properties.mis.paperRatio

    StackView {
        id: rootWindowStackView
        anchors.fill: parent
        initialItem: HomeForm {
        }
    }

    Menu {
        id: mainMenu

        MenuItem {
            text: qsTr("Settings")
            onTriggered: {
                openSettingsPage()
            }
        }
        MenuItem {
            text: qsTr("Signature")
            onTriggered: {
                Properties.user.user = ""
            }
        }
    }

    function openMainMenu (btn) {
        mainMenu.popup()
    }
    function openSettingsPage () {
        rootWindowStackView.push(Qt.createComponent("SettingsPage.qml"))
    }

    Connections {
        target: HWR
        /*onJoinFail: {
            var page = rootWindowStackView.push("qrc:/JoinWizard/JoinPage.ui.qml")
            page.errno = error.errno
        }*/
        onJoined: {
            Properties.user.user = user
        }
    }

    Component.onCompleted: {
        HWR.active = true
        /*var page = rootWindowStackView.push("qrc:/JoinWizard/JoinPage.ui.qml")
        page.enabled = false*/
        HWR.statusChanged.connect (function () {
            console.log(Properties.user.user)
            if (Properties.user.user) {
                if (Qt.platform.os === 'android' || Qt.platform.os === 'ios') {
                    HWR.join(/*0, */Properties.user.user).catch(
                                (errno) => {
                                    let page = rootWindowStackView.push("qrc:/JoinWizard/JoinPage.ui.qml")
                                    console.log("errno", errno)
                                    if (errno === -1)
                                        page.joinAction = 1
                                    else if (errno === -2)
                                        page.joinAction = 2
                                })
                } else {
                    let page = rootWindowStackView.push("qrc:/JoinWizard/JoinPage.ui.qml")
                    page.joinAction = 0
                }
            } else {
                var page = rootWindowStackView.push("qrc:/JoinWizard/JoinPage.ui.qml")
                page.joinAction = 1
            }
        })
    }
}
