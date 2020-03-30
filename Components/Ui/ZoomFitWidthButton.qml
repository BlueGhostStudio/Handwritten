import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import Handwritten 1.1
import "qrc:/Components/Ui" as UI

UI.ToolButton {
    property HWPaint paint
    icon.source: "qrc:/icons/zoomFitWidth.png"
    onClicked: paint.zoom2FitWidth()
}
