import QtQuick 2.13
import QtQuick.Controls 2.13
import "qrc:/Components/Ui" as UI
import BGMRPC 1.0
import Handwritten 1.1
import QtQuick.Layouts 1.13

UI.InboxPage {
    id: root
    title: qsTr("Slip of Paper")
    subTitle: qsTr("Inbox")

    signal newSlipOfPaper()

    extendedArea: UI.ToolButton {
        id: tbNewSlipOfPaper
        icon.source: "qrc:/icons/new.png"
    }

    SOPListView {
        id: sopInbox
        anchors.fill: parent
        bottomMargin: 64
    }

    Connections {
        target: HWR
        onJoined: sopInbox.model.loadInbox()
    }
    Connections {
        target: sopInbox
        onItemClicked: rootWindowStackView.push(Qt.createComponent("SlipOfPaperViewPage.qml"), {
                                          "inboxItem": item,
                                          "inboxModel": sopInbox.model
                                      })
    }

    Connections {
        target: tbNewSlipOfPaper
        onClicked: {
//            dlgNewSlipOfPaper.open()
            var newDlg = Qt.createComponent("NewSlipOfPaperDialog.qml").createObject(rootWindow)
            newDlg.open();
            /*var cmp = Qt.createComponent("NewSlipOfPaperPage.qml")
            if (cmp.status === Component.Ready) {
                rootWindowStackView.push(cmp)
            }*/
        }
    }

    /*Connections {
        target: dlgNewSlipOfPaper
        onAccepted: {
            var page = rootWindowStackView.push("NewSlipOfPaperPage.qml");
            page.createSlipOfPaper(dlgNewSlipOfPaper.to, dlgNewSlipOfPaper.paperType, dlgNewSlipOfPaper.hGuide)
        }
    }*/
}


