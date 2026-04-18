import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland 1.0 // Explicit versioning sometimes helps resolution

Scope {
    id: scope
    property bool active: false

    // We use a LazyLoader here. It won't try to create the 'WlrWindow' type 
    // until you actually trigger the search, which prevents the startup error.
    property alias loader: widgetLoader

    LazyLoader {
        id: widgetLoader
        active: scope.active
        
        component: WlrWindow {
            id: searchWindow
            width: 600
            height: 80
            anchors.centerIn: Parent
            
            exclusive: false
            focusable: true
            layer: WlrLayer.Top

            Rectangle {
                anchors.fill: parent
                color: "#1e1e2e"
                radius: 12
                border.color: "#89b4fa"
                border.width: 2

                TextField {
                    id: searchInput
                    anchors.fill: parent
                    anchors.margins: 10
                    placeholderText: "Search YouTube..."
                    color: "white"
                    font.pixelSize: 24
                    background: Item {}

                    Component.onCompleted: forceActiveFocus()

                    onAccepted: {
                        if (text.trim() !== "") {
                            Qt.openUrlExternally("https://www.youtube.com/results?search_query=" + encodeURIComponent(text.trim()));
                            searchInput.text = "";
                            scope.active = false;
                        }
                    }
                }
            }
            // Close on escape
            Keys.onEscapePressed: scope.active = false
        }
    }
}
