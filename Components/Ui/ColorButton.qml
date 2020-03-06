import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import Handwritten 1.1
import "." as UI

UI.ToolButton {
    property int value: 0
    property PaperDefine paperDefine
//    padding: 2
//    leftInset: 5; rightInset: 5; topInset: 5; bottomInset: 5
    checkable: true
    contentItem: Rectangle {
        implicitWidth: 24 * uiRatio; implicitHeight: 24 * uiRatio
        radius: width / 2
        color: paperDefine.stroke_color[value]
        border.color: Material.accent
        border.width: parent.checked ? 2 : 0
    }
}
