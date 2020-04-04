import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Layouts 1.13
import Handwritten 1.1
import "qrc:/Components/Ui" as UI

UI.SubPage {
    title: qsTr("Create New Manuscript Book")
    PaperSelector {
        id: bookSelector
        width: parent.width
        height: parent.height
        previewWidth: width
        previewHeight: height
        fillMode: Image.PreserveAspectFit

        snapMode: ListView.SnapOneItem
        highlightRangeMode: ListView.StrictlyEnforceRange

        model: [
            { image: "qrc:/imgs/coverA4.png", value: -1 },
            { image: "qrc:/imgs/coverA5.png", value: -3 },
            { image: "qrc:/imgs/coverA6.png", value: -2 }
        ]
    }

    UI.Button {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: height
        text: qsTr("Create")
        icon.source: "qrc:/icons/new.png"

        onClicked: {
            MSCR.createManuscriptBook(bookSelector.value)
            rootWindowStackView.pop()
        }
    }
}
