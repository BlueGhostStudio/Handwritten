import QtQuick 2.13

ListView {
    model: ManuscriptModel {}
    orientation: Qt.Horizontal
    snapMode: ListView.SnapOneItem
    highlightRangeMode: ListView.StrictlyEnforceRange

    signal itemClicked(int index, Item item)
}
