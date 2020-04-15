import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Layouts 1.13
import Handwritten 1.1
import "qrc:/Components/Ui" as UI

UI.SubPage {
    id: publishManuscriptRoot
    property int bid
    property int pmbid
    property int pmid
    property var titleStrokes
    property var pages
    title: qsTr("Publish Manuscript")

    StackView {
        id: publishManuscriptStackView
        anchors.fill: parent
        anchors.margins: 16
        initialItem: PublishStep1 {

        }
    }
}
