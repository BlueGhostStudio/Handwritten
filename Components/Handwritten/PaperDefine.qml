import QtQuick 2.13

QtObject {
    property int width: 266
    property int height: 266
    property var stroke_color
    property var stroke_color_draft
    property list<Image> stroke_brush: [
        Image {},
        Image {},
        Image {}
    ]
    property var background_color
    property var background_image: ""

    function initial (define) {
        console.log("---->", Properties.paper.stroke_brush[0])
        if (define === -1) {
            stroke_color = Properties.paper.stroke_color
            stroke_color_draft = Properties.paper.stroke_color_draft
            stroke_brush[0].source = Properties.paper.stroke_brush[0]
            stroke_brush[1].source = Properties.paper.stroke_brush[1]
            stroke_brush[2].source = Properties.paper.stroke_brush[2]
        } else {
            define = JSON.parse(define.paper)
            width = define.width
            height = define.height
            stroke_color = define.stroke_color
            stroke_brush[0].source = define.stroke_brush[0]
            stroke_brush[1].source = define.stroke_brush[1]
            stroke_brush[2].source = define.stroke_brush[2]
            background_color = define.background_color
            background_image = define.background_image
        }
    }
}
