import QtQuick 2.13
import QtQuick.Controls 2.13
import Handwritten 1.1
import "qrc:/Components/Ui" as UI

UI.InboxPage {
    id: manuscriptInbox
    title: qsTr("Manuscript")
    subTitle: qsTr("Bookshelf")

    extendedArea: UI.ToolButton {
        id: tbNewManuscriptBook
        icon.source: "qrc:/icons/new.png"
    }

    ManuscriptBookshelfView {
        id: bookSelf
        anchors.fill: parent
        anchors.bottomMargin: 24
        clip: true
    }

    PageIndicator {
        id: indicator
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        count: bookSelf.count
        currentIndex: bookSelf.currentIndex
    }

    Connections {
        target: HWR
        onJoined: bookSelf.model.loadBookshelf()
    }

    Connections {
        target: bookSelf
        onItemClicked: rootWindowStackView.push("ManuscriptWritingPage.qml", {
                                          bid: item.bid
                                      })
    }

    Connections {
        target: tbNewManuscriptBook
        onClicked: {
            rootWindowStackView.push("NewManuscriptBookPage.qml")
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
