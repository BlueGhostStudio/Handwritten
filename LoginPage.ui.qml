import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import Handwritten 1.1
import "qrc:/Components/Ui" as UI

UI.TopLevelPage {
    title: qsTr("Login")

    ColumnLayout {
        anchors.centerIn: parent
        TextField {
            id: tfUser
            placeholderText: qsTr("User")
        }
        Button {
            id: btnLogin
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Login")
        }
    }

    Connections {
        target: btnLogin
        onClicked: {
            rootWindow.loginUser = tfUser.text
            HWR.join(tfUser.text);
        }
    }
    Connections {
        target: HWR
        onJoined: stackView.pop()
    }
}
