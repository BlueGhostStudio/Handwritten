import QtQuick 2.13
import ".."

HWCanvas {
//    id: canvas
    hwType: 0
    hwInterface: SOP
    property bool realtime: false
    objectName: "SlipOfPaperCanvas"

    function loadData(sopid, slice) {
        function _drawStrokes_(ret) {
            clear ()
            drawStrokes(ret)
        }

        if (slice === undefined)
            slice = false

        if (!slice)
            hwID = sopid

        return SOP.getSlipOfPaperTemp(sopid, slice).then(function (ret) {
            realtime = ret.realtime
            if (canvas.available)
                _drawStrokes_(ret.data)
            else
                canvas.availableChanged.connect(function () {
                    _drawStrokes_(ret.data)
                })
        })
    }

    Connections {
        target: SOP
        onHasEndedSlipOfPaper: {
            if (hwSopid === hwID)
                realtime = false
        }
    }

    function load(sopid/*, realtime*/, slice) {
        /*return initial(sopid).then(function () {
            return loadData(sopid, slice)
        })*/
        return SOP.getPaperDefine(sopid).then(
                    (ret)=>{
                        initialPaper(ret ? ret.paper : false)
                        return loadData(sopid, slice)
                    })
    }
}
