import QtQuick 2.13
import ".."
import "../StrokeData.js" as StrokeData

HWCanvas {
    hwType: 2
    hwInterface: MSCR

    function loadData(msid) {
        function _drawStrokes_(ret) {
            clear ()
            drawStrokes(ret)
        }

        hwID = msid

        var page = MSCR.manuscriptPage(msid)
        if (page) {
            var data = StrokeData.rawDataToStrokes(page.data)
            if (canvas.available)
                _drawStrokes_(data)
            else
                canvas.availableChanged.connect(
                            ()=>{
                                _drawStrokes_(data)
                            })
        }
    }

    function load(msid) {
        loadData(msid)
    }
}
