import QtQuick
import Quickshell

QtObject {
    id: ytServiceRoot

    function search(query) {
        if (!query || query.trim() === "") return;
        
        const url = "https://www.youtube.com/results?search_query=" + encodeURIComponent(query.trim());
        
        console.log("Searching YouTube for:", query);
        console.log("Opening URL:", url);

        Quickshell.execDetached(["zen-browser", url]);
    }
}
