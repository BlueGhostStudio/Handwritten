import QtQuick 2.13
import QtQml.Models 2.13
import Handwritten 1.1
import ".."

ObjectModel {
    function addBookselfItem(bid) {
        var item = HWLI.manuscriptBookshelfCmp.createObject(HWLI.fakeRoot, {
                                                                bid: bid
                                                            })
        append(item)
    }
    function loadBookshelf() {
        var bookshelf = MSCR.manuscriptBookshelf()/*.then(function (ret) {
            for (var x in ret) {
                addBookselfItem(ret[x].b_id)
            }
        })*/
        for (var x in bookshelf)
            addBookselfItem(bookshelf[x].b_id)
    }

    Component.onCompleted: {
        MSCR.newManuscriptBook.connect(function (bid) {
            addBookselfItem(bid)
        })
    }
}
