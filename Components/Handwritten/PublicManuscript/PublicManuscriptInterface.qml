pragma Singleton

import QtQuick 2.13
import QtWebSockets 1.13
import QtQuick.LocalStorage 2.13
import "../StrokeData.js" as StrokeData
import ".."

QtObject {

    signal publishPageProgress(int value, int total)
    signal publishManuscriptProgress(int value, int total)
    signal newPublicManuscriptBook(int id, var titleStrokesData)
    signal rewrittenPublicManuscriptBookTitle(int id, var titleStrokesData)
    signal rewrittenPublicManuscriptTitle(int id, var titleStrokesData)
    signal deletedPublicManuscriptBook(int id)
    signal deletedPublicManuscript(int id)
    signal deletedPublicManuscriptPage(int id)
    signal resetSeqPublicManuscriptBook(int id, int seq)
    signal resetSeqPublicManuscript(int id, int seq)

    function createPublicManuscriptBook(titleStrokes) {
        return HWR.asyncCall("Handwritten", "js",
                             "createPublicManuscriptBook",
                             titleStrokes).then(
                    (ret)=>{
                        newPublicManuscriptBook(ret.id, ret.title)
                    })
    }

    function rewritePublicManuscriptBookTitle(pb_id, titleStrokes) {
        return HWR.asyncCall("Handwritten", "js",
                             "rewritePublicManuscriptBookTitle", pb_id,
                             titleStrokes).then(
                    (ret)=>{
                        if (ret !== false)
                            rewrittenPublicManuscriptBookTitle(ret.id, ret.title)
                    })
    }

    function deletePublicManuscriptBook(pb_id) {
        return HWR.asyncCall("Handwritten", "js",
                             "deletePublicManuscriptBook", pb_id).then(
                    (ret)=>{
                        if (ret !== false)
                            deletedPublicManuscriptBook(ret)
                    })
    }

    function publishManuscriptPage(pm_id, paperDefine, b_id, p_id) {
        function postPageData(pageData, pos) {
            if (pos >= pageData.length) {
                publishPageProgress(pageData.length, pageData.length)
                return Promise.resolve(true)
            } else
                return HWR.asyncCall("Handwritten", "js", "publishManuscriptPage",
                                     pm_id, pageData.slice(pos, pos + 4096)).then(
                            (ret)=>{
                                if (ret === false)
                                  return Promise.resolve(false)
                                else {
                                    publishPageProgress(pos, pageData.length)
                                    return postPageData(pageData, pos + 4096)
                                }
                            })
        }

        var page = MSCR.manuscriptPage(b_id + 'p' + p_id)
        if (page === false || page.data === null)
            return Promise.resolve(false)

        return HWR.asyncCall("Handwritten", "js", "publishManuscriptPageBegin", pm_id,
                             p_id === 0 ? paperDefine.cover : paperDefine.paper,
                             p_id).then(
                    ()=>{
                        return postPageData(page.data, 0)
                    }).then(
                    (ret)=>{
                        console.log("====>", ret)
                        if (ret)
                            return HWR.asyncCall("Handwritten", "js", "publishManuscriptPageEnd", pm_id);
                    })
    }

    function publishPages2Manuscript(pm_id, b_id, pages) {
        var paperDefine = MSCR.getPaperDefine(b_id)
        function postPages (p) {
            publishManuscriptProgress(p, pages.length)
            if (p >= pages.length) {
                console.log("publish manuscript finisted");
                return Promise.resolve(true)
            } else
                return publishManuscriptPage(pm_id, paperDefine, b_id, pages[p]).then(
                            (ret)=>{
                                console.log(ret)
                                if (!ret)
                                    console.log("post fail")

                                return postPages(p + 1)
                            })
        }

        return postPages(0)
    }

    function publishNewManuscript(pb_id, titleStrokes, b_id, pages) {
        /*var paperDefine = MSCR.getPaperDefine(b_id)
        function postPages (pm_id, p) {
            publishManuscriptProgress(p, pages.length)
            if (p >= pages.length) {
                console.log("publish manuscript finisted");
                return Promise.resolve(true)
            } else
                return publishManuscriptPage(pm_id, paperDefine, b_id, pages[p]).then(
                            (ret)=>{
                                console.log(ret)
                                if (!ret)
                                    console.log("post fail")

                                return postPages(pm_id, p + 1)
                            })
        }*/

        return HWR.asyncCall("Handwritten", "js", "publishManuscript", pb_id, titleStrokes).then(
                    (pm_id)=>{
                        if (pm_id >= 0)
                            return publishPages2Manuscript(pm_id, b_id, pages)
//                            return postPages(pm_id, 0)
                        else
                            return Promise.resolve(false)
                    })
    }

    function rewritePublicManuscriptTitle(pm_id, titleStrokes) {
        return HWR.asyncCall("Handwritten", "js",
                             "rewritePublicManuscriptTitle",
                             pm_id, titleStrokes).then(
                    (ret)=>{
                        if (ret !== false)
                            rewrittenPublicManuscriptTitle(ret.id, ret.title)
                    })
    }

    function deletePublicManuscript(pm_id) {
        return HWR.asyncCall("Handwritten", "js",
                             "deletePublicManuscript", pm_id).then(
                    (ret)=>{
                        if (ret !== false)
                            deletedPublicManuscript(ret)
                    })
    }

    function deletePublicManuscriptPage(pm_id) {
        return HWR.asyncCall("Handwritten", "js",
                             "deletePublicManuscriptPage", pm_id).then(
                    (ret)=>{
                        if (ret !== false)
                            deletedPublicManuscriptPage(ret)
                    })
    }

    function publicManuscriptBooks() {
        return HWR.asyncCall("Handwritten", "js", "publicManuscriptBooks")
    }

    function publicManuscripts(bid) {
        return HWR.asyncCall("Handwritten", "js", "publicManuscripts", bid)
    }

    function publicManuscriptPages(mid) {
        return HWR.asyncCall("Handwritten", "js", "publicManuscriptPages", mid)
    }

    function resequenceManuscriptBook(pm_id, seq) {
        return HWR.asyncCall("Handwritten", "js",
                             "resequenceManuscriptBook", pm_id, seq).then(
                    (ret)=>{
                        console.log("0000", ret)
                        if (ret)
                            resetSeqPublicManuscriptBook(pm_id, seq)
                    })
    }
    function resequenceManuscript(pm_id, seq) {
        return HWR.asyncCall("Handwritten", "js",
                             "resequenceManuscript", pm_id, seq).then(
                    (ret)=>{
                        if (ret)
                            resetSeqPublicManuscript(pm_id, seq)
                    })
    }
}
