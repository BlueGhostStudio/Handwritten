import QtQuick 2.13
import Qt.labs.platform 1.0
import "HWColor.js" as HWC

/*Canvas*/Item {
    id: root
    property var hwID
    property var range: [Number.MAX_VALUE, Number.MAX_VALUE, 0, 0]
    property int hwType: 0
    property bool paperStretch: false
    property alias canvas: canvas
    property alias available: canvas.available

    property var hwInterface: QtObject {
        signal strokeUpdated(int sHwType, var sHwID, var sHwStroke)
    }
        /*: SOP*/

    objectName: "HWCanvas"

    /*property string paperType: {
        switch (hwType) {
        case 0:
            "SlipOfPaper"
            break;
        case 1:
            "Letter"
            break;
        case 2:
            "Manuscript"
        }
    }*/
    property PaperDefine paperDefine: PaperDefine {}
    Canvas {
        id: canvas
        width: canvasSize.width
        height: canvasSize.height
        canvasSize.width: Math.max(paperDefine.width, 794)
        canvasSize.height: Math.max(paperDefine.height, 1123)
        renderStrategy: Canvas.Threaded
        contextType: "2d"
    }

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
        fillMode: paperStretch ? Image.Stretch : Image.Tile
        anchors.fill: parent
        z: -1
        source: paperDefine.background_image || ""
    }

    function clear () {
        var ctx = canvas.getContext("2d")
        /*canvas.context*/ctx.clearRect(0, 0, canvas.canvasSize.width, canvas.canvasSize.height)
        canvas.requestPaint()
    }

    function resetRange () {
        range = [Number.MAX_VALUE, Number.MAX_VALUE, 0, 0]
    }

    function resize(stroke) {
        var prePos = stroke.prePos
        var pos = stroke.pos
        range = [Math.max(Math.min(range[0], prePos.x, pos.x), 0),
                 Math.max(Math.min(range[1], prePos.y, pos.y), 0),
                 Math.min(Math.max(range[2], prePos.x, pos.x), width),
                 Math.min(Math.max(range[3], prePos.y, pos.y), height)]
    }

    function drawStrokes(strokes) {
        for (var x in strokes) {
            switch(strokes[x].type) {
            case 0:
                root.ballpointStroke(strokes[x])
                break
            case 1:
                root.penStroke(strokes[x])
                break
            case 2:
                root.paintStroke(strokes[x])
            }
        }
    }

    function ballpointStroke(stroke) {
        var ctx = canvas.getContext("2d")
        /*canvas.context*/ctx.strokeStyle = paperDefine.stroke_color[stroke.color]
        /*canvas.context*/ctx.lineWidth = stroke.size
        /*canvas.context*/ctx.lineCap = "round"

        /*canvas.context*/ctx.beginPath()
        /*canvas.context*/ctx.moveTo(stroke.prePos.x, stroke.prePos.y)
        /*canvas.context*/ctx.lineTo(stroke.pos.x, stroke.pos.y)
        /*canvas.context*/ctx.stroke()
        canvas.requestPaint()
        resize(stroke)
    }

    function penStroke(stroke) {
        var dx = stroke.pos.x - stroke.prePos.x
        var dy = stroke.pos.y - stroke.prePos.y
        var dist = Math.pow(dx * dx + dy * dy, 0.5)

        var ctx = canvas.getContext("2d")
        /*canvas.context*/ctx.beginPath()
        /*canvas.context*/ctx.fillStyle = paperDefine.stroke_color[stroke.color]
        var r1 = Math.atan2(dy, dx)
        var radius = stroke.size / 2
        var preRadius = stroke.preSize / 2
        var minRadius = Math.min(radius, preRadius)
        var maxRadius = Math.max(radius, preRadius)
        if (dist + minRadius <= maxRadius) {
            if (radius === maxRadius)
                /*canvas.context*/ctx.arc(stroke.pos.x, stroke.pos.y, stroke.size / 2, 0,
                            2 * Math.PI)
            else
                /*canvas.context*/ctx.arc(stroke.prePos.x, stroke.prePos.y,
                            stroke.preSize / 2, 0, 2 * Math.PI)
        } else {
            var sr = Math.acos((maxRadius - minRadius) / dist)
            /*canvas.context*/ctx.arc(stroke.prePos.x, stroke.prePos.y, stroke.preSize / 2,
                        r1 - sr, r1 + sr, true)
            /*canvas.context*/ctx.arc(stroke.pos.x, stroke.pos.y, stroke.size / 2,
                        r1 + sr, r1 - sr, true)
            /*canvas.context*/ctx.closePath()
        }
        /*canvas.context*/ctx.fill()

        canvas.requestPaint()
        resize(stroke)
    }

    function paintStroke(stroke) {
        var ctx = canvas.getContext("2d")
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
            /*canvas.context*/ctx.drawImage(brush, rand * 64, 0, 64, 64,
                              _x - brushSize / 2, _y - brushSize / 2,
                              brushSize, brushSize)
            brushSize = brushSize * c
            _x += _dx
            _y += _dy
        }

        canvas.requestPaint()
        resize(stroke)
    }

    function saveToImage() {
        var url = StandardPaths.writableLocation(StandardPaths.PicturesLocation) + "/Handwritten.png"
        url = url.replace(/^file:\/\//, '')
        canvas.save(url)
    }

    Connections {
        target: hwInterface
        onStrokeUpdated: {
            if (sHwType !== hwType || sHwID !== hwID)
                return

            switch (sHwStroke.type) {
            case 0:
                ballpointStroke(sHwStroke)
                break
            case 1:
                penStroke(sHwStroke)
                break
            case 2:
                paintStroke(sHwStroke)
                break
            }
        }
    }
    function initialPaper(pd) {
        paperDefine.initial(pd ? pd : -1)
        paperDefineChanged()

        return Promise.resolve()
    }
}
