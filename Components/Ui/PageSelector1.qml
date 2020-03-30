import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Layouts 1.13
import Handwritten 1.1
import "qrc:/Components/Ui" as UI

Flickable {
    id: pageSelector
    property int pageCount: 61
    property int currentPage: pid
    contentWidth: flow.width
    contentHeight: flow.height
    clip: true
    signal pageSelected(int page)
    Flow {
        id: flow
        spacing: 5
        width: pageSelector.width
        
        Repeater {
            model: pageCount
            MouseArea {
                width: 32 * Properties.mis.paperRatio
                height: 32 * Properties.mis.paperRatio
                Label {
                    anchors.centerIn: parent
                    text: index
                    color: index === pid ? Material.accent : Material.foreground
                    font.bold: index === pid
                }
                
                onClicked: pageSelector.pageSelected(index)
            }
        }
    }
}
