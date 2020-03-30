import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import Handwritten 1.1
import "qrc:/Components/Ui" as UI

UI.TopLevelPage {
    id: joinPageRoot
    title: qsTr("Join")
    property int joinAction: 0 // 0-join,1-register,2-rebind
    property alias user: phoneNumberPage.user

    StackView {
        id: joinPageStackview
        anchors.fill: parent
        initialItem: PhoneNumberPage {
            id: phoneNumberPage
        }
    }

    Connections {
        target: HWR
        onJoined: {
            rootWindowStackView.pop()
        }
    }
}
