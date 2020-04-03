pragma Singleton

import QtQuick 2.13
import QtWebSockets 1.1
import BGMRPC 1.0

BGMRPC {
    id: rpc
    url: "ws://116.196.18.41:8000"

    signal joined(string user)
    /*signal newSlipOfPaper(int sopid, string from, int datetime)
    signal newManuscriptBook(int bid)*/
//    signal strokeUpdated(int sHwType, var sHwID, var sHwStroke)
//    signal joinFail(var error)

    onStatusChanged: {
        if (status === WebSocket.Open) {
            console.log("connected ok")
        }
    }

    onRemoteSignal: {
        if (obj !== "Handwritten") {
            return
        }

        /*if (sig === "newSlipOfPaper") {
            newSlipOfPaper(args[0], args[1], args[2])
        } else if (sig === "manuscriptBookCreated") {
            newManuscriptBook(args[0])
        } else if (sig === "stroke") {
            strokeUpdated(args[0], args[1], args[2])
        }*/
    }

    /*function join(name) {
        return asyncCall("Handwritten", "js", "join", name, DeviceInfo.deviceId).then(function (ret) {
            if (ret.ok) {
                joined(ret.user)
                return Promise.resolve()
            } else {
                joinFail(ret)
                return Promise.reject()
            }
        })
    }*/
    function join(/*by, */name, pwd) {
        // by === 0, join by phone
        // by === 1, join by user and pwd
        if (Qt.platform.os === 'android' || Qt.platform.os === 'ios')
            return asyncCall("Handwritten", "js", "joinWithPhone", name, DeviceInfo.deviceId).then(function (ret) {
                if (ret.ok) {
                    joined(name)
                    Properties.user.user = name
                    Properties.user.nick = ret.name
                    return Promise.resolve()
                } else {
                    return Promise.reject(ret.errno)
                }
            })
        else {
            return asyncCall("Handwritten", "js", "joinWithUsername", name, pwd).then(function (ret) {
                if (ret.ok) {
                    joined(name)
                    Properties.user.user = name
                    Properties.user.nick = ret.name
                    return Promise.resolve()
                } else
                    return Promise.reject(ret.errno)
            })
        }
    }

    function requestVerificationCode(phoneNo) {
        return asyncCall("Handwritten", "js", "requestVerificationCode", phoneNo);
    }
    function registerByPhone(code) {
        return asyncCall("Handwritten", "js", "registerByPhone", code, DeviceInfo.deviceId)
    }
    function registerByUsername(usr, pwd) {
        return asyncCall("Handwritten", "js", "registerByUsername", usr, pwd)
    }

    // Slip of Paper
    /*function slipOfPaperInbox() {
        return asyncCall("Handwritten", "js", "slipOfPaperInbox")
    }
    function createSlipOfPaper(to, paper) {
        return asyncCall("Handwritten", "js", "createSlipOfPaper", to, paper)
    }
    function write_slipOfPaper(sopid, stroke, sync) {
        if (!sync)
            remoteSignal("Handwritten", "stroke", [0, sopid, stroke])
        return asyncCall("Handwritten", "js", "write_slipOfPaper",
                         sopid, stroke, sync)
    }
    function endSlipOfPaper(sopid) {
        return asyncCall("Handwritten", "js", "end_slipOfPaper", sopid)
    }
    function getSlipOfPaperTemp(sopid, slice) {
        return asyncCall("Handwritten", "js", "getSlipOfPaperTemp", sopid,
                         slice).then(function (ret) {
                             return Promise.resolve(base64ToStrokes(ret.data))
                         })
    }
    function haveReadSlipOfPaper(id) {
        return asyncCall("Handwritten", "js", "haveRead", id)
    }*/
    function base64ToStrokes(data) {
        var bin = byteArray.atob(data)

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

        return strokes
    }

    function rawDataToStrokes(bin) {
        var strokes = []

        for (var i = 0; i < bin.length; i += 13) {
            //                                 var sizeByte = bin[i + 1] << 8 | bin[i + 2]
            strokes.push({
                             "type": bin.charCodeAt(i) >> 6,
                             "color": bin.charCodeAt(i) >> 4 & 0x03,
                             "shade": bin.charCodeAt(i) & 0xf,
                             "preSize": (bin.charCodeAt(i + 1) << 8 | bin.charCodeAt(i + 2)) / 100,
                             "size": (bin.charCodeAt(i + 3) << 8 | bin.charCodeAt(i + 4)) / 100,
                             "prePos": {
                                 "x": (bin.charCodeAt(i + 5) << 8 | bin.charCodeAt(i + 6)) / 10,
                                 "y": (bin.charCodeAt(i + 7) << 8 | bin.charCodeAt(i + 8)) / 10
                             },
                             "pos": {
                                 "x": (bin.charCodeAt(i + 9) << 8 | bin.charCodeAt(i + 10)) / 10,
                                 "y": (bin.charCodeAt(i + 11) << 8 | bin.charCodeAt(i + 12)) / 10
                             },
                             "realtime": false
                         })
        }

        return strokes
    }

    function getPaperDefine(id, type/*, realtime*/) {
        return asyncCall("Handwritten", "js", "getPaperDefine", id,
                         type/*, realtime*/)
    }

    // Manuscript
    /*function manuscriptBookshelf() {
        return asyncCall("Handwritten", "js", "manuscriptBookshelf")
    }

    function createManuscriptBook(notebook) {
        return asyncCall("Handwritten", "js", "createManuscriptBook", notebook)
    }
    function createManuscriptPage(book, page) {
        return asyncCall("Handwritten", "js", "createManuscriptPage", book, page)
    }

    function write_manuscript(msid, stroke) {
        remoteSignal("Handwritten", "stroke", [2, msid, stroke])
        return asyncCall("Handwritten", "js", "write_manuscript", msid, stroke)
    }

    function manuscriptPage(msid) {
        return asyncCall("Handwritten", "js", "manuscriptPage", msid).then(function (ret) {
            return Promise.resolve(ret !== false ? ret.buffer : -1)
        })
    }

    function readManuscriptData(msbid, startPos, len) {
        return asyncCall("Handwritten", "js", "readBuffer", msbid, startPos, len).then(function (ret) {
            return Promise.resolve(ret.pos === -2 ? {
                                                        pos: -1,
                                                        data: []
                                                    } : {
                                       pos: ret.pos,
                                       data: base64ToStrokes(ret.data)
                                   })
        })
    }

    function closeManuscriptBook(bid) {
        return asyncCall("Handwritten", "js", "closeManuscript", bid)
    }

    function clearManuscriptPage(msid) {
        return asyncCall("Handwritten", "js", "clearPage", msid).then(function () {
            remoteSignal("localManuscriptWrite", "clear", [msid])
        });
    }*/
}
