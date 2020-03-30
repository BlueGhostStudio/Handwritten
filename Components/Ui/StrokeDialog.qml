import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Layouts 1.13
import Handwritten 1.1
import "qrc:/Components/Ui" as UI

/*Page*/Dialog {
    id: dlgStroke
    anchors.centerIn: overlay
    property alias paint: form.paint
    property alias strokeType: form.strokeType
    property alias strokeSize: form.strokeSize
    property alias color: form.color
//    property var strokeType: bgPen.checkedButton.value
//    property var strokeSize: bgPenSize.checkedButton.value
//    property var color: bgColor.checkedButton.value

//    property alias extendedArea: rlExtend.children
//    property var vguide: !cbHGuide.checked
    
    modal: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    StrokeForm {
        id: form
    }

//    Component.onCompleted: {
//        paint.strokeType = Qt.binding(function () {
//            return strokeType
//        })
//        paint.strokeSize = Qt.binding(function () {
//            return strokeSize
//        })
//        paint.color = Qt.binding(function () {
//            return color
//        })
//    }
}
