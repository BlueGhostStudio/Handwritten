pragma Singleton

import QtQuick 2.13
import QtWebSockets 1.1
import BGMRPC 1.0

BGMRPC {
    id: rpc
    url: "ws://116.196.18.41:8000"

    signal newSlipOfPaper(int sopid, string from, int datetime)
    signal joined(var inbox)

    onStatusChanged: {
        if (status === WebSocket.Open) {
            console.log("connected ok")
        }
    }

    onRemoteSignal: {
        if (obj !== "Handwritten") {
            return
        }

        if (sig === "newSlipOfPaper") {
            newSlipOfPaper(args[0], args[1], args[2])
//            SlipOfPaperData.addInboxItem(args[0], args[1], args[2], true)
        }
    }

    function join(name) {
        asyncCall("Handwritten", "js", "join", name).then(function (ret) {
            joined(ret)
        })
    }
    function createSlipOfPaper(to, paper) {
        return asyncCall("Handwritten", "js", "createSlipOfPaper", to, paper)
    }
    function write_slipOfPaper(sopid, stroke) {
        return asyncCall("Handwritten", "js", "write_slipOfPaper",
                         sopid, stroke)
    }
    function endSlipOfPaper(sopid) {
        return asyncCall("Handwritten", "js", "end_slipOfPaper", sopid)
    }
    function getSlipOfPaperCache(sopid) {
        return asyncCall("Handwritten", "js", "getSlipOfPaperCache", sopid)
    }
    function getSlipOfPaperTemp(sopid, slice) {
        return asyncCall("Handwritten", "js", "getSlipOfPaperTemp", sopid,
                         slice).then(function (ret) {
                             var bin = byteArray.atob(ret.data)

                             var strokes = []

                             for (var i = 0; i < bin.length; i += 13) {
                                 //                                 var sizeByte = bin[i + 1] << 8 | bin[i + 2]
                                 strokes.push({
                                                  "type": bin[i] >> 6,
                                                  "color": bin[i] >> 4 & 0x03,
                                                  "shade": bin[i] & 0xf,
                                                  "preSize": (bin[i + 1] << 8 | bin[i + 2]) / 100,
                                                  "size": (bin[i + 3] << 8 | bin[i + 4]) / 100,
                                                  "prePos": {
                                                      "x": (bin[i + 5] << 8 | bin[i + 6]) / 10,
                                                      "y": (bin[i + 7] << 8 | bin[i + 8]) / 10
                                                  },
                                                  "pos": {
                                                      "x": (bin[i + 9] << 8 | bin[i + 10]) / 10,
                                                      "y": (bin[i + 11] << 8 | bin[i + 12]) / 10
                                                  },
                                                  "realtime": false
                                              })
                             }

                             return Promise.resolve(strokes)
                         })
    }
    function getPaperDefine(id, type, realtime) {
        //        console.log("getPaperDefine", id, type, realtime)
        return asyncCall("Handwritten", "js", "getPaperDefine", id,
                         type, realtime)
    }
}
