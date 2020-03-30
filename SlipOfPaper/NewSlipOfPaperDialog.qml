import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import Handwritten 1.1

Dialog {
    id: dlgNewSlipOfPaper
    title: qsTr("New slip of paper")
    anchors.centerIn: overlay
    property alias to: tfTo.text
    property alias paperType: paperSelector.value
    property bool hGuide: cbHGuide.checked
    ColumnLayout {
        TextField {
            id: tfTo
            Layout.fillWidth: true
            placeholderText: qsTr("to")
        }
        PaperSelector {
            id: paperSelector
            Layout.fillWidth: true
            Layout.preferredHeight: 64
            model: [
                { color: "yellow", value: -1 },
                { image: "qrc:/imgs/paper.png", value: -2 }
            ]
        }
        CheckBox {
            id: cbHGuide
            Layout.fillWidth: true
            checked: true
            text: qsTr("Horizontal guide")
        }
    }
    footer: DialogButtonBox {
        Button {
            text: qsTr("Create")
            DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
        }
    }

    onAccepted: {
        var page = rootWindowStackView.push("NewSlipOfPaperPage.qml");
        page.createSlipOfPaper(dlgNewSlipOfPaper.to, dlgNewSlipOfPaper.paperType, dlgNewSlipOfPaper.hGuide)
    }
}
