import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Layouts 1.13
import "qrc:/Components/Ui" as UI

Page {
    id: root
    property alias backBtn: tbBack
    property alias extendedArea: rlExtend.children

    header: ToolBar {
        height: 48 * uiRatio
        Material.elevation: 0
        UI.ToolButton {
            id: tbBack
            icon.source: "qrc:/icons/back.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            onClicked: rootWindowStackView.pop ()
        }
        Label {
            anchors.centerIn: parent
            text: root.title
        }
        RowLayout {
            id: rlExtend
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            spacing: 0
        }
    }
}
