pragma Singleton

import QtQuick 2.13
import QtWebSockets 1.13
import QtQuick.LocalStorage 2.13
import "../StrokeData.js" as StrokeData
import ".."

QtObject {
    property var manuscriptDB: LocalStorage.openDatabaseSync("manuscriptDB", "1.0", "The manuscript database", 1073741824)
    property var maxBookID: 0
    property var manuscriptCache: []
    signal strokeUpdated(int sHwType, var sHwID, var sHwStroke)
    signal newManuscriptBook(int bid)

    function splitMSID(msid) {
        var matches = /(\d+)p(\d+)/.exec(msid);
        if (!matches)
            return false;

        return [matches[1], matches[2]]
    }

    function write(hwID, stroke) {
        if (!manuscriptCache[hwID])
            manuscriptCache[hwID] = []

        strokeUpdated(2, hwID, stroke)

        manuscriptCache[hwID].push(stroke)
        if (manuscriptCache[hwID].length > 1048576)
            updateManuscriptData(hwID)
    }

    function manuscriptBookshelf() {
        var bookshelf=[]
        manuscriptDB.transaction(
                    (tx)=>{
                        var res = tx.executeSql('SELECT * FROM `v_Manuscript` WHERE `p_id`=0')
                        for (var i = 0; i < res.rows.length; i++)
                            bookshelf.push(res.rows.item(i))
                    })

        return bookshelf
    }

    function createManuscriptBook(notebook) {
        return HWR.asyncCall("Handwritten", "js", "getNotebookDefine", notebook).then(
                    (ret) => {
                        manuscriptDB.transaction(
                            (tx)=>{
                                maxBookID++
                                tx.executeSql('INSERT INTO ManuscriptBook (`id`,`cover`,`paper`,`stroke`) VALUES (?,?,?,?)', [maxBookID, ret.cover, ret.paper, ret.stroke])
                            })
                        newManuscriptBook(maxBookID)
                    })
    }

    function updateManuscriptData(msid) {
//        byteArray.toStrokesRawData(manuscriptCache[msid])

        manuscriptDB.transaction(
                    (tx)=>{
                        var res = tx.executeSql('SELECT * FROM `v_Manuscript` WHERE `id`=?', [msid])
                        var newData
                        if (res.rows.length === 0) {
                            var ids = splitMSID(msid)
                            if (ids === false)
                                return

                            var b_id = ids[0]
                            var p_id = ids[1]
                            newData = StrokeData.toStrokesRawData(manuscriptCache[msid])
                            tx.executeSql("INSERT INTO v_Manuscript (`b_id`, `p_id`, `data`) VALUES (?, ?, ?)", [b_id, p_id, newData])
                        } else {
                            newData = (res.rows.item(0).data || "") + StrokeData.toStrokesRawData(manuscriptCache[msid])
                            tx.executeSql("UPDATE v_Manuscript SET data=? WHERE id=?", [newData,msid])
                        }
                        delete manuscriptCache[msid]
                    })
    }

    function closeManuscriptBook (bid) {
        var ex = new RegExp('^' + bid + 'p')
        for (var x in manuscriptCache) {
            if (ex.test(x)) {
                updateManuscriptData(x)
            }
        }
    }

    function manuscriptPage(msid) {
        /*var ids = splitMSID(msid)
        if (ids === false)
            return false

        var b_id = ids[0]
        var p_id = ids[1]*/

        var res
//        var msid = bid + 'p' + pid

        manuscriptDB.transaction (
            (tx)=>{
                res = tx.executeSql('SELECT * FROM `v_Manuscript` WHERE `id`=?', [msid])
            })
        if (res.rows.length > 0) {
            var pageData = res.rows.item(0)
            if (manuscriptCache[msid])
                pageData.data = StrokeData.toStrokesRawData(manuscriptCache[msid]) + pageData.data || ""
            return pageData
        } else
            return false
    }

    function clearManuscriptPage(msid) {
        console.log(msid);
        manuscriptDB.transaction(
                    (tx)=>{
                        tx.executeSql('DELETE FROM `v_Manuscript` WHERE `id`=?', [msid]);
                    })
        delete manuscriptCache[msid]
        manuscriptCache[msid] = []
    }

    function getPaperDefine(bid) {
        var row = { paper: "", stroke: "" }
        var ok = false
        manuscriptDB.transaction(
                    (tx)=>{
                        var res = tx.executeSql('SELECT * FROM `ManuscriptBook` WHERE `id`=?', [bid])
                        if (res.rows.length > 0) {
                            row = res.rows.item(0)
                            ok = true
                        }
                    })
        return ok ? {
                        cover: row.cover,
                        paper: row.paper,
                        stroke: row.stroke
                    } : false
    }

    function exportNotebook () {
        var pkg = ''
        manuscriptDB.transaction(
                    (tx)=>{
                        var MBRes = tx.executeSql('SELECT * FROM ManuscriptBook')
                        for (var i = 0; i < MBRes.rows.length; i++) {
                            var bid = MBRes.rows.item(i).id
                            var paperDefine = getPaperDefine(bid)
                            pkg = byteArray.packageNotebook_header(pkg, '{"cover":' + paperDefine.cover + ',"paper":' + paperDefine.paper + ',"stroke":' + paperDefine.stroke + '}')
                            var PRes = tx.executeSql('SELECT p_id, data FROM v_Manuscript WHERE b_id=? ORDER BY p_id', [bid])
                            for (var j = 0; j < PRes.rows.length; j++) {
                                var pItem = PRes.rows.item(j)
                                pkg = byteArray.packageNotebook_page(pkg, pItem.p_id, pItem.data, 0X7F)
                            }
                            pkg = byteArray.packageNotebook_notebookEnd(pkg)
                        }
                    })
        byteArray.savePackage(pkg)

        console.log("pkg end")
    }

    function importNotebook() {
        var pkg = byteArray.readPackage()
        var i = 0;
        var pkgEnd = false;
        while(!pkgEnd) {
            console.log("notebook begin")
            var h = byteArray.unpackageNotebook_header(pkg, i)
            i = h.i

            var paperDefine = JSON.parse(h.data)
            var np = JSON.stringify(paperDefine.paper)
            var nc = JSON.stringify(paperDefine.cover)
            var ns = JSON.stringify(paperDefine.stroke)

            manuscriptDB.transaction(
                        (tx)=>{
                            maxBookID++
                            tx.executeSql('INSERT INTO ManuscriptBook (`id`,`cover`,`paper`,`stroke`) VALUES (?,?,?,?)', [maxBookID, nc, np, ns])
                        })

            var nbEnd = false
            while(!nbEnd) {
                var pd = byteArray.unpackageNotebook_page(pkg, i)
                if (pd.NBEnd) {
                    nbEnd = true
                    console.log("Notebook end")
                    if (pd.PkgEnd)
                        pkgEnd = true
                } else {
                    manuscriptDB.transaction(
                                (tx)=>{
                                    tx.executeSql('INSERT INTO v_Manuscript(b_id,p_id,data) VALUES (?, ?, ?)', [maxBookID, pd.p, pd.data])
                                })
                    console.log("page end", pd.p)
                }

                i = pd.i
            }
        }
    }

    Component.onCompleted: {
        try {
            manuscriptDB.transaction(
                (tx)=> {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS ManuscriptBook (id INTEGER PRIMARY KEY, cover TEXT, paper TEXT, stroke TEXT);')
                    tx.executeSql("CREATE TRIGGER IF NOT EXISTS delete_ManuscriptBook DELETE ON ManuscriptBook BEGIN DELETE FROM ManuscriptPage WHERE mb_id = OLD.id;END;")
//                    tx.executeSql("CREATE TRIGGER IF NOT EXISTS insert_ManuscriptBook AFTER INSERT ON ManuscriptBook BEGIN INSERT INTO v_Manuscript (p_id, b_id) VALUES (0, NEW.id);END;")

                    tx.executeSql('CREATE TABLE IF NOT EXISTS ManuscriptPage (id INTEGER,mb_id INTEGER,d_id INTEGER,PRIMARY KEY (id,mb_id));')
                    tx.executeSql("CREATE TRIGGER IF NOT EXISTS delete_manuscriptPage DELETE ON ManuscriptPage BEGIN DELETE FROM StrokeData WHERE id = OLD.d_id;END;")

                    tx.executeSql('CREATE TABLE IF NOT EXISTS StrokeData (id INTEGER PRIMARY KEY UNIQUE,data TEXT);')

                    tx.executeSql("CREATE VIEW IF NOT EXISTS v_Manuscript AS SELECT a.mb_id || 'p' || a.id AS id, a.mb_id AS b_id, a.id AS p_id, CASE a.id WHEN 0 THEN b.cover ELSE b.paper END AS paper, b.stroke, a.d_id, d.data FROM ManuscriptPage AS a LEFT JOIN ManuscriptBook AS b ON a.mb_id = b.id LEFT JOIN StrokeData AS d ON a.d_id = d.id;")
                    tx.executeSql("CREATE TRIGGER IF NOT EXISTS delete_Manuscript INSTEAD OF DELETE ON v_Manuscript BEGIN DELETE FROM ManuscriptPage WHERE id = OLD.p_id AND mb_id = OLD.b_id;END;")
                    tx.executeSql("CREATE TRIGGER IF NOT EXISTS insert_Manuscript INSTEAD OF INSERT ON v_Manuscript WHEN (SELECT COUNT(id) FROM ManuscriptBook WHERE id = NEW.b_id) = 1 AND  (SELECT COUNT(id) FROM ManuscriptPage WHERE mb_id = NEW.b_id AND id = NEW.p_id) = 0 BEGIN INSERT INTO StrokeData (data) VALUES (NEW.data); INSERT INTO ManuscriptPage (id, mb_id, d_id) VALUES (NEW.p_id, NEW.b_id, last_insert_rowid()); END;")
                    tx.executeSql("CREATE TRIGGER IF NOT EXISTS update_Manuscript INSTEAD OF UPDATE ON v_Manuscript WHEN (SELECT COUNT(id) FROM ManuscriptBook WHERE id = OLD.b_id) = 1 BEGIN UPDATE StrokeData SET data = NEW.data WHERE id = OLD.d_id;END;")

                    var res = tx.executeSql("SELECT IFNULL(max(id),0) AS maxID FROM ManuscriptBook")
                    maxBookID = res.rows.item(0).maxID
                })
            var p = getPaperDefine("1p0")
        } catch (err) {
            console.log("Error creating table in database: " + err)
        }
    }
}
