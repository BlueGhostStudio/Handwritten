pragma Singleton
import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtGraphicalEffects 1.13
import QtQuick.Controls 2.13

QtObject {
    property Item fakeRoot: Item {}
    property Component sopInboxItemCmp: Component {
        SOPInboxItem {
        }
    }
    /*property Component manuscriptBookshelfCmp: Component {
        ManuscriptBookshelfItem {
        }
    }*/
}
