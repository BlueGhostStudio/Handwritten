import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import Handwritten 1.1
import "qrc:/Components/Ui" as UI

Pane {
    id: verifyPage
    Dialog {
        id: dlgRequestVerCode
        closePolicy: Popup.NoAutoClose

        anchors.centerIn: overlay
        Label {
            text: qsTr("The verification code error.Re-request verification code?")
        }

        standardButtons: Dialog.Yes | Dialog.No

        onAccepted: {
            tfVerCode.text = '';
            HWR.requestVerificationCode(joinPageRoot.user).then(
                        (verCode)=>{
                            SMS.sendSMS(joinPageRoot.user, verCode)
                        })
        }
    }

    ColumnLayout {
        anchors.centerIn: parent
        width: Math.min(implicitWidth, joinPageRoot.width / 2)
        Label {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("Input Verification code then click [Next] to finish join")
        }

        RowLayout {
            Label {
                text: qsTr("Verification code")
            }

            TextField {
                id: tfVerCode
                placeholderText: qsTr("Verification code")
            }
        }
        UI.Button {
            Layout.alignment: Qt.AlignHCenter
            highlighted: true
            text: qsTr("Next")
            onClicked: {
                HWR.registerByPhone(tfVerCode.text).then(
                            (ret)=> {
                                if (ret === true) {
                                    HWR.join(/*0, */joinPageRoot.user).then(
                                        (ret)=>{
                                            if (ret.ok)
                                                rootWindowStackView.pop()
                                        })
                                } else {
                                    dlgRequestVerCode.open()
                                }
                            })
            }
        }
    }
}
