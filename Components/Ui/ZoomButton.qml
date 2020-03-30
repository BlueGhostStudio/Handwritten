import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import Handwritten 1.1
import "qrc:/Components/Ui" as UI

/*Page*/UI.ToolButton {
    property HWPaint paint
    icon.source: paint.zoom === 0 ? "qrc:/icons/zoomIn.png" : "qrc:/icons/zoom_1.png"
    highlighted: paint.state === "zooming"
    Menu {
        id: zoomMenu
        MenuItem {
            text: qsTr("Zoom to Actual Size")
            onTriggered: paint.zoom2ActualSize()
        }
        MenuItem {
            text: qsTr("Zoom in")
            onTriggered: paint.state = "zooming"
        }
        MenuItem {
            text: qsTr("Zoom to fit width")
            onTriggered: paint.zoom2FitWidth()
        }
    }

    onClicked: {
        if (paint.state === "zooming")
            paint.state = ""
        else if (paint.zoom === 0)
            paint.state = "zooming"
        else
            paint.zoom2ActualSize()
    }

    onPressAndHold: zoomMenu.popup(this)
}
