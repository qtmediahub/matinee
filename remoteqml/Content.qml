import QtQuick 1.1
import com.nokia.meego 1.0

GridView {
    id: view
    anchors.fill: parent

    signal itemSelected(int id);
    cellWidth: width/2.0
    cellHeight: cellWidth

    property string peerName;
    property string contentTypeString
    // model to be set by Loader!

    delegate: Item {
        id: delegate
        width: GridView.view.cellWidth
        height: GridView.view.cellHeight

        Image {
            id: image

            width: parent.width
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            fillMode: Image.PreserveAspectFit

            source: "http://" + view.peerName + ":1337/" + contentTypeString + modelData

            onStatusChanged: {
                if(image.status == Image.Ready)
                    inAnimation.start()
            }

            NumberAnimation {
                id: inAnimation
                target: image;
                property: "anchors.horizontalCenterOffset";
                from: index%2 ? -image.width : image.width;
                to: 0;
                easing.type: Easing.OutElastic
                duration: 1000
            }
        }

        ToolIcon {
            anchors.centerIn: parent
            iconId: "toolbar-up";
            visible: modelData == -1
        }

        Text {
            anchors.centerIn: parent
            text: "?"
            font.pixelSize: delegate.height
            visible: image.status == Image.Error
        }

        MouseArea {
            anchors.fill: parent
            onClicked: itemSelected(modelData)
        }

        BusyIndicator {
            id: placeHolder
            platformStyle: BusyIndicatorStyle { size: "large" }
            running: image.status == Image.Loading && modelData != -1
            visible: image.status == Image.Loading && modelData != -1
            anchors.centerIn: parent
        }
    }
}
