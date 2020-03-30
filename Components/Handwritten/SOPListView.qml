import QtQuick 2.13


GridView {
    signal itemClicked(int index, Item item)
    model: SOPModel {}

    clip: true

    cellWidth: 202
    cellHeight: 192

    topMargin: 10
    leftMargin: 10

//    snapMode: ListView.SnapToItem
//    pixelAligned: true
}
