import QtQuick 2.0
import QtQuick.Controls 2.13
import Handwritten 1.1
import "qrc:/Components/Ui" as UI

UI.SubPage {
    id: root
    title: qsTr("Settings")
    padding: 20
    ScrollView {
        anchors.fill: parent
        contentWidth: settings.width
        contentHeight: settings.height
        HWSettings {
            id: settings
            width: root.width - root.padding * 2
        }
    }

    backBtn.onClicked: settings.accept()
}
