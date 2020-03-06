import QtQuick 2.13
import QtQml.Models 2.13
import Handwritten 1.1

ObjectModel {
//    property Item fakeRoot: Item {}

    function addInboxItem(sopid, from, datetime, realtime) {
        var paperItem = HWLI.sopInboxItemCmp.createObject (HWLI.fakeRoot, {
                                                               from: from,
                                                               sopid: sopid,
                                                               datetime: datetime,
                                                               realtime: realtime
                                                           })

        append(paperItem)
    }

    function loadInbox() {
        HWR.slipOfPaperInbox().then(function (ret) {
            for (var x in ret) {
                addInboxItem(ret[x].id, ret[x].from,
                             ret[x].datetime, ret[x].realtime)
            }
        })
    }

    /*Connections {
        target: HWR
        onNewSlipOfPaper: addInboxItem(sopid, from, datetime, true)
    }*/
    Component.onCompleted: {
        HWR.newSlipOfPaper.connect(function (sopid, from, datetime) {
            addInboxItem(sopid, from, datetime, true)
        })
    }
}