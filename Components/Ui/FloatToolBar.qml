import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls.Material 2.13

Rectangle {
    default property alias buttons: layout.data
    width: childrenRect.width
    height: childrenRect.height
    color: {
        var c = Material.background
        Qt.rgba(c.r, c.g, c.b, 0.5)
    }
    radius: width / 2
    RowLayout {
        id: layout
        spacing: 0
    }
}
