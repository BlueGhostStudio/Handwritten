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
function toBase64(data) {
    return byteArray.btoa(toStrokesRawData(data));
}
