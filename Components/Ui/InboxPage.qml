import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13

Page {
    property string subTitle
    property alias extendedArea: rlExtendedArea.data
    header: Pane {
        RowLayout {
            anchors.fill: parent
            spacing: 0
            Label {
                text: title + " - " + subTitle
                font.pixelSize: rootWindow.font.pixelSize * 1.5
                Layout.fillWidth: true
            }
            RowLayout {
                id: rlExtendedArea
                spacing: 0
            }
        }
    }
}
