import QtQuick 2.13
import QtQuick.Controls 2.13
import Handwritten 1.0

Page {
    width: 600
    height: 400

    header: Label {
        text: qsTr("Page 1")
        font.pixelSize: Qt.application.font.pixelSize * 2
        padding: 10
    }

    SOPListView {
        id: listView
        anchors.fill: parent
    }

    Connections {
        target: HWR
        onJoined: {
            //console.log ("joined", inbox.length)
            listView.model.loadInbox(inbox)
        }
    }
}
