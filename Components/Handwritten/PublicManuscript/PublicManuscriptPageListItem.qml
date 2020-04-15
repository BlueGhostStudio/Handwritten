import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtQml.Models 2.13

MouseArea {
    property int pmid
    property int page
    property ObjectModel model

    width: Math.max(childrenRect.width, 266) + 16
    height: childrenRect.height + 16

    Label {
        x: 8; y: 8
        text: page
        color: parent.pressed ? Material.accent : Material.foreground
    }

    onPressAndHold: model.itemPressNHold(pmid, page)

    function load(data) {
        page = data
    }
}
