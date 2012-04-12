import QtQuick 1.1
import com.nokia.meego 1.0

GridView {
    id: view
    anchors.fill: parent

    signal itemSelected(int id);
    cellWidth: width/2.0
    cellHeight: cellWidth

    property string peerName;
    // model to be set by Loader!

    delegate: Item {
        width: GridView.view.cellWidth
        height: GridView.view.cellHeight

        Image {
            id: image

            width: parent.width
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            fillMode: Image.PreserveAspectFit

            source: modelData > 0 ? "http://" + view.peerName + ":1337/video/thumbnail/" + modelData : ""



            onStatusChanged: {
                if(image.status == Image.Ready)
                    inAnimation.start()
                else if(image.status == Image.Error) {

                }
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
            font.pixelSize: GridView.view.cellHeight
            visible: modelData == 0

        }

        MouseArea {
            anchors.fill: parent
            onClicked: itemSelected(modelData)
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
