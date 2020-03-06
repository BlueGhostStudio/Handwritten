import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Layouts 1.13
import Handwritten 1.1
import "qrc:/Components/Ui" as UI

/*Page*/UI.SubPage {
    id: root
    property alias to: tfTo.text

    title: qsTr("Slip of Paper") + " - " + qsTr("To") + ": " + to

    extendedArea: [
        UI.PaperButton {
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
            paperDefine: paint.paperDefine
            icon.color: paperDefine.stroke_color[paint.color]
            bgColorRect.border.color: icon.color
            bgColorRect.border.width: paint.strokeSize === 0 ? 1 : 3
            visible: stackLayout.currentIndex === 1

            onClicked: dlgStroke.open()
        },
        UI.ToolButton {
            icon.source: paint.zoom === uiRatio ? "qrc:/icons/zoomIn.png" : "qrc:/icons/zoom_1.png"
            visible: stackLayout.currentIndex === 1
            highlighted: paint.state === "zooming"
            onClicked: {
                if (paint.zoom === uiRatio)
                    paint.state = "zooming"
                else
                    paint.zoomOut(uiRatio)
            }
        },
        UI.ToolButton {
            icon.source: "qrc:/icons/settings.png"
            onClicked: {
                openSettingsPage()
            }
        }

    ]
    
    Dialog {
        id: dlgStroke
        anchors.centerIn: overlay

        modal: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
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
        ColumnLayout {
            RowLayout {
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
        }
    }

    SwipeView {
        id: stackLayout
        anchors.fill: parent
        interactive: false

        Item {
            id: element

            Item {
                x: parent.width * 0.335 - width / 2
                anchors.verticalCenter: parent.top
                anchors.verticalCenterOffset: parent.height * 0.33
                width: childrenRect.width
                height: childrenRect.height
                TextField {
                    id: tfTo
                    width: 128
                    placeholderText: "To"
                }
                PaperSelector {
                    id: paperSelector
                    anchors.top: tfTo.bottom
                    anchors.horizontalCenter: tfTo.horizontalCenter
                    width: 128
                    height: 64
                }
                CheckBox {
                    id: cbHGuide
                    anchors.horizontalCenter: paperSelector.horizontalCenter
                    anchors.top: paperSelector.bottom
                    checked: true
                    text: qsTr("Horizontal Guide")
                }
                Button {
                    anchors.horizontalCenter: cbHGuide.horizontalCenter
                    anchors.top: cbHGuide.bottom
                    text: qsTr("Create Slip of Paper")
                    onClicked: {
                        HWR.createSlipOfPaper(tfTo.text, paperSelector.paperType).then(function (sopid) {
                            paint.hwID = sopid
                            return paint.initial()
                        }).then(function () {
                            paint.zoomOut(uiRatio)
                            stackLayout.currentIndex = 1
                            backBtn.icon.source = "qrc:/icons/send.png"
                        })
                    }
                }
            }

            Rectangle {
                x: parent.width - width
                width: parent.width * 0.33
                height: parent.height
            }
        }

        HWPaint {
            id: paint
            hwType: 0
            strokeType: bgPen.checkedButton.value
            strokeSize: bgPenSize.checkedButton.value
            color: bgColor.checkedButton.value
            vguide: !cbHGuide.checked
        }
    }

    backBtn.onClicked: {
        if (stackLayout.currentIndex === 1)
            HWR.endSlipOfPaper(paint.hwID).then(function () {
                stackView.pop()
            })
    }
}
