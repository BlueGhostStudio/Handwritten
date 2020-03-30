import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Layouts 1.13
import Handwritten 1.1
import "qrc:/Components/Ui" as UI

ColumnLayout {
    property HWPaint paint
    property var strokeType: bgPen.checkedButton.value
    property var strokeSize: bgPenSize.checkedButton.value
    property var color: bgColor.checkedButton.value

    ButtonGroup {
        id: bgColor
        exclusive: true
    }
    ButtonGroup {
        id: bgPen
        exclusive: true
    }
    ButtonGroup {
        id: bgPenSize
        exclusive: true
    }

    RowLayout {
        Layout.alignment: Qt.AlignCenter
        UI.ColorButton {
            paperDefine: paint.paperDefine
            ButtonGroup.group: bgColor
            checked: true
            value: 0
        }
        UI.ColorButton {
            paperDefine: paint.paperDefine
            ButtonGroup.group: bgColor
            value: 1
        }
        UI.ColorButton {
            paperDefine: paint.paperDefine
            ButtonGroup.group: bgColor
            value: 2
        }
    }

    RowLayout {
        Layout.alignment: Qt.AlignCenter
        UI.PenButton {
            ButtonGroup.group: bgPen
            icon.source: "qrc:/icons/ballPointPen.png"
            value: 0
            checked: true
        }

        UI.PenButton {
            ButtonGroup.group: bgPen
            icon.source: "qrc:/icons/pen.png"
            value: 1
        }

        UI.PenButton {
            ButtonGroup.group: bgPen
            icon.source: "qrc:/icons/paint.png"
            value: 2
        }
    }

    RowLayout {
        Layout.alignment: Qt.AlignCenter
        UI.PenButton {
            ButtonGroup.group: bgPenSize
            icon.source: "qrc:/icons/thin.png"
            value: 0
            checked: true
        }
        UI.PenButton {
            ButtonGroup.group: bgPenSize
            icon.source: "qrc:/icons/thick.png"
            value: 1
        }
    }

    Component.onCompleted: {
        paint.strokeType = Qt.binding(function () {
            return strokeType
        })
        paint.strokeSize = Qt.binding(function () {
            return strokeSize
        })
        paint.color = Qt.binding(function () {
            return color
        })
    }
}
