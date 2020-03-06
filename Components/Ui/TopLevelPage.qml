import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls.Material 2.13

Page {
    id: root
    property alias leftExtendedArea: rlLeftExtend.children
    property alias rightExtendedArea: rlRightExtend.children
    property int titleAlign: Qt.AlignHCenter

    header: ToolBar {
        id: toolBar
        height: 48 * uiRatio

        RowLayout {
            id: rlLeftExtend
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            spacing: 0
        }
        Label {
            anchors.verticalCenter: parent.verticalCenter
            x: {
                switch(titleAlign) {
                case Qt.AlignLeft:
                    uiRatio * 5
                    break;
                case Qt.AlignHCenter:
                    (parent.width - width) / 2
                    break
                case Qt.AlignRight:
                    parent.width - width - uiRatio * 5
                    break
                }
            }

            text: root.title
            font.bold: true
        }

        RowLayout {
            id: rlRightExtend
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            spacing: 0
        }
    }
}
