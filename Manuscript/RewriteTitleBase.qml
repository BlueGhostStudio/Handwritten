import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Layouts 1.13
import Handwritten 1.1
import "qrc:/Components/Ui" as UI

UI.SubPage {
    property int pmid
    property alias value: pfTitle.value
    signal rewrite(var titleStrokes)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16

        Label {
            text: qsTr("Title")
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
            text: qsTr("Rewrite")
            onClicked: rewrite(pfTitle.value)
        }
    }
}
