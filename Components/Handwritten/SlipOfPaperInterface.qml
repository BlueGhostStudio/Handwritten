pragma Singleton

import QtQuick 2.13

QtObject {
    signal newSlipOfPaper(int hwSopid, string from, int datetime)
    signal hasEndedSlipOfPaper(int hwSopid)
    signal strokeUpdated(int sHwType, var sHwID, var sHwStroke)

    /*Connections {
        target: HWR
        onRemoteSignal: {
            if (obj !== "Handwritten")
                return

            if (sig === "newSlipOfPaper")
                newSlipOfPaper(args[0], args[1], args[2])
            else if (sig === "endSlipOfPaper")
                hasEndedSlipOfPaper(args[0])
        }
    }*/

    Component.onCompleted: {
        HWR.remoteSignal.connect(
            (obj, sig, args)=>{
                if (obj !== "Handwritten")
                    return

                if (sig === "newSlipOfPaper")
                    newSlipOfPaper(args[0], args[1], args[2])
                else if (sig === "endSlipOfPaper")
                    hasEndedSlipOfPaper(args[0])
                else if (sig === "stroke")
                    strokeUpdated(args[0], args[1], args[2])
            })
    }

    function slipOfPaperInbox() {
        return HWR.asyncCall("Handwritten", "js", "slipOfPaperInbox")
    }
    function createSlipOfPaper(to, paper) {
        return HWR.asyncCall("Handwritten", "js", "createSlipOfPaper", to, paper)
    }
    function write/*_slipOfPaper*/(sopid, stroke, sync) {
        if (!sync)
            HWR.remoteSignal("Handwritten", "stroke", [0, sopid, stroke])
        return HWR.asyncCall("Handwritten", "js", "write_slipOfPaper",
                         sopid, stroke, sync)
    }
    function endSlipOfPaper(sopid) {
        return HWR.asyncCall("Handwritten", "js", "end_slipOfPaper", sopid)
    }
    function getSlipOfPaperTemp(sopid, slice) {
        return HWR.asyncCall("Handwritten", "js", "getSlipOfPaperTemp", sopid,
                         slice).then(
                    (ret)=>{
                        return Promise.resolve({
                                                   data: HWR.base64ToStrokes(ret.data),
                                                   realtime: ret.realtime
                                               })
                    })
    }
    function haveReadSlipOfPaper(id) {
        return HWR.asyncCall("Handwritten", "js", "haveRead", id)
    }
    function getPaperDefine(id) {
        console.log("->if sopif", id)
        return HWR.getPaperDefine(id, 0)
    }
}
