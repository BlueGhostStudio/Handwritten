.pragma library

function textColor(c, op) {
    return c.hslLightness > 0.7 ? Qt.rgba(0, 0, 0, op || 1) : Qt.rgba(1, 1, 1, op || 1)
}

function opacity(c, op) {
    //console.log(c, c.r, c.g, c.b)
    return Qt.rgba(c.r, c.g, c.b, op)
}
