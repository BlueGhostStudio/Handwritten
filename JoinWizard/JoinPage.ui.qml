import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import Handwritten 1.1
import "qrc:/Components/Ui" as UI


UI.TopLevelPage {
    id: joinPageRoot
    title: qsTr("Join")
    property alias joinAction: joinWithUsername.joinAction

    JoinWithUsername {
        id: joinWithUsername
        anchors.centerIn: parent
    }
}
