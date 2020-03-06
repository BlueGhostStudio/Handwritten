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
    property alias stackView: stackView
    property alias inboxFrom: stackView.initialItem
    property real uiRatio: Properties.mis.paperRatio
    property string loginUser: "none"

    font.pixelSize: 14 * uiRatio

    StackView {
        id: stackView
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
        }
    }

    function openMainMenu (btn) {
        mainMenu.popup()
    }
    function openSettingsPage () {
        stackView.push(Qt.createComponent("SettingsPage.qml"))
    }

    Component.onCompleted: {
        HWR.active = true
        var page = stackView.push("LoginPage.ui.qml")
        page.enabled = false
        HWR.statusChanged.connect (function () {
//            HWR.join("g")
            page.enabled = true
        })
    }
}
