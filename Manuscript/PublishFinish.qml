import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Layouts 1.13
import Handwritten 1.1
import "qrc:/Components/Ui" as UI

Item {
    property bool finished: false
    property int publishPage: -1

    ColumnLayout {
        anchors.centerIn: parent

        Label {
            text: qsTr("Publishing...") + qsTr("Page") + publishPage + ' ' + pbPages.value + '/' + pbPages.to
        }

        ProgressBar {
            id: pbPages
            Layout.fillWidth: true
        }
        ProgressBar {
            id: pbData
            Layout.fillWidth: true
        }
        UI.ToolButton {
            highlighted: true
            Layout.alignment: Qt.AlignRight
            text: qsTr("Finish")
            visible: finished
            onClicked: {
                rootWindowStackView.pop()
            }
        }
    }

    Connections {
        target: PMSCR
        onPublishManuscriptProgress: {//console.log("page-", value, total)
            if (value < total)
                publishPage = publishManuscriptRoot.pages[value]
            pbPages.value = value
            pbPages.to = total
        }
        onPublishPageProgress: { //console.log("data-", value, total)
            pbData.value = value
            pbData.to = total
        }
    }

    Component.onCompleted: {
        if (publishManuscriptRoot.pmbid === -1)
            return;
        else if (publishManuscriptRoot.pmid === -1)
            PMSCR.publishNewManuscript(publishManuscriptRoot.pmbid,
                                       publishManuscriptRoot.titleStrokes,
                                       publishManuscriptRoot.bid,
                                       publishManuscriptRoot.pages).then(
                        ()=>{
                            finished = true
                        })
        else
            PMSCR.publishPages2Manuscript(publishManuscriptRoot.pmid,
                                          publishManuscriptRoot.bid,
                                          publishManuscriptRoot.pages).then(
                        ()=>{
                            finished = true
                        })
    }
}
