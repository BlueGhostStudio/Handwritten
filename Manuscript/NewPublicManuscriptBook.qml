import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Layouts 1.13
import Handwritten 1.1
import "qrc:/Components/Ui" as UI

UI.SubPage {
    title: qsTr("New public manuscript book")
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        Label {
            text: qsTr("Write the title of the manuscript book")
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
            text: qsTr("Create")
            onClicked: {
                PMSCR.createPublicManuscriptBook(pfTitle.value).then(
                            (ret)=>{
                                rootWindowStackView.pop()
                            })
            }
        }
    }
}
