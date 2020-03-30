import QtQuick 2.13

HWCanvas {
//    id: canvas
    hwType: 0
    hwInterface: SOP
    property bool realtime: false

    function loadData(sopid, slice) {
        console.log("loadData", sopid, slice)
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
            console.log("is realtime?", realtime)
            if (canvas.available)
                _drawStrokes_(ret.data)
            else
                canvas.availableChanged.connect(function () {
                    console.log("ok----")
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
                        console.log(ret)
                        initialPaper(ret ? ret.paper : false)
                        return loadData(sopid, slice)
                    })
    }
}
