import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Layouts 1.13
import Handwritten 1.1
import "qrc:/Components/Ui" as UI

UI.SubPage {
    id: root
    property int bid
    property int pid: 0
    property bool controlsShow: true
    title: qsTr("Manuscript")

    /*extendedArea: [
        UI.ZoomButton {
            paint: paint
        },
        UI.StrokeButton {
            paint: paint
            strokeControler: strokeForm
            onClicked: drawer.open()
        }

    ]*/
    header.visible: false

    HWPaint {
        id: paint
        hwID: bid + 'p' + pid
        anchors.centerIn: parent
        width: Math.min(contentWidth, parent.width)
        height: Math.min(contentHeight, parent.height)
        enabledGuide: false
        canvas: ManuscriptCanvas {
            anchors.fill: parent
//            renderTarget: Canvas.FramebufferObject
//            hwID: paint.hwID
            bid: root.bid
            pid: root.pid
            z: -1
        }

        hwType: 2

        onBottomLeftClicked: paint.newLine()
        onBottomRightClicked: toolBar2.visible = !toolBar2.visible
        onTopRightClicked: {
            controlsShow = !controlsShow
            if (!controlsShow)
                toolBar2.visible = false
        }
        onTopLeftClicked: writeMode = !writeMode//drwPages.open()
        /*onTopRightClicked: {
            HWR.clearManuscriptPage(paint.hwID).then(function () {
                paint.canvas.clear ()
            })
        }*/
    }

    UI.FloatToolBar {
        id: toolBar1
        x: paint.x + (paint.width - width) / 2
        y: {
            var _y = Math.max(paint.y - height - 10, 10)
            return (paint.state === "" || paint.state === "zooming") && controlsShow ? _y : _y - height
        }
//        state: "minSize"
//        visible: paint.state !== "writting" && controlsShow
        opacity: (paint.state === "" || paint.state === "zooming") && controlsShow ? 1 : 0
//        transform: Translate { y: paint.state === "" && controlsShow ? 0 : -toolBar1.height }
        Menu {
            id: mToolBar1Menu
            UI.MenuItem {
                icon.source: "qrc:/icons/back.png"
                text: qsTr("Back")
                onTriggered: {
                    /*HWR.closeManuscriptBook(bid).then(function () {
                        rootWindowStackView.pop()
                    })*/
                    MSCR.closeManuscriptBook(bid)
                    rootWindowStackView.pop()
                }
            }
            UI.MenuItem {
                icon.source: toolBar1.state === "minSize" ? "qrc:/icons/expend.png" : "qrc:/icons/collapse.png"
                text: toolBar1.state === "minSize" ? qsTr("Maximize Toolbar") : qsTr("Minimize Toolbar")
                onTriggered: toolBar1.state = toolBar1.state === "minSize" ? "" : "minSize"
            }

            UI.MenuItem {
                icon.source: "qrc:/icons/openPage.png"
                text: qsTr("Pages")
                onTriggered: drwPages.open()
            }
            UI.MenuItem {
                text: paint.writeMode ? qsTr("View Mode") : qsTr("Write Mode")
                icon.source: paint.writeMode ? "qrc:/icons/eye.png" : "qrc:/icons/write.png"
                onTriggered: paint.writeMode = !paint.writeMode
            }
        }

        UI.ToolButton {
            icon.source: "qrc:/icons/vmenu.png"
            onClicked: mToolBar1Menu.popup(this)//toolBar1.visible = false
            onPressAndHold: toolBar1.state = toolBar1.state === "minSize" ? "" : "minSize"
        }

        ToolSeparator {
            leftPadding: 0
            rightPadding: 0
        }

        UI.ToolButton {
            visible: toolBar1.state !== "minSize"
            text: "P." + pid
            onClicked: drwPages.open()
        }

        UI.ZoomButton {
            paint: paint
        }
        UI.ToolButton {
            visible: toolBar1.state !== "minSize"
            icon.source: paint.writeMode ? "qrc:/icons/hand.png" : "qrc:/icons/write.png"
            onClicked: paint.writeMode = paint.writeMode ? false : true
        }
        UI.StrokeButton {
            paint: paint
            visible: paint.writeMode
        }

        ToolSeparator {
            leftPadding: 0
            rightPadding: 0
        }

        UI.ToolButton {
            icon.source: "qrc:/icons/upload.png"
            onClicked: {
                rootWindowStackView.push("PublishManuscript.qml", {
                                             bid: bid
                                         })
            }
        }

        Behavior on opacity {
            NumberAnimation { duration: 250 }
        }
        Behavior on y {
            NumberAnimation { duration: 250 }
        }
    }

    ProgressBar {
        id: pbLoading
        anchors.top: toolBar1.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: toolBar1.horizontalCenter

        width: toolBar1.width - toolBar1.height / 2
    }

    UI.FloatToolBar {
        id: toolBar2
        x: paint.x + paint.width - width - 10
        y: Math.min(paint.y + paint.height + 10, root.height - height - 10)

        visible: false

        UI.ToolButton {
            icon.source: "qrc:/icons/minus.png"
            onClicked: toolBar2.visible = false
        }

        ToolSeparator {
            leftPadding: 0
            rightPadding: 0
        }

        UI.ToolButton {
            icon.source: "qrc:/icons/broom.png"
            onClicked: {
                /*HWR.clearManuscriptPage(paint.hwID).then(function () {
                    paint.canvas.clear ()
                })*/
                MSCR.clearManuscriptPage(paint.hwID)
                paint.canvas.clear()
            }
        }
    }

    Drawer {
        id: drwPages
        edge: Qt.TopEdge
        dragMargin: 0

        width: rootWindow.width
        height: rootWindow.height * 0.33

        ColumnLayout {
            width: parent.width - 20
            height: parent.height - 20
            x: 10; y: 10
            Label {
                text: qsTr("Pages")
            }

            UI.PageSelector1 {
                Layout.fillWidth: true
                Layout.fillHeight: true
                onPageSelected: {
                    drwPages.close()
                    gotoPage(page)
                    /*function _gotoPage_ () {
                        gotoPage(page)
                        drwPages.closed.disconnect(_gotoPage_)
                    }
                    drwPages.closed.connect(_gotoPage_)*/
                }
            }
        }
    }

    /*Popup {
        id: popLoading
        closePolicy: Popup.NoAutoClose
        anchors.centerIn: Overlay.overlay
        BusyIndicator {
            Label {
                anchors.centerIn: parent
                text: qsTr("Loading") + "..."
            }
        }
        background: Rectangle {
            color: Material.background
            radius: width/2
        }
    }*/

    function gotoPage(p) {
        if (p < 0 && p > 60)
            return

        MSCR.updateManuscriptData(paint.hwID)

        pid = p
        paint.contentX = 0
        paint.contentY = 0

        paint.canvas.load()
    }

    function initialNotebook () {
        paint.initialStroke(paint.canvas.initialNotebookPaper())
    }

    /*Connections {
        target: paint.canvas
        onDataLoaded: {
            popLoading.close()
            root.enabled = true
        }
    }*/

    backBtn.onClicked: {
        MSCR.closeManuscriptBook(bid)
    }

    Connections {
        target: rootWindow
        onClosing: MSCR.updateManuscriptData(paint.hwID)
    }

    Connections {
        target: paint.canvas
        onStartLoad: {
            paint.paintEnabled = false
            pbLoading.visible = true
        }

        onLoading: {
            pbLoading.to = total
            pbLoading.value = loaded
        }
        onFinished: {
            paint.paintEnabled = true
            paint.writeMode = false
            pbLoading.visible = false
        }
    }

    Component.onCompleted: {
//        gotoPage(pid)
        /*paint.initial().then(function () {
            paint.canvas.loadData()
        })*/
    }
}
