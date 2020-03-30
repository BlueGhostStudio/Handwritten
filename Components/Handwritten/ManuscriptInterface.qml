pragma Singleton

import QtQuick 2.13

QtObject {
    signal strokeUpdated(int sHwType, var sHwID, var sHwStroke)

    function write(hwID, stroke) {
        console.log("in manuscript write")
        strokeUpdated(2, hwID, stroke)
    }
}
