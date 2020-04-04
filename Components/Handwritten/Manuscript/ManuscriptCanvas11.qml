import QtQuick 2.13
import ".."
import "../StrokeData.js" as StrokeData

HWCanvas {
    hwType: 2
    hwInterface: MSCR
    property int bid: -1
    property int pid: -1
    property PaperDefine notebookPaper: PaperDefine {}
    property PaperDefine notebookCover: PaperDefine {}
    hwID: bid + 'p' + pid

    signal startLoad()
    signal loading(int loaded, int total)
    signal finished()
    

    /*function loadData(msid) {
        function _drawStrokes_(ret) {
            clear ()
            drawStrokes(ret)
        }

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
    }*/

    Timer {
        id: tLoading
        interval: 1
        repeat: true

        property int drawed: 0
        property var pageData

        onTriggered: {
            drawStrokes(pageData.slice(drawed, drawed + 255))
            drawed += 255
            loading(drawed, pageData.length)
            if (drawed > pageData.length) {
                finished()
                stop()
            }
        }

        function startLoading(data) {
            clear();
            drawed = 0
            if (data === false) {
                pageData = [];
                finished()
                stop()
            } else {
                pageData = data
                startLoad()
                restart()
            }
        }
    }

    function loadData(data) {
        function _drawStrokes_(ret) {
            clear ()
            tLoading.restart()
            if (ret) {
//                drawStrokes(ret)
                tLoading.startLoading(ret)
            }
        }

        if (canvas.available)
            tLoading.startLoading(data)
//            _drawStrokes_(data)
        else
            canvas.availableChanged.connect(
                        ()=>{
                            tLoading.startLoading(data)
//                            _drawStrokes_(data)
                        })
    }

    function load() {
        var page = MSCR.manuscriptPage(hwID)
        if (pid === 0)
            paperDefine = notebookCover
        else
            paperDefine = notebookPaper
        paperDefineChanged()

        loadData(page ? StrokeData.rawDataToStrokes(page.data) : false)
    }
    
    function initialNotebookPaper() {
        var pd = MSCR.getPaperDefine(bid)
        notebookCover.initial(pd.cover)
        notebookPaper.initial(pd.paper)
        return pd.stroke
    }
}
