import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import "qrc:/SlipOfPaper"
import "qrc:/Letter"
//import "qrc:/Manuscript"
import "qrc:/Components/Ui" as UI
import Handwritten 1.1

UI.TopLevelPage {
    property alias swipeView: swipeView
    titleAlign: Qt.AlignLeft
    title: qsTr("Handwritten")

    rightExtendedArea: [
        /*UI.ToolButton {
            id: tbMainMenu
            text: qsTr("Hand Written")
            font.pixelSize: rootWindow.font.pixelSize * 0.75
        }*/
        UI.ToolButton {
            text: rootWindow.loginUserNick
            onClicked: openMainMenu()
        }

    ]
    /*header: ToolBar {
        id: toolBar
        height: 48 * uiRatio
        UI.ToolButton {
            id: tbMainMenu
            text: qsTr("Hand Written")
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: rootWindow.font.pixelSize * 0.75
        }

        Label {
            anchors.centerIn: parent
            text: qsTr("Inbox")
        }
    }*/
    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        Repeater {
            model: swipeView.contentChildren
            TabButton {
                text: modelData.title
            }
        }
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent

        interactive: false

        currentIndex: tabBar.currentIndex

        SlipOfPaperInbox {
            id: slipOfPaperInbox
        }

        LetterlInbox {
            id: letterlInbox
        }

        Item {
            id: manuscriptBookShelf
            HWPaint {
                id: paint
                anchors.fill: parent
                writeMode: true
                strokeSize: 0
                strokeType: 0
                color: 0
                canvas: ManuscriptCanvas{
                    anchors.fill: parent
                    z:-1
                }
                hwID: "1p0"
            }
        }
    }

    /*Connections {
        target: paint
        Component.onCompleted: {
            var paperDefine = MSCR.getPaperDefine(paint.hwID);
            if (paperDefine) {
                console.log(paperDefine.paper, paperDefine.stroke)
                paint.initialPaper(paperDefine.paper)
                paint.initialStroke(paperDefine.stroke)
            }
        }
    }*/
    Connections {
        target: HWR
        onJoined: {
            var paperDefine = MSCR.getPaperDefine(paint.hwID);
            if (paperDefine) {
                console.log(paperDefine.paper, paperDefine.stroke)
                paint.initialPaper(paperDefine.paper)
                paint.initialStroke(paperDefine.stroke)
                paint.canvas.load(paint.hwID)
//                console.log(JSON.stringify(HWR.rawDataToStrokes(MSCR.manuscriptPage(paint.hwID).data)))
            }
        }
    }

    /*Connections {
        target: tbMainMenu
        onClicked: openMainMenu()
    }*/
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:5;anchors_height:200;anchors_width:200}
}
##^##*/

