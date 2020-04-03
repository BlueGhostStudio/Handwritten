import QtQuick 2.0
import QtQml.Models 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import Handwritten 1.1
import "qrc:/Components/Ui" as UI

UI.SubPage {
    id: root
    property Item inboxItem
    property ObjectModel inboxModel
    property int inboxIndex: inboxItem.ObjectModel.index

    title: qsTr("Slip of Paper") + " - " + qsTr("From") + ": " + inboxItem.from
    /*extendedArea: [
        UI.ToolButton {
            text: qsTr("Save to Image")
            onClicked: canvas.saveToImage()
        }
    ]*/

    SlipOfPaperCanvas {
        id: canvas
        anchors.centerIn: parent
        width: 266
        height: 266
        scale: Properties.mis.paperRatio
    }

    UI.ToolButton {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        icon.source: "qrc:/icons/goBack.png"
        visible: inboxIndex > 0
        onClicked: {
            var ci = inboxIndex
            inboxItem = inboxModel.get(inboxIndex - 1)
//            inboxModel.remove(ci)
            readed(ci)
            load()
        }
    }
    UI.ToolButton {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        icon.source: "qrc:/icons/goNext.png"
        visible: inboxIndex < inboxModel.count - 1
        onClicked: {
            var ci = inboxIndex
            inboxItem = inboxModel.get(inboxIndex + 1)
//            inboxModel.remove(ci)
            readed(ci)
            load()
        }
    }

    StackView.onDeactivating: {
//        inboxModel.remove(inboxIndex)
        readed(inboxIndex)
    }

    function readed(i) {
        var item = inboxModel.get(i)
        SOP.haveReadSlipOfPaper(item.sopid).then(
                    (success)=>{
                        if (success)
                            inboxModel.remove(i)
                    })
    }

    function load() {
        canvas.load(inboxItem.sopid)
    }

//    backBtn.onClicked: SOP.haveReadSlipOfPaper(inboxItem.sopid)

    Component.onCompleted: load()
}
