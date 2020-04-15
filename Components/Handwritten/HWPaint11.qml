import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import "HWColor.js" as HWC

Flickable {
    id: root
    property HWCanvas canvas/*: HWCanvas {
        anchors.fill: parent
        //        hwType: 0//root.hwType
        hwID: root.hwID
        //        paperDefine: root.paperDefine
        z: -1
    }*/

    property var hwInterface: canvas.hwInterface
    property bool writeMode: false // 0 view 1 write
    property bool paintEnabled: true
    property int hwType: canvas.hwType
    property var hwID
    property int strokeType: 0
    property int strokeSize: 1
    property int color: 0
    property StrokeDefine strokeDefine: StrokeDefine {}
    property PaperDefine paperDefine: canvas.paperDefine
    property bool vguide: true
    property bool enabledGuide: true
    property bool sync: false
    property bool autoScroll: true
    property int edgesMargin: Properties.edges.scaleWithZoom ? Properties.edges.margin * canvasWrap.scale : Properties.edges.margin
    property real hScrollRatio: Properties.scroll.horizontalRatio

    property var showScrollbarOS: ["linux", "windows", "unix", "osx"]

    signal topLeftClicked
    signal topRightClicked
    signal bottomRightClicked
    signal bottomLeftClicked

    property int zoom: 0

    clip: true

    state: ""

    contentWidth: canvasWrap.width * canvasWrap.scale //(zoom === 0 ? Properties.mis.paperRatio : Properties.mis.zoomFactor)
    contentHeight: canvasWrap.height * canvasWrap.scale //(zoom === 0 ? Properties.mis.paperRatio : Properties.mis.zoomFactor)
    interactive: false

    QtObject {
        id: pre
        property var pos
        property var size
    }

    NumberAnimation on contentX {
        id: naScrollX
    }
    NumberAnimation on contentY {
        id: naScrollY
    }

    Item {
        id: canvasWrap

        width: canvas.paperDefine.width //canvas.canvasSize.width
        height: canvas.paperDefine.height //canvas.canvasSize.height
        transformOrigin: Item.TopLeft
        scale: /*Properties.mis.paperRatio*/ {
            switch (zoom) {
            case 0:
                Properties.mis.paperRatio
                break
            case 1:
                Properties.mis.zoomFactor
                break
            case 2:
                root.width / canvas.paperDefine.width
                break
            }
        }

        MultiPointTouchArea {
            id: mpta
            anchors.fill: parent
            property var beginPos

            touchPoints: [
                TouchPoint {
                    id: point1
                },
                TouchPoint {
                    id: point2
                }
            ]
            mouseEnabled: true

            onPressed: {
                naScrollX.stop()
                naScrollY.stop()
                if (root.state === "zooming") {
                    zoomIn(point1.x, point1.y)
                }
            }
            onReleased: {
                if ((root.state === "readyToWrite"
                     || (!writeMode
                         && root.state === "readyToPan")) /* && autoScroll*/
                        ) {
                    var ca = clickedArea(point1)
                    scrollUp(ca)
                    scrollRight(ca)
                    scrollDown(ca)
                    scrollLeft(ca)

                    topLeftCorner(ca)
                    topRightCorner(ca)
                    bottomRightCorner(ca)
                    bottomLeftCorner(ca)
                }
                //                    trAutoScroll.restart()
                root.state = ""
            }
            onTouchUpdated: {
                function pan() {
                    if (root.state === "readyToPan"
                            || root.state === "panning") {
                        root.state = "panning"
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
                    } else if (root.state === "" || writeMode) {
                        root.state = "readyToPan"
                        beginPos = {
                            "x": point1.x,
                            "y": point1.y
                        }
                    }
                }

                if (point1.pressed && point2.pressed) {
                    pan()
                } else if (point1.pressed) {
                    if (writeMode && paintEnabled) {
                        if (root.state === "") {
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
                                pre.size = calcStrokeSize(
                                            strokeDefine.pen[strokeSize * 2],
                                            strokeDefine.pen[strokeSize * 2 + 1])
                                break
                            case 2:
                                pre.size = calcStrokeSize(
                                            strokeDefine.paint[strokeSize * 2],
                                            strokeDefine.paint[strokeSize * 2 + 1])
                                break
                            }
                        } else if (root.state === "readyToWrite"
                                   || root.state === "writting") {
                            var dx = point1.x - pre.pos.x
                            var dy = point1.y - pre.pos.y
                            var dist = Math.pow(dx * dx + dy * dy, 0.5)

                            if (root.state === "readyToWrite" && dist < 2)
                                return

                            root.state = "writting"

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
                                stroke.size = calcStrokeSize(strokeType === 1 ? strokeDefine.pen[strokeSize * 2] : strokeDefine.paint[strokeSize * 2], strokeType === 1 ? strokeDefine.pen[strokeSize * 2 + 1] : strokeDefine.paint[strokeSize * 2 + 1], pre.size,
                                                             dist)
                                stroke.preSize = pre.size
                                stroke.shade = Number(
                                            strokeDefine.shade[strokeSize])
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

                            hwInterface.write(hwID, stroke, sync)
                        }
                    } else {
                        pan()
                    }
                }
            }

            function calcStrokeSize(minSize, maxSize, preSize, dist) {
                minSize = Number(minSize)
                maxSize = Number(maxSize)
                var minPressure = Properties.writting.pressure[0]
                var maxPressure = Properties.writting.pressure[1]
                if (point1.pressure >= 0) {
                    var a = maxPressure - minPressure
                    var b = Math.min(Math.max(point1.pressure, minPressure),
                                     maxPressure) - minPressure
                    var c = maxSize - minSize
                    //                    c/a = x/b
                    return Math.round((minSize + b / a * c) * 100) / 100
                    //                    return point1.pressure * 20//0.2 / 4 = point1.pressure / x
                } else {
                    var md = 3.34 /*11.84*/
                    /*33.4*/
                    var d = dist || md
                    var p = 1 - Math.min(d, md) / md
                    var s = (maxSize - minSize) * p + minSize
                    if (!preSize)
                        return s
                    else if (s > preSize) {
                        return Math.min(s, preSize * 1.5)
                    } else {
                        return Math.max(s, preSize * 0.5)
                    }

                }
            }
        }
    }

    //    onVguideChanged: guidelines.requestPaint()


    /*function initial() {
        canvas.enabled = false
        return canvas.initial(hwID).then(function (ret) {
            if (ret !== false && ret.stroke.length > 0)
                strokeDefine.initial(ret.stroke)
            else
                strokeDefine.initial(-1)
            canvas.enabled = true

            return Promise.resolve(123)
        })
    }*/
    function initialStroke(sd) {
        strokeDefine.initial(sd ? sd : -1)
        strokeDefineChanged()

        return Promise.resolve()
    }
    function initialPaper(pd) {
        return canvas.initialPaper(pd)
    }

    function pointScrollToCenter(r) {
        var cd = contentWidth
        var cf = contentX + root.width / 2
        var fd = cd - cf
        var ab = cd * /*Properties.mis.paperRatio*/ r / canvasWrap.scale
        var r1 = cf / fd
        var ae = ab / (1 / r1 + 1)
        contentX = ae - root.width / 2

        var CD = contentHeight
        var CF = contentY + root.height / 2
        var FD = CD - CF
        var AB = CD * /*Properties.mis.paperRatio*/ r / canvasWrap.scale
        var R1 = CF / FD
        var AE = AB / (1 / R1 + 1)
        contentY = AE - root.height / 2
    }

    function zoom2ActualSize() {
        if (zoom !== 0) {

            var r = Properties.mis.paperRatio
            pointScrollToCenter(r)
            zoom = 0
            Math.min(Math.max(contentX, 0), contentWidth - width)
            Math.min(Math.max(contentY, 0), contentHeight - height)
            //            canvasWrap.scale = r
        }
    }

    function zoomIn(cx, cy) {
        if (zoom !== 1) {
            //            canvasWrap.scale = Properties.mis.zoomFactor
            zoom = 1
            contentX = Math.min(Math.max((cx - 16) * Properties.mis.zoomFactor,
                                         0),
                                contentWidth - width) // - width * 0.25
            contentY = Math.min(Math.max((cy - 16) * Properties.mis.zoomFactor,
                                         0),
                                contentHeight - height) // - height * 0.25
            //            zoom = 1
        }
        //        state = ""
    }

    function zoom2FitWidth() {
        if (zoom !== 2) {
            pointScrollToCenter(root.width / canvas.paperDefine.width)
            zoom = 2
            contentX = 0
            contentY = Math.min(Math.max(contentY, 0), contentHeight - height)
        }
    }

    function clickedArea(p) {
        var px = p.x >= 0 ? p.x * canvasWrap.scale - contentX : NaN
        var py = p.y >= 0 ? p.y * canvasWrap.scale - contentY : NaN
        var l = p.x === -2 || (p.x !== -1
                               && px < edgesMargin /* * canvasWrap.scale*/
                               )
        var t = p.y === -2 || (p.y !== -1
                               && py < edgesMargin /* * canvasWrap.scale*/
                               )
        var r = p.x === -3
                || (p.x !== -1
                    && px > width - edgesMargin /* * canvasWrap.scale*/
                    )
        var b = p.y === -3
                || (p.y !== -1
                    && py > height - edgesMargin /* * canvasWrap.scale*/
                    )

        var d = -1
        if (l && t)
            d = 7
        else if (t && r)
            d = 1
        else if (r && b)
            d = 3
        else if (b && l)
            d = 5
        else if (t)
            d = 0
        else if (r)
            d = 2
        else if (b)
            d = 4
        else if (l)
            d = 6

        return {
            "d": d,
            "px": px,
            "py": py
        }
    }

    function scrollRight(ca) {
        if (ca.d === 2) {
            var r = contentX + width * hScrollRatio /*ca.px - edgesMargin*/
            /* * canvasWrap.scale*/
            if (r + width < contentWidth)
                naScrollX.to = r
            else
                naScrollX.to = contentWidth - width

            naScrollX.restart()
        }
    }
    function scrollLeft(ca) {
        if (ca.d === 6) {
            var l = contentX - width * hScrollRatio /*(width - ca.px) + edgesMargin*/
            /* * canvasWrap.scale*/
            if (l > 0)
                naScrollX.to = l
            else
                naScrollX.to = 0

            naScrollX.restart()
        }
    }
    function scrollDown(ca) {
        if (ca.d === 4) {
            var b = contentY + canvas.paperDefine.lineHeight * canvasWrap.scale
            if (b + height < contentHeight)
                naScrollY.to = b
            else
                naScrollY.to = contentHeight - height
            naScrollY.restart()
        }
    }
    function scrollUp(ca) {
        if (ca.d === 0) {
            var u = contentY - canvas.paperDefine.lineHeight * canvasWrap.scale
            if (u > 0)
                naScrollY.to = u
            else
                naScrollY.to = 0

            naScrollY.restart()
        }
    }

    function scroll2LeftSide() {
        var l = paperDefine.paperPadding[2] * canvasWrap.scale
        if (l + width < contentWidth)
            naScrollX.to = l
        else
            naScrollX.to = contentWidth - width
        naScrollX.restart()
    }

    function scroll2RightSide() {
        var r = contentWidth - width - paperDefine.paperPadding[3] * canvasWrap.scale
        if (r > 0)
            naScrollX.to = r
        else
            naScrollX.to = 0
        naScrollX.restart()
    }

    function scroll2TopSide() {
        var t = paperDefine.paperPadding[0] * canvasWrap.scale
        if (t + height < contentHeight)
            naScrollY.to = t
        else
            naScrollY.to = contentHeight - height
        naScrollY.restart()
    }

    function scroll2BottomSide() {
        var b = contentHeight - height - paperDefine.paperPadding[1] * canvasWrap.scale
        if (b > 0)
            naScrollY.to = b
        else
            naScrollY.to = 0
        naScrollY.restart()
    }

    function newLine() {
        scroll2LeftSide()
        scrollDown(clickedArea({
                                   "x": -1,
                                   "y": -3
                               }))
    }

    function topLeftCorner(ca) {
        if (ca.d === 7)
            topLeftClicked()
    }
    function topRightCorner(ca) {
        if (ca.d === 1)
            topRightClicked()
    }
    function bottomRightCorner(ca) {
        if (ca.d === 3)
            bottomRightClicked()
    }
    function bottomLeftCorner(ca) {
        if (ca.d === 5)
            bottomLeftClicked()
    }


    Component.onCompleted: {
        canvas.parent = canvasWrap
//        canvas.hwID = Qt.binding(()=>{ return hwID })
    }
}
