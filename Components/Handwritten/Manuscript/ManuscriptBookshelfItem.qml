import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQml.Models 2.13
import ".."

MouseArea {
    id: root
    property var bid

    width: ListView.view.width
    height: ListView.view.height

    ManuscriptCanvas {
        id: canvas
        bid: root.bid
        pid: 0

        x: (parent.width - width * scale) / 2
        y: (parent.height - height * scale) / 2
        width: paperDefine.width
        height: paperDefine.height
        transformOrigin: Item.TopLeft
        scale: Math.min(parent.height / height, parent.width / width)
    }

    onClicked: {
        ListView.view.itemClicked(ObjectModel.index, this)
    }


    /*Connections {
        target: HWR
        onRemoteSignal: {
            if (obj === "localManuscriptWrite" && sig === "clear" && canvas.hwID === args[0])
                canvas.clear ()
        }
    }*/
    Component.onCompleted:  {
        canvas.initialNotebookPaper()
        canvas.load()
    }
}
