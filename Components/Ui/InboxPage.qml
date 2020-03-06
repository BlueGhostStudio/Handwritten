import QtQuick 2.13
import QtQuick.Controls 2.13

Page {
    property string subTitle
    header: Pane {
        Label {
            text: title + " - " + subTitle
            font.pixelSize: rootWindow.font.pixelSize * 1.5
        }
    }
}
