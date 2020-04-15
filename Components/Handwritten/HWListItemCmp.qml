pragma Singleton
import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtGraphicalEffects 1.13
import QtQuick.Controls 2.13

import "SlipOfPaper"
import "Manuscript"
import "PublicManuscript"

QtObject {
    property Item fakeRoot: Item {}
    property Component sopInboxItemCmp: Component {
        SOPInboxItem {
        }
    }
    property Component manuscriptBookshelfItemCmp: Component {
        ManuscriptBookshelfItem {
        }
    }
    property Component publicManuscriptBookshelfItemCmp: Component {
        PublicManuscriptItemBase {
            Connections {
                target: mouseArea
                onClicked: {
                    model.loadManuscripts(pmid)
                }
            }
        }
    }
    property Component publicManuscriptItemCmp: Component {
        PublicManuscriptItemBase {
            Connections {
                target: mouseArea
                onClicked: {
                    model.loadManuscriptPages(pmid)
                }
            }
        }
    }
    property Component publicManuscriptPageItemCmp: Component {
        PublicManuscriptPageListItem {
        }
    }
}
