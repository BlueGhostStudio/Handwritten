import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Layouts 1.13

ListView {
    property int paperType: model[currentIndex].value
    orientation:  Qt.Horizontal
    currentIndex: 0
    highlight: Rectangle {
        width: 64
        height: 64
        color: "#00000000"
        border.color: Material.accent
        border.width: 2
        y: ListView.currentItem ? ListView.currentItem.y : 0
        z: 1
    }
    
    model: [
        { color: "yellow", value: -1 },
        { image: "qrc:/imgs/paper.png", value: -2 }
    ]
    delegate: Rectangle {
        width: 64; height: 64
        color: modelData.color || "#00000000"
        Image {
            anchors.fill: parent
            source: modelData.image || ""
        }
        MouseArea {
            anchors.fill: parent
            onClicked: parent.ListView.view.currentIndex = index//console.log (index)
        }
    }
}
