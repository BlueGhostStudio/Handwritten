import QtQuick 2.13

HWCanvas {
    hwType: 2
    hwInterface: MSCR

    Component.onCompleted: {
        paperDefine.initial(-1)
        paperDefineChanged()
        console.log(paperDefine.width, paperDefine.height)
    }
}
