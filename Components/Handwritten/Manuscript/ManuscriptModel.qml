import QtQuick 2.13
import QtQml.Models 2.13
import Handwritten 1.1

ObjectModel {
    function addBookselfItem(bid) {
        var item = HWLI.manuscriptBookshelfCmp.createObject(HWLI.fakeRoot, {
                                                                bid: bid
                                                            })
        append(item)
    }
    function loadBookshelf() {
        HWR.manuscriptBookshelf().then(function (ret) {
            for (var x in ret) {
                addBookselfItem(ret[x].b_id)
            }
        })
    }

    Component.onCompleted: {
        HWR.newManuscriptBook.connect(function (bid) {
            addBookselfItem(bid)
        })
    }
}
