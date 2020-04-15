import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Layouts 1.13
import Handwritten 1.1
import "qrc:/Components/Ui" as UI

ColumnLayout {
    Label {
        text: qsTr("Write the title of the manuscript")
        font.bold: true
    }
    UI.PaintField {
        id: pfTitle
        Layout.fillWidth: true
        Layout.fillHeight: true
        paperWidth: 266
        paperHeight: 64
    }

    UI.ToolButton {
        Layout.alignment: Qt.AlignRight
        highlighted: true
        text: qsTr("Next")
        onClicked: {
            publishManuscriptRoot.titleStrokes = pfTitle.value
            publishManuscriptStackView.push("PublishStep3.qml")
        }
    }
}
