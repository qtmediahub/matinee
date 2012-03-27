import QtQuick 1.1
import com.nokia.meego 1.0

ListView {
    id: view
    anchors.fill: parent

    property string peerName;
    // model to be set by Loader!

    delegate: Item {
        width: parent.width
        height: image.status == Image.Ready ? image.height : placeHolder.height + 50

        Behavior on height { NumberAnimation { duration: 300 } }

        Image {
            id: image
            width: parent.width
            fillMode: Image.PreserveAspectFit
            source: "http://" + view.peerName + ":1337/picture/thumbnail/" + modelData
        }
        BusyIndicator {
            id: placeHolder
            platformStyle: BusyIndicatorStyle { size: "large" }
            running: image.status != Image.Ready
            visible: image.status != Image.Ready
            anchors.centerIn: parent
        }
    }
}
