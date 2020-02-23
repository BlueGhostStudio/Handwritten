import QtQuick 2.13

QtObject {
    property var shade
    property var len
    property var ampFactor
    property var redFactor
    property var maxAmp
    property var minRed
    property var ballPointPen
    property var pen
    property var paint

    function initial(define) {
        if (define === -1) {
            shade = Properties.stroke.shade
            len = Properties.stroke.len
            ampFactor = Properties.stroke.ampFactor
            redFactor = Properties.stroke.redFactor
            maxAmp = Properties.stroke.maxAmp
            minRed = Properties.stroke.minRed
            ballPointPen = Properties.stroke.ballPointPen
            pen = Properties.stroke.pen
            paint = Properties.stroke.paint
        } else {
            define = JSON.parse(define)
            shade = define.shade
            len = define.len
            ampFactor = define.ampFactor
            redFactor = define.redFactor
            maxAmp = define.maxAmp
            minRed = define.minRed
            ballPointPen = define.ballPointPen
            pen = define.pen
            paint = define.paint
        }
    }
}
