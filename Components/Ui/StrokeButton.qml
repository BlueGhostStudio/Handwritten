import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import Handwritten 1.1
import "qrc:/Components/Ui" as UI

PaperButton {
    id: button
    property var strokeControler: StrokeDialog {
        objectName: "defaultStrokeDialog"
//        paint: button.paint
    }
    property HWPaint paint
    paperDefine: paint.paperDefine
    property var strokeType: strokeControler.strokeType
    property var strokeSize: strokeControler.strokeSize
    property var color: strokeControler.color
//    property alias extendedArea: dlgStroke.extendedArea
//    property alias vguide: dlgStroke.vguide

    icon.source: {
        switch (paint.strokeType) {
        case 0:
            "qrc:/icons/ballPointPen.png"
            break
        case 1:
            "qrc:/icons/pen.png"
            break
        case 2:
            "qrc:/icons/paint.png"
        }
    }
    icon.color: paperDefine.stroke_color[paint.color]
    bgColorRect.border.color: icon.color
    bgColorRect.border.width: paint.strokeSize === 0 ? 1 : 3

    /*StrokeDialog {
        id: dlgStroke
    }*/
    
    onClicked: {
        if (strokeControler.objectName === "defaultStrokeDialog")
            strokeControler.open()
    }

    Component.onCompleted: strokeControler.paint = paint
}
