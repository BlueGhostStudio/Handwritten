import QtQuick 2.13
import "HWColor.js" as HWC

Flickable {
    id: root
    property int type: 0
    property int strokeType: 0
    property int strokeSize: 1
    property int color: 0
    property color draftColor: "black"
    property alias hwID: canvas.hwID
    property StrokeDefine strokeDefine: StrokeDefine {}
    property alias paperDefine: canvas.paperDefine
    property bool vguide: true


    property alias zoom: canvas.scale

    clip: true

    state: "writing"

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

        paperType: {
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
        }

        width: canvasSize.width
        height: canvasSize.height
        transformOrigin: Item.TopLeft
        renderStrategy: Canvas.Threaded

        Timer {
            id: tWaitPan
            interval: 250
            onTriggered: root.state = "panning"
        }

        Canvas {
            id: draft
            anchors.fill: parent
            contextType: "2d"
            z: -1
            opacity: mouseArea.pressed && root.state === "writing" ? 1 : 0
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

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            property var beginPos

            onPressed: {
                if (root.state === "zooming") {
                    zoomIn(mouseX, mouseY)
                    root.state = ""
                } else {
                    tWaitPan.restart()
                    pre.pos = {
                        "x": Math.round(mouseX * 10) / 10,
                        "y": Math.round(mouseY * 10) / 10
                    }
                    switch (strokeType) {
                    case 0:
                        pre.size = strokeDefine.ballPointPen[strokeSize]
                        break
                    case 1:
                        pre.size = strokeDefine.pen[strokeSize]
                        break
                    case 2:
                        pre.size = strokeDefine.paint[strokeSize]
                    }

                    beginPos = {
                        "x": mouseX,
                        "y": mouseY
                    }
                }
            }

            onPositionChanged: {
                tWaitPan.stop()
                if (pressed) {
                    if (root.state === "writing") {
                        draftColor = canvas.paperDefine.stroke_color[color]
                        draft.context.strokeStyle = HWC.opacity(draftColor,
                                                                0.5)
                        draft.context.lineWidth = strokeType === 0 ? strokeDefine.ballPointPen[strokeSize] : strokeDefine.pen[strokeSize]

                        draft.context.beginPath()
                        draft.context.moveTo(pre.pos.x, pre.pos.y)
                        draft.context.lineTo(mouseX, mouseY)
                        draft.context.stroke()
                        draft.requestPaint()

                        var stroke = {
                            "type": strokeType,
                            "prePos": pre.pos,
                            "pos": {
                                "x": Math.round(mouseX * 10) / 10,
                                "y": Math.round(mouseY * 10) / 10
                            },
                            "color": color
                        }

                        switch (strokeType) {
                        case 0:
                            stroke.size = strokeDefine.ballPointPen[strokeSize]
                            break
                        case 1:
                        case 2:
                            var dx = mouseX - pre.pos.x
                            var dy = mouseY - pre.pos.y
                            var dist = Math.pow(dx * dx + dy * dy, 0.5)
                            dist = Math.min(Math.max(dist, 1), 10)
                            var oi = (strokeType - 1) * 2 + strokeSize
                            var flow = dist > strokeDefine.len[oi] ? strokeDefine.redFactor[oi] : strokeDefine.ampFactor[oi]

                            var baseBrushSize = strokeType === 1 ? strokeDefine.pen[strokeSize] : strokeDefine.paint[strokeSize] //STRP.p_size[strokeSize]
                            stroke.size = pre.size * flow
                            stroke.size = Math.max(
                                        Math.min(
                                            stroke.size,
                                            baseBrushSize * strokeDefine.maxAmp[oi]),
                                        Math.max(
                                            baseBrushSize * strokeDefine.minRed[oi],
                                            1))
                            stroke.size = Math.ceil(stroke.size * 100) / 100
                            stroke.preSize = pre.size
                            stroke.shade = strokeDefine.shade[strokeSize]
                            break
                        }

                        switch (type) {
                        case 0:
                            HWR.write_slipOfPaper(hwID, stroke)

                            break
                        }
                        pre.pos = {
                            "x": mouseX,
                            "y": mouseY
                        }

                        var minRadius = Math.min(pre.size, stroke.size)
                        var maxRadius = Math.max(pre.size, stroke.size)
                        if (pre.size < stroke.size
                                || stroke.size / 2 + dist > stroke.preSize / 2)
                            pre.size = stroke.size
                    } else if (root.state === "panning") {
                        var orgCX = root.contentX
                        var orgCY = root.contentY
                        root.contentX = Math.max(
                                    Math.min(
                                        root.contentX + (beginPos.x - mouseX) * Properties.mis.panFactor,
                                        root.contentWidth - root.width), 0)
                        root.contentY = Math.max(
                                    Math.min(
                                        root.contentY + (beginPos.y - mouseY) * Properties.mis.panFactor,
                                        root.contentHeight - root.height), 0)

                        beginPos.x = mouseX + root.contentX - orgCX
                        beginPos.y = mouseY + root.contentY - orgCY
                    }
                }
            }

            onReleased: {
                root.state = "writing"
                tWaitPan.stop()
            }
        }
    }

    function initial() {
        canvas.enabled = false
        canvas.initial(hwID, true).then(function (ret) {
            if (ret.stroke.length > 0)
                strokeDefine.initial(ret.stroke)
            else
                strokeDefine.initial(-1)
            canvas.enabled = true
        })
    }

    function zoomOut () {
        contentX *= 1 / zoom
        contentY *= 1 / zoom
        zoom = 1
    }

    function zoomIn (cx, cy) {
        contentX = cx * Properties.mis.zoomFactor - width * 0.25
        contentY = cy * Properties.mis.zoomFactor - height * 0.25
        zoom = Properties.mis.zoomFactor
    }
}
