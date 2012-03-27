import QtQuick 1.1

ListView {
    id: view
    anchors.fill: parent

    property string peerName;
    // model to be set by Loader!

    delegate: Image {
        width: parent.width
        fillMode: Image.PreserveAspectFit
        source: "http://" + view.peerName + ":1337/picture/thumbnail/" + modelData
    }
}
