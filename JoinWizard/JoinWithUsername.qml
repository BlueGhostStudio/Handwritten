import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Layouts 1.13
import Handwritten 1.1
import "qrc:/Components/Ui" as UI


ColumnLayout {
    property int joinAction: 0 // 0-join,1-register

    width: Math.min(implicitWidth, joinPageRoot.width / 2)
    GridLayout {
        columns: 2
        Layout.fillWidth: true
        Label {
            text: qsTr("User Name")
        }
        TextField {
            id: tfUser
            placeholderText: qsTr("User Name")
            text: Properties.user.user
        }
        Label {
            text: qsTr("Password")
        }
        TextField {
            id: tfPassword
            placeholderText: qsTr(("Password"))
        }
    }

    Label {
        id: labInfo
        Layout.fillWidth: true
        visible: false
        color: Material.color(Material.Red)
    }

    GridLayout {
        id: glRegister
        Layout.fillWidth: true
        visible: joinAction === 1
        Label {
            text: qsTr("Confirm password")
        }
        TextField {
            id: tfConfirmPassword
            placeholderText: "Password"
        }
    }
    
    Button {
        id: btnJoin
        highlighted: true
        Layout.alignment: Qt.AlignHCenter
        text: joinPageRoot.joinAction === 0 ? qsTr("Join") : qsTr("Register")
        onClicked: {
            if (joinAction === 0) {
                HWR.join(tfUser.text, tfPassword.text).then(
                            ()=>{
                                rootWindowStackView.pop()
                            }).catch(
                            (errno)=>{
                                labInfo.visible = true
                                switch (errno) {
                                case -1:
                                    labInfo.text = qsTr("User no existed, Reginster?")
                                    joinAction = 1
                                    break
                                case -2:
                                    labInfo.text = qsTr("Join fail")
                                    break
                                }
                            })
            } else {
                if (tfPassword.text === "" || tfPassword.text !== tfConfirmPassword.text) {
                    labInfo.visible = true
                    labInfo.text = qsTr("Wrong password")
                    return
                }

                HWR.registerByUsername(tfUser.text, tfPassword.text).then(
                            (ret)=>{
                                if (ret === true) {
                                    HWR.join(tfUser.text, tfPassword.text).then(
                                        ()=>{
                                            rootWindowStackView.pop()
                                        })
                                }
                            })
            }
        }
    }
}
