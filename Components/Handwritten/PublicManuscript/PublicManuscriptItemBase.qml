import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQml.Models 2.13
import QtQuick.Layouts 1.13
import ".."
import "../StrokeData.js" as StrokeData

RowLayout {
    property int pmid
    property int paperWidth: 266
    property int paperHeight: 64
    property var titleStrokes
    property int seq
    property alias mouseArea: mouseArea
    property ObjectModel model
    spacing: 0

    Label {
        text: "#" + (seq || '-')
    }

    MouseArea {
        id: mouseArea
        Layout.preferredHeight: paperHeight
        Layout.minimumWidth: paperWidth
        Layout.fillWidth: true
        clip: true

        HWCanvas {
            id: canvas
            width: paperWidth;height: paperHeight
            onRangeChanged: {
                mouseArea.Layout.preferredHeight = range[3] - range[1] + 20
                y = -range[1] + 10
            }
        }

        onPressAndHold: model.itemPressNHold(pmid, {
                                                 title: titleStrokes,
                                                 seq: seq
                                             })
    }

    function load(data) {
        canvas.resetRange()
        titleStrokes = StrokeData.rawDataToStrokes(data.title)
        if (data.seq)
            seq = data.seq
        if (canvas.available) {
            canvas.clear()
            canvas.drawStrokes(titleStrokes)
        } else {
            canvas.availableChanged.connect(
                        ()=>{
                            canvas.clear()
                            canvas.drawStrokes(titleStrokes)
                        })
        }
    }
    Component.onCompleted: {
        canvas.paperDefine.width = paperWidth
        canvas.paperDefine.height = paperHeight
        canvas.paperDefine.background_color = "#00000000"
        canvas.paperDefine.initial(-1)
    }
}
