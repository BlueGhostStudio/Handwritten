import QtQuick 2.13
import QtQml.Models 2.13
import Handwritten 1.1
import ".."

ObjectModel {
    function addBookshelfItem(bid) {
        var item = HWLI.manuscriptBookshelfItemCmp.createObject(HWLI.fakeRoot, {
                                                                bid: bid
                                                            })
        append(item)
    }
    function loadBookshelf() {
        var bookshelf = MSCR.manuscriptBookshelf()/*.then(function (ret) {
            for (var x in ret) {
                addBookshelfItem(ret[x].b_id)
            }
        })*/
        for (var x in bookshelf)
            addBookshelfItem(bookshelf[x].b_id)
    }

    Component.onCompleted: {
        MSCR.newManuscriptBook.connect(function (bid) {
            addBookshelfItem(bid)
        })
    }
}
