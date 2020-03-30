import QtQuick 2.13

HWCanvas {
    hwType: 2
    property int readStrokesPerTime: Properties.mis.readStrokesPerTime

    signal dataLoaded()

    function loadData() {
        function _drawStrokes_(buffer, startPos, len) {
            if (startPos === 0 || buffer === -1)
                clear()

            if (buffer === -1) {
                dataLoaded()
                return;
            }

            HWR.readManuscriptData(buffer, startPos, len).then(function (ret) {
//                if (ret.data.length > 0)
                drawStrokes(ret.data)

                if (ret.pos >= 0)
                    _drawStrokes_(buffer, ret.pos, readStrokesPerTime)
                else
                    dataLoaded()
            })
        }
        HWR.manuscriptPage(hwID).then(function (buffer) {
            if (canvas.available)
                _drawStrokes_(buffer, 0, readStrokesPerTime)
            else
                canvas.availableChanged.connect (function () {
                    _drawStrokes_(buffer, 0, readStrokesPerTime)
                })

//            console.log("====>", ret)
            /*if (available)
                _drawStrokes_(ret)
            else
                availableChanged.connect (function () {
                    _drawStrokes_(ret)
                })*/
        })
    }

    function load(msid) {
        initial(msid).then (function () {
            loadData()
        })

//        initial(msid)
        /*console.log(msid, paperType)
        HWR.getPaperDefine(msid, paperType).then(function (ret) {
            console.log("--->", ret)
        })*/
    }
}
