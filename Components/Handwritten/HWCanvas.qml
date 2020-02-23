import QtQuick 2.13
import "HWColor.js" as HWC

Canvas {
    id: canvas
    contextType: "2d"
    property var hwID
    property var range: [Number.MAX_VALUE, Number.MAX_VALUE, 0, 0]
    property string paperType: "SlipOfPaper"
    property PaperDefine paperDefine: PaperDefine {}
    canvasSize.width: paperDefine.width
    canvasSize.height: paperDefine.height

    clip: true

    QtObject {
        id: tmp
        property color color
    }

    Rectangle {
        id: bgColorLayer
        anchors.fill: parent
        z: -1
        color: paperDefine.background_color || "#00000000"
    }
    Image {
        id: bgImageLayer
        fillMode: Image.Tile
        anchors.fill: parent
        z: -1
        source: paperDefine.background_image || ""
    }

    function clear () {
        context.clearRect(0, 0, canvasSize.width, canvasSize.height)
        requestPaint()
    }

    function resize(stroke) {
        var prePos = stroke.prePos
        var pos = stroke.pos
        range = [Math.max(Math.min(range[0], prePos.x, pos.x), 0), Math.max(
                     Math.min(range[1], prePos.y, pos.y),
                     0), Math.min(Math.max(range[2], prePos.x,
                                           pos.x), width), Math.min(
                     Math.max(range[3], prePos.y, pos.y), height)]
    }

    function drawStrokes(strokes) {
        for (var x in strokes) {
            switch(strokes[x].type) {
            case 0:
                canvas.ballpointStroke(strokes[x])
                break
            case 1:
                canvas.penStroke(strokes[x])
                break
            case 2:
                canvas.paintStroke(strokes[x])
            }
        }
    }

    function ballpointStroke(stroke) {
        context.strokeStyle = paperDefine.stroke_color[stroke.color]
        context.lineWidth = stroke.size
        context.lineCap = "round"

        context.beginPath()
        context.moveTo(stroke.prePos.x, stroke.prePos.y)
        context.lineTo(stroke.pos.x, stroke.pos.y)
        context.stroke()
        requestPaint()
        resize(stroke)
    }

    function penStroke(stroke) {
//        console.log("penStroke")
        var dx = stroke.pos.x - stroke.prePos.x
        var dy = stroke.pos.y - stroke.prePos.y
        var dist = Math.pow(dx * dx + dy * dy, 0.5)

        context.beginPath()
        context.fillStyle = paperDefine.stroke_color[stroke.color]
        var r1 = Math.atan2(dy, dx)
        var radius = stroke.size / 2
        var preRadius = stroke.preSize / 2
        var minRadius = Math.min(radius, preRadius)
        var maxRadius = Math.max(radius, preRadius)
        if (dist + minRadius <= maxRadius) {
            if (radius === maxRadius)
                context.arc(stroke.pos.x, stroke.pos.y, stroke.size / 2, 0,
                            2 * Math.PI)
            else
                context.arc(stroke.prePos.x, stroke.prePos.y,
                            stroke.preSize / 2, 0, 2 * Math.PI)
        } else {
            var sr = Math.acos((maxRadius - minRadius) / dist)
            context.arc(stroke.prePos.x, stroke.prePos.y, stroke.size / 2,
                        r1 - sr, r1 + sr, true)
            context.arc(stroke.pos.x, stroke.pos.y, stroke.preSize / 2,
                        r1 + sr, r1 - sr, true)
            context.closePath()
        }
        context.fill()

        requestPaint()
        resize(stroke)
    }

    function paintStroke(stroke) {
//        console.log("paintStroke", stroke.shade)
        var strokeSpacing = Math.max(stroke.size / (stroke.shade * 5), 0.01)

        var dx = stroke.pos.x - stroke.prePos.x
        var dy = stroke.pos.y - stroke.prePos.y
        var rd = Math.atan2(dy, dx)
        var _x = stroke.prePos.x
        var _dx = Math.cos(rd) * strokeSpacing
        var _y = stroke.prePos.y
        var _dy = Math.sin(rd) * strokeSpacing
        var brush = paperDefine.stroke_brush[stroke.color]

        var dist = Math.pow(dx * dx + dy * dy, 0.5)
        var brushCount = dist / strokeSpacing
        var c = Math.pow(stroke.size / stroke.preSize, 1 / (brushCount || 1))
        var brushSize = stroke.preSize

        for (var i = 0; i < brushCount; i++) {
            var ws = brushSize * (Math.random() * 0.5 + 0.5)
            var hs = brushSize * (Math.random() * 0.5 + 0.5)
            var rand = Math.floor(Math.random() * 4)
            context.drawImage(brush, rand * 64, 0, 64, 64,
                              _x - brushSize / 2, _y - brushSize / 2,
                              brushSize, brushSize)
            brushSize = brushSize * c
            _x += _dx
            _y += _dy
        }

        requestPaint()
        resize(stroke)
    }

    Connections {
        target: HWR
        onRemoteSignal: {
            if (obj !== "Handwritten" || sig !== "stroke" || args[0] !== hwID)
                return

            switch (args[1].type) {
            case 0:
                ballpointStroke(args[1])
                break
            case 1:
                penStroke(args[1])
                break
            case 2:
                paintStroke(args[1])
                break
            }
        }
    }

    function initial(sopid, realtime) {
        return HWR.getPaperDefine(sopid, paperType,
                                  realtime).then(function (ret) {
                                      if (ret === false)
                                          paperDefine.initial(-1)
                                      else
                                          paperDefine.initial(ret)

                                      paperDefineChanged()

                                      return Promise.resolve(ret)
                                  })
    }
}
