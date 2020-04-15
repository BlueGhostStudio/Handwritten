import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Layouts 1.13
import Handwritten 1.1
import "qrc:/Components/Ui" as UI

ColumnLayout {
    Label {
        text: qsTr("Which book you Published manuscript to")
        font.bold: true
    }
    ListView {
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true
        spacing: 1

        UI.ToolButton {
            anchors.right: parent.right
            anchors.top: parent.top
            icon.source: "qrc:/icons/bookshelf.png"
            visible: publicManuscriptModel.pmbid > 0
            onClicked: publicManuscriptModel.loadBookshelf()
        }

        model: PublicManuscriptModel {
            id: publicManuscriptModel
        }
    }

    UI.ToolButton {
        Layout.alignment: Qt.AlignRight
        highlighted: true
        text: qsTr("Next")
        visible: publicManuscriptModel.pmbid > 0
        onClicked: {
            if (publicManuscriptModel.pmbid === -1)
                return

            publishManuscriptRoot.pmbid = publicManuscriptModel.pmbid
            publishManuscriptRoot.pmid = publicManuscriptModel.pmid
            if (publishManuscriptRoot.pmid === -1)
                publishManuscriptStackView.push("PublishStep2.qml")
            else
                publishManuscriptStackView.push("PublishStep3.qml")
        }
    }

    Component.onCompleted: {
        publicManuscriptModel.loadBookshelf()
    }
}
