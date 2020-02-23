import QtQuick 2.13

HWCanvas {
    id: canvas
//    hwID: sopid
    paperType: "SlipOfPaper"

    function load(sopid, realtime, slice) {
        clear()
        if (slice === undefined)
            slice = false

        if (!slice)
            hwID = sopid

        return HWR.getSlipOfPaperTemp(sopid, slice).then(function (ret) {
            drawStrokes(ret)
            return Promise.resolve(ret)
        })
    }
}
