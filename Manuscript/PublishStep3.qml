import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Layouts 1.13
import Handwritten 1.1
import "qrc:/Components/Ui" as UI

ColumnLayout {
    Label {
        text: qsTr("Publish Pages")
        font.bold: true
    }

    Item {
        Layout.fillWidth: true
        Layout.fillHeight: true
        TextField {
            id: tfPages
            anchors.centerIn: parent
            width: Math.min(300, parent.width)
            placeholderText: qsTr("Page list separated by ','(ex. 1,2,3,...)")
        }
    }

    UI.ToolButton {
        highlighted: true
        Layout.alignment: Qt.AlignRight
        text: qsTr("Publish")
        visible: tfPages.text.length > 0
        onClicked: {
            publishManuscriptRoot.pages = tfPages.text.split(',')
            publishManuscriptStackView.push("PublishFinish.qml")
            /*console.log(publishManuscriptRoot.bid, publishManuscriptRoot.pmbid,
                        publishManuscriptRoot.titleStrokes.length,
                        publishManuscriptRoot.pages)*/
        }
    }
}
