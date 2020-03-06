import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtGraphicalEffects 1.13
import QtQuick.Controls 2.13

ColumnLayout {
    id: root
    property string from
    property bool realtime
    property int sopid
    property var datetime
    property bool opened: false
    x: (ListView.view.width - width) / 2
    spacing: 0
    
    Item {
        id: itTitle
        Layout.fillWidth: true
        Layout.preferredHeight: rlTitle.height + 4
        
        Item {
            id: titleBG
            anchors.fill: parent
            Rectangle {
                anchors.fill: parent
                color: canvas.paperDefine.background_color
                       || "#00000000"
            }
            Image {
                anchors.fill: parent
                fillMode: Image.Tile
                source: canvas.paperDefine.background_image || ""
            }
            
            layer.enabled: true
            layer.effect: BrightnessContrast {
                brightness: -0.2
            }
        }
        
        RowLayout {
            id: rlTitle
            x: 2
            y: 2
            width: parent.width - 4
            Label {
                Layout.fillWidth: true
                text: {
                    var d = new Date(root.datetime)
                    "<strong>From:</strong> <u>" + root.from + "</u> - "
                    + Qt.formatDateTime(d, "yyyy-M-d h:m")
                }
            }
            Rectangle {
                id: indicator
                implicitWidth: 16
                implicitHeight: 16
                radius: 8
                color: "#ccc"
                visible: root.realtime
            }
        }
    }
    
    Item {
        Layout.preferredWidth: canvas.width
        Layout.preferredHeight: {
            //                    if (opened) {
            var h = canvas.range[3] - canvas.range[1]
            h < 0 ? (opened ? 10 : 64) : (opened ? h + 10 : Math.max(
                                                       64, h + 10))
            //                    } else
            //                        64
        }
        clip: true
        
        SlipOfPaperCanvas {
            id: canvas
            width: canvasSize.width
            y: canvas.range[3] - canvas.range[1] < 0 ? 0 : -range[1] + 5
            height: canvasSize.height
        }
        
        Button {
            text: "Open"
            anchors.centerIn: parent
            visible: !root.opened
            onClicked: {
                root.opened = true
                root.load(false)
            }
        }
        ToolButton {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -10
            anchors.rightMargin: -10
            icon.source: "qrc:/icons/reply.png"
            visible: root.opened
            onClicked: {
                root.ListView.view.newSlipOfPaper(root.from)
            }
        }
    }
    
    SequentialAnimation {
        id: aniWritting
        ColorAnimation {
            target: indicator
            property: "color"
            from: "#ccc"
            to: "green"
        }
        ColorAnimation {
            target: indicator
            property: "color"
            from: "green"
            to: "#ccc"
        }
    }
    Connections {
        target: HWR
        onRemoteSignal: {
            if (obj !== "Handwritten")
                return
            if (args[0] === sopid) {
                if (sig === "stroke")
                    aniWritting.restart()
                else if (sig === "endSlipOfPaper") {
                    indicator.visible = false
                    realtime = false
                }
            }
        }
    }
    
    function load(slice) {
        canvas.load(sopid)
    }
    
    Component.onCompleted: {
        load()
        /*canvas.initial(sopid).then(function () {
            load()
        })*/
    }
}
