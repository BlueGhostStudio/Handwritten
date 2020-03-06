import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import Handwritten 1.1

import "qrc:/Components/Ui" as UI

ColumnLayout {
    spacing: 0
    Label {
        text: qsTr("Stroke")
        font.bold: true
    }
    GridLayout {
        columns: 5
        rowSpacing: 0
        Label {
            id: labSize
            Layout.rowSpan: 2
            text: qsTr("Size")
        }
        Label {
            Layout.columnSpan: 2
            Layout.fillWidth: true
            text: qsTr("Size 0")
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            font.pixelSize: labSize.font.pixelSize * 0.75
            font.bold: true
        }
        Label {
            Layout.columnSpan: 2
            Layout.fillWidth: true
            text: qsTr("Size 1")
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            font.pixelSize: labSize.font.pixelSize * 0.75
            font.bold: true
        }
        Label {
            Layout.fillWidth: true
            text: qsTr("Minimum")
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            font.pixelSize: labSize.font.pixelSize * 0.75
            font.bold: true
        }
        Label {
            Layout.fillWidth: true
            text: qsTr("Maximum")
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            font.pixelSize: labSize.font.pixelSize * 0.75
            font.bold: true
        }
        Label {
            Layout.fillWidth: true
            text: qsTr("Minimum")
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            font.pixelSize: labSize.font.pixelSize * 0.75
            font.bold: true
        }
        Label {
            Layout.fillWidth: true
            text: qsTr("Maximum")
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            font.pixelSize: labSize.font.pixelSize * 0.75
            font.bold: true
        }

        Label {
            text: qsTr("Ball Point Pen")
            font.pixelSize: labSize.font.pixelSize * 0.75
        }
        UI.NumberField {
            id: nfBppSize0
            Layout.columnSpan: 2
            Layout.fillWidth: true
            text: Properties.stroke.ballPointPen[0]
        }
        UI.NumberField {
            id: nfBppSize1
            Layout.columnSpan: 2
            Layout.fillWidth: true
            text: Properties.stroke.ballPointPen[1]
        }

        Label {
            text: qsTr("Pen")
            font.pixelSize: labSize.font.pixelSize * 0.75
        }
        UI.NumberField {
            id: nfPenSize0Min
            Layout.fillWidth: true
            text: Properties.stroke.pen[0]
        }
        UI.NumberField {
            id: nfPenSize0Max
            Layout.fillWidth: true
            text: Properties.stroke.pen[1]
        }
        UI.NumberField {
            id: nfPenSize1Min
            Layout.fillWidth: true
            text: Properties.stroke.pen[2]
        }
        UI.NumberField {
            id: nfPenSize1Max
            Layout.fillWidth: true
            text: Properties.stroke.pen[3]
        }

        Label {
            text: qsTr("Paint")
            font.pixelSize: labSize.font.pixelSize * 0.75
        }
        UI.NumberField {
            id: nfPaintSizer0Min
            Layout.fillWidth: true
            text: Properties.stroke.paint[0]
        }
        UI.NumberField {
            id: nfPaintSizer0Max
            Layout.fillWidth: true
            text: Properties.stroke.paint[1]
        }
        UI.NumberField {
            id: nfPaintSizer1Min
            Layout.fillWidth: true
            text: Properties.stroke.paint[2]
        }
        UI.NumberField {
            id: nfPaintSizer1Max
            Layout.fillWidth: true
            text: Properties.stroke.paint[3]
        }
    }
    GridLayout {
        columns: 3
        Label {
            text: qsTr("shade")
        }
        UI.NumberField {
            id: nfShadeMin
            text: Properties.stroke.shade[0]
        }
        UI.NumberField {
            id: nfShadeMax
            text: Properties.stroke.shade[1]
        }
    }

    Label {
        Layout.topMargin: font.pixelSize
        text: qsTr("Writting")
        font.bold: true
    }
    GridLayout {
        id: glWritting
        columns: 3
        ButtonGroup { id: bgPressure }
        Label {
            text: qsTr("Pressure")
        }
        UI.NumberField {
            id: nfPressureMin
            Layout.fillWidth: true
            text: Properties.writting.pressure[0]
        }
        UI.NumberField {
            id: nfPressureMax
            Layout.fillWidth: true
            text: Properties.writting.pressure[1]
        }
        Label {
            Layout.rowSpan: 2
            text: qsTr("Pressure detection")
        }
        RadioButton {
            id: rbMinP
            text: qsTr("Minimum")
            ButtonGroup.group: bgPressure
            checked: true
        }
        RadioButton {
            id: rbMaxP
            text: qsTr("Maximum")
            ButtonGroup.group: bgPressure
        }
        MultiPointTouchArea {
            id: mptaPressure
            Layout.columnSpan: 2
            Layout.fillWidth: true
            implicitHeight: 128
            touchPoints: [ TouchPoint { id: point1 } ]
            onTouchUpdated: {
                if (rbMinP.checked) {
                    nfPressureMin.text = Math.round(point1.pressure * 1000) / 1000
                } else {
                    nfPressureMax.text = Math.max(Number(nfPressureMin.text), Math.round(point1.pressure * 1000) / 1000)
                }
            }
        }
    }

    Label {
        Layout.topMargin: font.pixelSize
        text: qsTr("Miscellaneous")
        font.bold: true
    }
    GridLayout {
        columns: 3
        Label {
            text: qsTr("Zoom Factor")
        }
        UI.NumberField {
            id: nfZoom
            Layout.columnSpan: 2
            Layout.fillWidth: true
            text: Properties.mis.zoomFactor
        }
        Rectangle {
            Layout.columnSpan: 3
            implicitHeight: childrenRect.height + 10
            implicitWidth: 378 * Number(nfPaperRatio.text)
            color: "#666666"

            Label {
                anchors.centerIn: parent
                text: parent.implicitWidth + qsTr("pixel") + "/" + 100 + qsTr("mm")
                color: "white"
            }
        }
        Label {
            text: qsTr("Paper Ratio")
        }
        UI.NumberField {
            id: nfPaperRatio
            Layout.columnSpan: 2
            Layout.fillWidth: true
            text: Properties.mis.paperRatio
        }
    }

    function accept () {
        Properties.stroke.shade = [Number(nfShadeMin.text), Number(nfShadeMax.text)]
        Properties.stroke.ballPointPen = [Number(nfBppSize0.text), Number(nfBppSize1.text)]
        Properties.stroke.pen = [Number(nfPenSize0Min.text), Number(nfPenSize0Max.text), Number(nfPenSize1Min.text), Number(nfPenSize1Max.text)]
        Properties.stroke.paint = [Number(nfPaintSizer0Min.text), Number(nfPaintSizer0Max.text), Number(nfPaintSizer1Min.text), Number(nfPaintSizer1Max.text)]
        Properties.writting.pressure = [Number(nfPressureMin.text), Number(nfPressureMax.text)]
        Properties.mis.zoomFactor = Number(nfZoom.text)
        Properties.mis.paperRatio = Number(nfPaperRatio.text)
    }
}
