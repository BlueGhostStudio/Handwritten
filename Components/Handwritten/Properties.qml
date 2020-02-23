pragma Singleton
import QtQuick 2.13
import Qt.labs.settings 1.0

QtObject {
    property Settings stroke: Settings {
        category: "stroke"
        property var shade: [2, 2]
        property var len: [3, 3, 3, 3]
        property var ampFactor: [1.0025, 1.004, 1.25, 1.25]
        property var redFactor: [0.75, 0.5, 0.4, 0.5]
        property var maxAmp: [2, 1.5, 1.7, 1.5]
        property var minRed: [0.5, 0.1, 0.1, 0.1]
        property var ballPointPen: [1, 3]
        property var pen: [0.5, 2.5]
        property var paint: [2, 4]
    }
    property Settings paper: Settings {
        category: "paper"
        property var stroke_color: ["#000000", "#143c77", "#9d0000"]
//        property var stroke_color_draft: ["#66000000", "#66143c77", "#669d0000"]
        property var stroke_brush: [
            "imgs/brush-black.png",
            "imgs/brush-blue.png",
            "imgs/brush-red.png"
        ]
    }
    property Settings mis: Settings {
        category: "mis"
        property int zoomFactor: 4
        property real panFactor: 1
    }
}
