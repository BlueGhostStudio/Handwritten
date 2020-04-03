import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Layouts 1.13

ListView {
    id: root
//    property int paperType: model[currentIndex].value

    property int value: model[currentIndex].value
    property int previewWidth: 64
    property int previewHeight: 64
    property var fillMode: Image.Tile
    orientation:  Qt.Horizontal
    currentIndex: 0
    highlight: Rectangle {
        width: previewWidth
        height: previewHeight
        color: "#00000000"
        border.color: Material.accent
        border.width: 2
        y: ListView.currentItem ? ListView.currentItem.y : 0
        z: 10
    }
    
    /*model: [
        { color: "yellow", value: -1 },
        { image: "qrc:/imgs/paper.png", value: -2 }
    ]*/
    delegate: Rectangle {
        width: previewWidth; height: previewHeight
        color: modelData.color || "#00000000"
        Image {
            fillMode: root.fillMode
            anchors.fill: parent
            anchors.margins: 2
            source: modelData.image || ""
        }
        MouseArea {
            anchors.fill: parent
            onClicked: parent.ListView.view.currentIndex = index
        }
        z: 0
    }
}
