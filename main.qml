import QtQuick 2.13
import QtQuick.Controls 2.13
import BGMRPC 1.0
import Handwritten 1.0

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Tabs")

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: SwipeView {
            id: swipeView
            currentIndex: tabBar.currentIndex

            Page1Form {
            }

            Page2Form {
            }
        }
    }

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex

        TabButton {
            text: qsTr("Page 1")
        }
        TabButton {
            text: qsTr("Page 2")
        }
    }

    Component {
        id: test
        HWPaint {}
    }

    Component.onCompleted: {
        /*HWR.join("b").then(function (ret) {
            console.log("---")
        })*/
        HWR.active = true
        HWR.statusChanged.connect (function () {
            HWR.join("g")
        })
    }
}
