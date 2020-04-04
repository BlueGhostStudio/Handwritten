pragma Singleton

import QtQuick 2.13
import QtWebSockets 1.13
import QtQuick.LocalStorage 2.13
import "../StrokeData.js" as StrokeData
import ".."

QtObject {
    property var manuscriptDB: LocalStorage.openDatabaseSync("manuscriptDB", "1.0", "The manuscript database", 100000000)
    property var maxBookID: 0
    property var manuscriptCache: []
    signal strokeUpdated(int sHwType, var sHwID, var sHwStroke)

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
        if (manuscriptCache[hwID].length > 32)
            updateManuscriptData(hwID)
    }

    function manuscriptBookshelf() {
        var bookShelf=[]
        manuscriptDB.transaction(
                    (tx)=>{
                        var res = tx.executeSql('SELECT * FROM `v_Manuscript` WHERE `p_id`=0')
                        for (var i = 0; i < res.rows.length; i++)
                            bookShelf.push(res.rows.item(i))
                    })

        return bookShelf
    }

    function createManuscriptBook(notebook) {
        return HWR.asyncCall("Handwritten", "js", "getNotebookDefine", notebook).then(
                    (ret) => {
                        manuscriptDB.transaction(
                            (tx)=>{
                                maxBookID++
                                tx.executeSql('INSERT INTO ManuscriptBook (`id`,`cover`,`paper`,`stroke`) VALUES (?,?,?,?)', [maxBookID, ret.cover, ret.paper, ret.stroke])
                            })
                    })
    }

    function updateManuscriptData(msid) {
        var ids = splitMSID(msid)
        if (ids === false)
            return

        var b_id = ids[0]
        var p_id = ids[1]

//        byteArray.toStrokesRawData(manuscriptCache[msid])

        manuscriptDB.transaction(
                    (tx)=>{
                        var res = tx.executeSql('SELECT * FROM `v_Manuscript` WHERE `id`=?', [msid])
                        var newData
                        if (res.rows.length === 0) {
                            newData = StrokeData.toStrokesRawData(manuscriptCache[msid])
                            tx.executeSql("INSERT INTO v_Manuscript (`b_id`, `p_id`, `data`) VALUES (?, ?, ?)", [b_id, p_id, newData])
                        } else {
                            newData = (res.rows.item(0).data || "") + StrokeData.toStrokesRawData(manuscriptCache[msid])
                            manuscriptCache[msid] = []
                            tx.executeSql("UPDATE v_Manuscript SET data=? WHERE id=?", [newData,msid])
                        }
                    })
    }

    function closeManuscriptBook () {
        for (var x in manuscriptCache)
            updateManuscriptData(x)
    }

    function manuscriptPage(msid) {
        var ids = splitMSID(msid)
        if (ids === false)
            return false

        var b_id = ids[0]
        var p_id = ids[1]

        var res

        manuscriptDB.transaction (
            (tx)=>{
                res = tx.executeSql('SELECT * FROM `v_Manuscript` WHERE `id`=?', [msid])
            })
        if (res.rows.length > 0)
            return res.rows.item(0)
        else
            return false
    }

    function getPaperDefine(msid) {
        var row = { paper: "", stroke: "" }
        var ok = false
        manuscriptDB.transaction(
                    (tx)=>{
                        var res = tx.executeSql('SELECT * FROM `v_Manuscript` WHERE `id`=?', [msid])
                        if (res.rows.length > 0) {
                            row = res.rows.item(0)
                            ok = true
                        }
                    })
        return ok ? {
                        paper: row.paper,
                        stroke: row.stroke
                    } : false
    }


    Component.onCompleted: {
        try {
            manuscriptDB.transaction(
                (tx)=> {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS ManuscriptBook (id INTEGER PRIMARY KEY, cover TEXT, paper TEXT, stroke TEXT);')
                    tx.executeSql("CREATE TRIGGER IF NOT EXISTS delete_ManuscriptBook DELETE ON ManuscriptBook BEGIN DELETE FROM ManuscriptPage WHERE mb_id = OLD.id;END;")
                    tx.executeSql("CREATE TRIGGER IF NOT EXISTS insert_ManuscriptBook AFTER INSERT ON ManuscriptBook BEGIN INSERT INTO v_Manuscript (p_id, b_id) VALUES (0, NEW.id);END;")

                    tx.executeSql('CREATE TABLE IF NOT EXISTS ManuscriptPage (id INTEGER,mb_id INTEGER,d_id INTEGER,PRIMARY KEY (id,mb_id));')
                    tx.executeSql("CREATE TRIGGER IF NOT EXISTS delete_manuscriptPage DELETE ON ManuscriptPage BEGIN DELETE FROM StrokeData WHERE id = OLD.d_id;END;")

                    tx.executeSql('CREATE TABLE IF NOT EXISTS StrokeData (id INTEGER PRIMARY KEY UNIQUE,data TEXT);')

                    tx.executeSql("CREATE VIEW IF NOT EXISTS v_Manuscript AS SELECT a.mb_id || 'p' || a.id AS id, a.mb_id AS b_id, a.id AS p_id, CASE a.id WHEN 0 THEN b.cover ELSE b.paper END AS paper, b.stroke, a.d_id, d.data FROM ManuscriptPage AS a LEFT JOIN ManuscriptBook AS b ON a.mb_id = b.id LEFT JOIN StrokeData AS d ON a.d_id = d.id;")
                    tx.executeSql("CREATE TRIGGER IF NOT EXISTS delete_Manuscript INSTEAD OF DELETE ON v_Manuscript BEGIN DELETE FROM StrokeData WHERE id = OLD.d_id; DELETE FROM ManuscriptPage WHERE id = OLD.p_id;END;")
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
