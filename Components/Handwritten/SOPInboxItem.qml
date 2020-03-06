import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQml.Models 2.13

MouseArea {
    id: root
    property string from
    property bool realtime
    property int sopid
    property var datetime

    width: 138
    height: 128

    SlipOfPaperCanvas {
        id: canvas
        x: 5
        y: 5
        width: 128
        height: 64
    }

    Text {
        x: 5; y: 69
        width: canvas.width
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

            if (args[0] === sopid) {
                if (sig === "endSlipOfPaper")
                    realtime = false
            }
        }
    }

    Component.onCompleted: {
        canvas.load(sopid, true)
    }
}

