import QtQuick 2.13
import QtQuick.Controls 2.13
import "qrc:/Components/Ui" as UI
import BGMRPC 1.0
import Handwritten 1.1

UI.InboxPage {
    id: root
    title: qsTr("Slip of Paper")
    subTitle: qsTr("Inbox")

    signal newSlipOfPaper()

    SOPListView {
        id: sopInbox
        anchors.fill: parent
        bottomMargin: 64
    }

    RoundButton {
        id: rbNewSlipOfPaper
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        highlighted: true
        icon.source: "qrc:/icons/new.png"
        icon.width: 50 * uiRatio
        icon.height: 50 * uiRatio
    }

    Connections {
        target: HWR
        onJoined: sopInbox.model.loadInbox()
    }
    Connections {
        target: sopInbox
        onItemClicked: stackView.push(Qt.createComponent("SlipOfPaperViewPage.qml"), {
                                          "inboxItem": item,
                                          "inboxModel": sopInbox.model
                                      })
    }

    Connections {
        target: rbNewSlipOfPaper
        onClicked: {
            var cmp = Qt.createComponent("NewSlipOfPaperPage.qml")
            if (cmp.status === Component.Ready) {
                stackView.push(cmp)
            }
        }
    }
}


