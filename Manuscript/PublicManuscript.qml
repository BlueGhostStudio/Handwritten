import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Layouts 1.13
import Handwritten 1.1
import "qrc:/Components/Ui" as UI

UI.SubPage {
    title: qsTr("Public Manuscript")

    extendedArea: [
        UI.ToolButton {
            icon.source: "qrc:/icons/bookshelf.png"
            visible: publicManuscriptModel.pmbid > 0
            onClicked: publicManuscriptModel.loadBookshelf()
        },
        UI.ToolButton {
            icon.source: "qrc:/icons/documents.png"
            visible: publicManuscriptModel.pmid > 0
            onClicked: publicManuscriptModel.loadManuscripts(publicManuscriptModel.pmbid)
        },
        UI.ToolButton {
            id: tbNewManuscriptBook
            icon.source: "qrc:/icons/new.png"
            visible: publicManuscriptModel.pmbid === -1
            onClicked: {
                rootWindowStackView.push("NewPublicManuscriptBook.qml")
            }
        }
    ]


    Component {
        id: bookRewriteTitlePageCmp
        RewriteTitleBase {
            title: qsTr("Rewrite Manuscript book title")
            onRewrite: {
                PMSCR.rewritePublicManuscriptBookTitle(pmid,
                                                       titleStrokes).then(
                            ()=>{
                                rootWindowStackView.pop()
                            })
            }
        }
    }

    Component {
        id: manuscriptRewriteTitlePageCmp
        RewriteTitleBase {
            title: qsTr("Rewrite Manuscript title")
            onRewrite: {
                PMSCR.rewritePublicManuscriptTitle(pmid, titleStrokes).then(
                            ()=>{
                                rootWindowStackView.pop()
                            })
            }
        }
    }

    Dialog {
        id: dlgReseq
        property int pmid
        title: qsTr("resequence")
        anchors.centerIn: overlay
        UI.NumberField {
            id: nfSeq
            placeholderText: qsTr("Sequence")
        }
        standardButtons: Dialog.Ok | Dialog.Cancel

        onAccepted: {
            console.log(pmid)
            if (nfSeq.text.length === 0)
                console.log("fail")
            else if (publicManuscriptModel.pmbid === -1)
                PMSCR.resequenceManuscriptBook(pmid, Number(nfSeq.text))
            else if (publicManuscriptModel.pmid === -1)
                PMSCR.resequenceManuscript(pmid, Number(nfSeq.text))
        }
    }

    Menu {
        id: itemMenu
        property int pmid
        property var data
        UI.MenuItem {
            enabled: publicManuscriptModel.pmid === -1
            text: qsTr("Rewrite Title")
            onTriggered: {
                if (publicManuscriptModel.pmbid === -1)
                    rootWindowStackView.push(bookRewriteTitlePageCmp, {
                                                 pmid: itemMenu.pmid,
                                                 value: itemMenu.data.title
                                             })
                else if (publicManuscriptModel.pmbid > 0
                         && publicManuscriptModel.pmid === -1)
                    rootWindowStackView.push(manuscriptRewriteTitlePageCmp, {
                                                 pmid: itemMenu.pmid,
                                                 value: itemMenu.data.title
                                             })
            }
        }
        UI.MenuItem {
            text: qsTr("Delete")
            onTriggered: {
                if (publicManuscriptModel.pmbid === -1)
//                    console.log(itemMenu.pmid)
                    PMSCR.deletePublicManuscriptBook(itemMenu.pmid)
                else if (publicManuscriptModel.pmid === -1)
                    PMSCR.deletePublicManuscript(itemMenu.pmid)
                else
                    PMSCR.deletePublicManuscriptPage(itemMenu.pmid)
            }
        }
        UI.MenuItem {
            enabled: publicManuscriptModel.pmid === -1
            text: qsTr("Resequence")
            onTriggered: {
                nfSeq.text = itemMenu.data.seq || ''
                dlgReseq.pmid = itemMenu.pmid
                dlgReseq.open()
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        Label {
            text: {
                var comment = qsTr("(Long press the item to display the operation menu)")
                if (publicManuscriptModel.pmbid === -1)
                    qsTr("Public manuscript book") + comment
                else if (publicManuscriptModel.pmid === -1)
                    qsTr("Public manuscript") + comment
                else
                    qsTr("Public manuscript pages")
            }

            wrapMode: Text.Wrap
            font.bold: true
        }

        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 1
            model: PublicManuscriptModel {
                id: publicManuscriptModel
                onItemPressNHold: {
                    itemMenu.pmid = item_pmid
                    itemMenu.data = data
                    itemMenu.popup()
                }
            }
        }
    }

    Component.onCompleted: {
        publicManuscriptModel.loadBookshelf();
    }
}
