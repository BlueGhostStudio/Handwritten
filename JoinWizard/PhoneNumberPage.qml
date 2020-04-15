import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import Handwritten 1.1
import "qrc:/Components/Ui" as UI

Pane {

    property string user: tfUser.text
    ColumnLayout {
        anchors.centerIn: parent
        width: Math.min(implicitWidth, joinPageRoot.width / 2)
        Label {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: /*joinPageRoot.errno === 0 || joinPageRoot.errno === -1
                  ? qsTr("Leave your phone number as the login ID. And use it to send a verification code for authentication.")
                  : qsTr("Phone binding failed. Rebinding?")*/ {
                switch (joinPageRoot.joinAction) {
                case 0:
                    qsTr("Join")
                    break
                case 1:
                    qsTr("Leave your phone number as the login ID. And use it to send a verification code for authentication.")
                    break
                case 2:
                    qsTr("Phone binding failed. Rebinding?")
                    break
                }
            }
        }

        RowLayout {
            Label {
                text: qsTr("Phone number") + ': '
            }

            TextField {
                id: tfUser
                placeholderText: qsTr("Your Phone Number")
                text: Properties.user.user
            }
        }
        Button {
            id: btnLogin
            highlighted: true
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Next")
            onClicked: {
                HWR.join(user).then(
                            ()=>{
                                rootWindowStackView.pop()
                            }).catch(
                            ()=>{
                                HWR.requestVerificationCode(user).then(
                                    (verCode)=>{
                                        SMS.sendSMS(user, verCode)
                                        joinPageStackview.push("qrc:/JoinWizard/VerifyPhone.qml")
                                    })
                            })
            }
        }
    }
}
