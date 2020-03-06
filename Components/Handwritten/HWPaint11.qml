import QtQuick 2.13
import "HWColor.js" as HWC

Flickable {
    id: root
    property alias hwType: canvas.hwType
//    property int type: 0
    property int strokeType: 0
    property int strokeSize: 1
    property int color: 0
    property color draftColor: "black"
    property alias hwID: canvas.hwID
    property StrokeDefine strokeDefine: StrokeDefine {}
    property alias paperDefine: canvas.paperDefine
    property bool vguide: true
    property bool sync: false


    property alias zoom: canvas.scale

    clip: true

    state: ""

    contentWidth: canvas.width * zoom
    contentHeight: canvas.height * zoom
    interactive: false

    QtObject {
        id: pre
        property var pos
        property var size
    }

    HWCanvas {
        id: canvas
        hwType: 0

        /*paperType: {
            switch (type) {
            case 0:
                "SlipOfPaper"
                break
            case 1:
                "Letter"
                break
            case 2:
                "Manuscript"
                break
            }
        }*/

        width: canvasSize.width
        height: canvasSize.height
        transformOrigin: Item.TopLeft
        renderStrategy: Canvas.Threaded

        /*Timer {
            id: tWaitPan
            interval: 250
            onTriggered: root.state = "panning"
        }*/

        Canvas {
            id: draft
            anchors.fill: parent
            contextType: "2d"
            z: -1
            opacity: root.state === "writting" ? 1 : 0
            //            opacity: mpta.pressed && root.state === "writing" ? 1 : 0
            renderStrategy: Canvas.Threaded

            Behavior on opacity {
                NumberAnimation {}
            }
        }

        Canvas {
            id: guidelines
            anchors.fill: parent
            contextType: "2d"
            z: -1
            onPaint: {
                context.clearRect(0, 0, width, height)
                context.lineWidth = 1
                context.strokeStyle = "#33000000"
                for (var i = 1; i <= canvas.canvasSize.height / 32; i++) {
                    context.beginPath()
                    if (vguide) {
                        context.moveTo(i * 32, 0)
                        context.lineTo(i * 32, canvas.canvasSize.height)
                    } else {
                        context.moveTo(0, i * 32)
                        context.lineTo(canvas.canvasSize.width, i * 32)
                    }
                    context.stroke()
                }
                context.rect(0, 0, width, height)
                context.stroke()
            }
        }

        MultiPointTouchArea {
            id: mpta
            anchors.fill: parent
            property var beginPos

            touchPoints: [
                TouchPoint { id: point1 },
                TouchPoint { id: point2 }
            ]
            mouseEnabled: true

            onPressed: {
                if (root.state === "zooming") {
                    zoomIn(point1.x, point1.y)
                    root.state = ""
                } /*else if (point1.pressed && point2.pressed) {
                    root.state = "panning"
                    beginPos = {
                        "x": point1.x,
                        "y": point1.y
                    }
                }*/ else {
                    root.state = "readyToWrite"
                    pre.pos = {
                        "x": Math.round(point1.x * 10) / 10,
                        "y": Math.round(point1.y * 10) / 10
                    }
                    switch (strokeType) {
                    case 0:
                        pre.size = strokeDefine.ballPointPen[strokeSize]
                        break
                    case 1:
                        pre.size = calcStrokeSize(strokeDefine.pen[strokeSize * 2],
                                                  strokeDefine.pen[strokeSize * 2 + 1])
                        break
                    case 2:
                        pre.size = calcStrokeSize(strokeDefine.paint[strokeSize *2],
                                                  strokeDefine.paint[strokeSize * 2 + 1])
                    }
                }
            }
            onReleased: root.state = ""
            onTouchUpdated: {
                if (point1.pressed && point2.pressed) {
                    if (root.state === "panning") {
                        var orgCX = root.contentX
                        var orgCY = root.contentY
                        root.contentX = Math.max(
                                    Math.min(
                                        root.contentX + beginPos.x - point1.x,
                                        root.contentWidth - root.width), 0)
                        root.contentY = Math.max(
                                    Math.min(
                                        root.contentY + beginPos.y - point1.y,
                                        root.contentHeight - root.height), 0)

//                        beginPos.x = point1.x + root.contentX - orgCX
//                        beginPos.y = point1.y + root.contentY - orgCY
                    } else {
                        root.state = "panning"
                        beginPos = {
                            "x": point1.x,
                            "y": point1.y
                        }
                    }
                } else if (point1.pressed) {
                    if (root.state === "readyToWrite")
                        root.state = "writting"
                    else if (root.state === "writting") {
                        if (sync) {
                            draftColor = canvas.paperDefine.stroke_color[color]
                            draft.context.strokeStyle = HWC.opacity(draftColor,
                                                                    0.5)
                            draft.context.beginPath()
                            draft.context.moveTo(pre.pos.x, pre.pos.y)
                            draft.context.lineTo(point1.x, point1.y)
                        }


                        var dx = point1.x - pre.pos.x
                        var dy = point1.y - pre.pos.y
                        var dist = Math.pow(dx * dx + dy * dy, 0.5)

                        var stroke = {
                            "type": strokeType,
                            "prePos": pre.pos,
                            "pos": {
                                "x": Math.round(point1.x * 10) / 10,
                                "y": Math.round(point1.y * 10) / 10
                            },
                            "color": color
                        }
                        switch (strokeType) {
                        case 0:
                            stroke.size = strokeDefine.ballPointPen[strokeSize]
                            break
                        case 1:
                        case 2:
                            /*if (strokeType === 1)
                                stroke.size = calcStrokeSize(strokeDefine.paint(strokeSize), stro)*/
                            stroke.size = calcStrokeSize(strokeType === 1
                                                         ? strokeDefine.pen[strokeSize * 2]
                                                         : strokeDefine.paint[strokeSize * 2],
                                                         strokeType === 1
                                                         ? strokeDefine.pen[strokeSize * 2 + 1]
                                                         : strokeDefine.paint[strokeSize * 2 + 1])
                            stroke.preSize = pre.size
                            stroke.shade = Number(strokeDefine.shade[strokeSize])
                            //                            pre.size = stroke.size
                            var minRadius = Math.min(pre.size, stroke.size)
                            var maxRadius = Math.max(pre.size, stroke.size)
                            if (pre.size < stroke.size
                                    || stroke.size / 2 + dist > pre.size / 2)
                                pre.size = stroke.size
                            pre.size = stroke.size
                            break
                        }

                        pre.pos = {
                            "x": point1.x,
                            "y": point1.y
                        }

                        if (sync) {
                            draft.context.lineWidth = stroke.size
                            draft.context.stroke()
                            draft.requestPaint()
                        }

                        switch(hwType) {
                        case 0:
                            HWR.write_slipOfPaper(hwID, stroke, sync)
                            break
                        case 2:
                            HWR.write_manuscript(hwID, stroke, sync)
                            break
                        }
                    }/* else if (root.state === "panning") {
                        var orgCX = root.contentX
                        var orgCY = root.contentY
                        root.contentX = Math.max(
                                    Math.min(
                                        root.contentX + beginPos.x - point1.x,
                                        root.contentWidth - root.width), 0)
                        root.contentY = Math.max(
                                    Math.min(
                                        root.contentY + beginPos.y - point1.y,
                                        root.contentHeight - root.height), 0)

                        beginPos.x = point1.x + root.contentX - orgCX
                        beginPos.y = point1.y + root.contentY - orgCY
                    }*/
                }
            }

            function calcStrokeSize (minSize, maxSize) {
                minSize = Number(minSize)
                maxSize = Number(maxSize)
                var minPressure = Properties.writting.pressure[0]
                var maxPressure = Properties.writting.pressure[1]
//                console.log("--->", minSize, maxSize, minPressure, maxPressure)
                if (point1.pressure >= 0) {
                    var a = maxPressure - minPressure
                    var b = Math.min(Math.max(point1.pressure, minPressure), maxPressure) - minPressure
                    var c = maxSize - minSize
                    //                    c/a = x/b
                    return Math.round((minSize + b/a * c) * 100) / 100
                    //                    return point1.pressure * 20//0.2 / 4 = point1.pressure / x
                } else
                    return minSize
            }
        }
    }

    onVguideChanged: guidelines.requestPaint()

    function initial() {
        canvas.enabled = false
        return canvas.initial(hwID).then(function (ret) {
            if (ret !== false && ret.stroke.length > 0)
                strokeDefine.initial(ret.stroke)
            else
                strokeDefine.initial(-1)
            canvas.enabled = true

            return Promise.resolve(123)
        })
    }

    function zoomOut (ratio) {
        contentX *= ratio / zoom
        contentY *= ratio / zoom
        zoom = ratio
        state = ""
    }

    function zoomIn (cx, cy) {
        contentX = (cx - 16) * Properties.mis.zoomFactor// - width * 0.25
        contentY = (cy - 16) * Properties.mis.zoomFactor// - height * 0.25
        zoom = Properties.mis.zoomFactor
        state = ""
    }
}
