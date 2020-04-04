function toRaw(data, bytes) {
    var rawData = []
    for (var i = bytes - 1; i >= 0; i--) {
        rawData[i] = String.fromCharCode(data & 0xff)
        data >>= 8
    }
    return rawData.join('')
}
function toStrokesRawData(data) {
    var rawData = "";

    for (var i in data) {
        var _data_ = data[i];
        rawData += toRaw(_data_.type << 6 | _data_.color << 4 | _data_.shade, 1);
        rawData += toRaw(parseInt(_data_.preSize * 100), 2);
        rawData += toRaw(parseInt(_data_.size * 100), 2);
        rawData += toRaw(parseInt(_data_.prePos.x * 10), 2);
        rawData += toRaw(parseInt(_data_.prePos.y * 10), 2);
        rawData += toRaw(parseInt(_data_.pos.x * 10), 2);
        rawData += toRaw(parseInt(_data_.pos.y * 10), 2);
    }

    return rawData
}

function base64ToStrokes(data) {
    console.log("in base64ToStrokes")
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
