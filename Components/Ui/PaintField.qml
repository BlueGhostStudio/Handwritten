import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Layouts 1.13
import Handwritten 1.1
import "." as UI

Item {
    id: root
    property int paperWidth: 266
    property int paperHeight: 64
    property alias paint: paint
    property var value: []

    HWPaint {
        id: paint
        anchors.fill: parent
        hwID: -1
        writeMode: true
        strokeType: 0
        strokeSize: 0

        canvas: HWCanvas {
            hwID: paint.hwID
            hwType: -1
            anchors.fill: parent

            hwInterface: QtObject {
                signal strokeUpdated(int sHwType, var sHwID, var sHwStroke)
                function write(id, stroke) {
                    value.push(stroke)
                    strokeUpdated(-1, -1, stroke)
                }
            }

            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.width: 1
                border.color: Material.accent
            }
        }

        Component.onCompleted: {
            canvas.paperDefine.width = paperWidth
            canvas.paperDefine.height = paperHeight
            canvas.paperDefine.initial(-1)
            strokeDefine.initial(-1)
        }
    }

    RowLayout {
        anchors.top: parent.top
        anchors.right: parent.right
        UI.ZoomButton {
            paint: root.paint
        }
        UI.ToolButton {
            icon.source: "qrc:/icons/broom.png"
            onClicked: {
                paint.canvas.clear ()
                value = []
            }
        }
    }

    /*function setValue(strokes) {
        value = strokes

    }*/
    onValueChanged: {
        console.log("onValueChanged")
        if (paint.canvas.available) {
            paint.canvas.clear()
            paint.canvas.drawStrokes(value)
        } else {
            paint.canvas.availableChanged.connect(
                        ()=>{
                            paint.canvas.clear()
                            paint.canvas.drawStrokes(value)
                        })
        }
    }
}
