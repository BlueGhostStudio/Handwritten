import QtQuick 2.13

HWCanvas {
//    id: canvas
    hwType: 0

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

        return HWR.getSlipOfPaperTemp(sopid, slice).then(function (ret) {
            if (canvas.available)
                _drawStrokes_(ret)
            else
                canvas.availableChanged.connect(function () {
                    console.log("ok----")
                    _drawStrokes_(ret)
                })
        })

    }

    function load(sopid/*, realtime*/, slice) {
        return initial(sopid).then(function () {
            return loadData(sopid, slice)
        })
    }
}
