import QtQuick 2.13

ListView {
    model: SOPModel {}
    spacing: 10
    topMargin: 5
    bottomMargin: 64

    snapMode: ListView.SnapToItem
    pixelAligned: true
}
