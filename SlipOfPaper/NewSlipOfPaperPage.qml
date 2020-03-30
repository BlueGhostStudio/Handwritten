import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Layouts 1.13
import Handwritten 1.1
import "qrc:/Components/Ui" as UI

/*Page*/UI.SubPage {
    id: root
    property string to

    title: qsTr("Slip of Paper") + " - " + qsTr("To") + ": " + to

    extendedArea: [
        UI.ZoomButton {
            paint: paint
        },
        UI.StrokeButton {
            id: btnStroke
            paint: paint
        }/*,
        UI.ToolButton {
            icon.source: "qrc:/icons/settings.png"
            onClicked: {
                openSettingsPage()
            }
        }*/

    ]

    /*SwipeView {
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
                            paint.zoomOut()
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
    }*/
    HWPaint {
        id: paint
        hwType: 0
        writeMode: true
        anchors.centerIn: parent
        width: Math.min(contentWidth, parent.width)
        height: Math.min(contentHeight, parent.height)
//            strokeType: btnStroke.strokeType//bgPen.checkedButton.value
//            strokeSize: btnStroke.strokeSize//bgPenSize.checkedButton.value
//            color: btnStroke.color//bgColor.checkedButton.value
//        vguide: !cbHGuide.checked
    }


    function createSlipOfPaper(to, paperType, hGuide) {
        root.to = to
        HWR.createSlipOfPaper(to, paperType).then (function (sop) {
            if (sop.temp && /^\+?\d{7,15}$/.test(to)) {
                var q = '0' + Qt.btoa(sop.sopid + ',' + sop.toUsrID + ',' + sop.token)
                console.log(q)
                var message = Properties.user.nick +"给你传了一张纸条,点击链接查看..."
                SMS.sendSMS(to, message)
                message = "...http://116.196.18.41/Handwritten/?q=" + q
                SMS.sendSMS(to, message)
            }
            paint.hwID = sop.sopid
            return paint.initial()
        }).then (function (sopid) {
            paint.zoom2ActualSize()
            paint.vguide = !hGuide
            backBtn.icon.source = "qrc:/icons/send.png"
        })
    }

    backBtn.onClicked: {
        HWR.endSlipOfPaper(paint.hwID).then(function () {
            rootWindowStackView.pop()
        })
    }
}
