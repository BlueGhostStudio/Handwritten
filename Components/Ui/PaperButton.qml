import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtGraphicalEffects 1.13
import Handwritten 1.1
import "." as UI

UI.RoundButton {
    id: rbtnRoot
    property int value
    property PaperDefine paperDefine
    property alias bgColorRect: bgColor

    background: Item {
        Image {
            id: bgImage
            fillMode: Image.Tile
            anchors.fill: parent
            source: paperDefine.background_image || ""
            visible: paperDefine.background_image !== undefined

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: bgImage.width; height: bgImage.height
                    radius: width / 2
                }
            }
        }
        Rectangle {
            id: bgColor
            anchors.fill: parent
            color: paperDefine.background_color || "#00000000"
            radius: width / 2
            border.color: Material.accent
            border.width: rbtnRoot.checked ? 2 : 0
        }
    }
}
