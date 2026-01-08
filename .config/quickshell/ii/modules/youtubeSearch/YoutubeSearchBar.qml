import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts 1.15 // Added for RowLayout
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import "../../services"

Scope {
    id: root

    property bool isOpen: false

    YoutubeSearch { id: ytService }

    Loader {
        id: searchLoader
        active: root.isOpen

        sourceComponent: PanelWindow {
            id: panelWindow

            // Layershell configuration
            WlrLayershell.namespace: "quickshell:youtubeSearch"
            WlrLayershell.layer: WlrLayer.Overlay
            exclusionMode: ExclusionMode.Ignore
            
            // Make the window background transparent so we see our rounded corners
            color: "transparent" 

            // Slightly taller for a "hero" input feel
            implicitWidth: 600
            implicitHeight: 60 

            // Hyprland focus logic
            HyprlandFocusGrab {
                id: grab
                windows: [ panelWindow ]
                active: searchLoader.active
                onCleared: () => { root.isOpen = false; }
            }

            // --- MAIN CONTAINER ---
            Rectangle {
                anchors.fill: parent
                // Dark background color (Dark Grey/Blue)
                color: "#1e1e2e" 
                // Fully rounded corners (Pill shape)
                radius: height / 2 
                
                // Subtle border
                border.color: "#45475a" 
                border.width: 1

                // Drop Shadow (Simulated with a second rectangle behind if needed, 
                // but for simplicity, we just stick to the border here)

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    spacing: 15

                    // 1. Search Icon (Visual Flair)
                    Text {
                        text: "🔍" // or use a font icon like "\uf002"
                        font.pixelSize: 22
                        color: "#a6adc8" // Muted text color
                        Layout.alignment: Qt.AlignVCenter
                    }

                    // 2. The Input Field
                    TextField {
                        id: searchInput
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        
                        placeholderText: "Search YouTube..."
                        font.pixelSize: 18
                        font.family: "Sans Serif" // Replace with your system font
                        
                        // Text styling
                        color: "#cdd6f4" // Light text
                        placeholderTextColor: "#585b70" // Dimmed placeholder
                        
                        // Cursor and Selection
                        cursorDelegate: Rectangle {
                            color: "#89b4fa" // Bright blue cursor
                            width: 2
                        }
                        selectionColor: "#45475a"
                        selectedTextColor: "#ffffff"

                        // Remove default ugly white background
                        background: Item {} 

                        // Focus logic
                        Component.onCompleted: forceActiveFocus()

                        onAccepted: {
                            if (text !== "") {
                                ytService.search(text);
                                text = "";
                                root.isOpen = false;
                            }
                        }

                        Keys.onEscapePressed: root.isOpen = false
                    }
                }
            }
        }
    }

    function toggle() {
        root.isOpen = !root.isOpen
    }

    IpcHandler {
        target: "youtubeSearch"
        function toggle(): void { root.toggle(); }
    }
}
