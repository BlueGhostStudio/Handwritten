import QtQuick 2.13
import QtQml.Models 2.13
import Handwritten 1.1
import ".."

ObjectModel {
    property int pmbid: -1
    property int pmid: -1
    signal itemPressNHold(int item_pmid, var data)

    function addItem(cmp, pmid, data) {
        var item = cmp.createObject(HWLI.fakeRoot, {
                                        pmid: pmid,
                                        model: this
                                    })
        item.load(data)
        append(item)
    }
    function deleteItem(pmid) {
        for (var i = 0; i < count; i++) {
            var item = get(i);
            if (item.pmid === pmid) {
                remove(i)
            }
        }
    }

    function resetTitle(id, data) {
        for (var i = 0; i < count; i++) {
            var item = get(i);
            if (item.pmid === id) {
                item.load(data)
            }
        }
    }

    function resetSeq(id, seq) {
        for (var i = 0; i < count; i++) {
            var item = get(i);
            if (item.pmid === id) {
                item.seq = seq
            }
        }
    }

    function loadBookshelf() {
        pmbid = -1
        pmid = -1
        clear()
        PMSCR.publicManuscriptBooks().then(
                    (ret)=>{
                        for (var x in ret) {
                            addItem(HWLI.publicManuscriptBookshelfItemCmp, ret[x].id, ret[x])
                        }
                    })
    }
    function loadManuscripts(bid) {
        pmbid = bid
        pmid = -1
        clear()
        PMSCR.publicManuscripts(pmbid).then(
                    (ret)=>{
                        for (var x in ret) {
                            addItem(HWLI.publicManuscriptItemCmp, ret[x].id, ret[x])
                        }
                    })
    }
    function loadManuscriptPages(mid){
        pmid = mid
        clear()
        PMSCR.publicManuscriptPages(pmid).then(
                    (ret)=>{
                        for (var x in ret) {
                            addItem(HWLI.publicManuscriptPageItemCmp, ret[x].id, ret[x].page)
                        }
                    })
    }

    Component.onCompleted: {
        PMSCR.newPublicManuscriptBook.connect(
                    (id, titleStrokesData)=>{
                        addItem(HWLI.publicManuscriptBookshelfItemCmp,
                                id, titleStrokesData)
                    })
        PMSCR.rewrittenPublicManuscriptBookTitle.connect(
                    (id, titleStrokesData)=>{
                        if (pmbid === -1)
                            resetTitle(id, {title: titleStrokesData})
                    })
        PMSCR.rewrittenPublicManuscriptTitle.connect(
                    (id, titleStrokesData)=>{
                        console.log("sdfa", pmbid, id, titleStrokesData.length)
                        if (pmbid > 0 && pmid === -1)
                            resetTitle(id, {title: titleStrokesData})
                    })
        PMSCR.deletedPublicManuscriptBook.connect(
                    (id)=>{
                        if (pmbid === -1)
                            deleteItem(id)
                    })
        PMSCR.deletedPublicManuscript.connect(
                    (id)=>{
                        if (pmbid > 0 && pmid === -1)
                            deleteItem(id)
                    })
        PMSCR.deletedPublicManuscriptPage.connect(
                    (id)=>{
                        if (pmbid > 0 && pmid > 0)
                            deleteItem(id)
                    })
        PMSCR.resetSeqPublicManuscriptBook.connect(
                    (id, seq)=>{
                        if (pmbid === -1)
                            resetSeq(id, seq)
                    })
        PMSCR.resetSeqPublicManuscript.connect(
                    (id, seq)=>{
                        if (pmbid > 0 && pmid === -1)
                            resetSeq(id, seq)
                    })
    }
}
