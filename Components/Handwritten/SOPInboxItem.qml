import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQml.Models 2.13
import QtQuick.Controls.Material 2.13
import QtGraphicalEffects 1.13

MouseArea {
    id: root
    property string from
    property bool realtime
    property alias sopid: canvas.hwID
    property var datetime

    width: 202
    height: 192

    Item {
        id: canvasWrap
//        x: (parent.width - width) / 2
//        y: (parent.height - 64 - height) / 2
        x: 5; y: 5
        width: 192
        height: 128
        transformOrigin: Item.TopLeft
        clip: true
        SlipOfPaperCanvas {
            id: canvas
            hwType: 0
            width: paperDefine.width
            height: paperDefine.height
        }
    }

    Text {
        x: 5; y: 133
        width: canvas.width
        color: Material.foreground
        text: {
            var d = new Date(root.datetime)
            "<strong>" + qsTr("From") + ": </strong>" + root.from + "<br>" + Qt.formatDateTime(d, "yyyy-M-d h:m")
        }
    }

    onClicked: {
        GridView.view.itemClicked(ObjectModel.index, this)
    }

    Connections {
        target: HWR
        onRemoteSignal: {
            if (obj !== "Handwritten")
                return

            if (sig === "endSlipOfPaper" && args[0] === sopid)
                realtime = false
            else if (sig === "stroke" && args[0] === canvas.hwType && args[1] === sopid) {

                console.log("onRemoteSignal", obj, sig)
                var s = args[2]
                if (s.pos.x < -canvas.x)
                    canvas.x = -s.pos.x + 5
                else if (s.pos.x > -canvas.x + canvasWrap.width)
                    canvas.x = canvasWrap.width - s.pos.x - 5

                if (s.pos.y < -canvas.y)
                    canvas.y = -s.pos.y + 5
                else if (s.pos.y > -canvas.y + canvasWrap.height)
                    canvas.y = canvasWrap.height - s.pos.y -5
            }
        }
    }

    Component.onCompleted: {
        canvas.load(sopid, true).then (function () {
//            console.log (canvas.range[0], canvas.range[1])
            if (canvas.range[0] < canvas.paperDefine.width) {
                canvas.x = -canvas.range[0] + 5
                canvas.y = -canvas.range[1] + 5
//                canvasWrap.width = Math.min(canvas.range[2] - canvas.range[0] + 10, canvasWrap.width)
//                canvasWrap.height = Math.min(canvas.range[3] - canvas.range[1] + 10, canvasWrap.height)
            }
        })
    }
}

