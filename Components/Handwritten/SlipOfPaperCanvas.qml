import QtQuick 2.13

HWCanvas {
    id: canvas
    hwType: 0

    function load(sopid/*, realtime*/, slice) {
        function _load_(sopid, slice) {
            clear()
            if (slice === undefined)
                slice = false

            if (!slice)
                hwID = sopid

            HWR.getSlipOfPaperTemp(sopid, slice).then(function (ret) {
                drawStrokes(ret)
//                return Promise.resolve(ret)
            })
        }

        initial(sopid).then(function () {
            if (available) {
                _load_(sopid, slice)
            } else {
                availableChanged.connect(function () {
                    _load_(sopid, slice)
                })
            }
        })
    }
}
