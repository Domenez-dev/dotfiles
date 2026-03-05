pragma Singleton

import qs.modules.common
import qs.modules.common.functions
import Quickshell

/**
 * - Eases fuzzy searching for applications by name
 * - Guesses icon name for window class name
 */
Singleton {
    id: root
    property bool sloppySearch: Config.options?.search.sloppy ?? false
    property real scoreThreshold: 0.2
    property var substitutions: ({
        "code-url-handler": "visual-studio-code",
        "Code": "visual-studio-code",
        "gnome-tweaks": "org.gnome.tweaks",
        "pavucontrol-qt": "pavucontrol",
        "wps": "wps-office2019-kprometheus",
        "wpsoffice": "wps-office2019-kprometheus",
        "footclient": "foot",
    })
    property var regexSubstitutions: [
        {
            "regex": /^steam_app_(\d+)$/,
            "replace": "steam_icon_$1"
        },
        {
            "regex": /Minecraft.*/,
            "replace": "minecraft"
        },
        {
            "regex": /.*polkit.*/,
            "replace": "system-lock-screen"
        },
        {
            "regex": /gcr.prompter/,
            "replace": "system-lock-screen"
        }
    ]

    // Deduped list to fix double icons
    readonly property list<DesktopEntry> list: Array.from(DesktopEntries.applications.values)
        .filter((app, index, self) => 
            index === self.findIndex((t) => (
                t.id === app.id
            ))
    )
    
    readonly property var preppedNames: list.map(a => ({
        name: Fuzzy.prepare(`${a.name} `),
        entry: a
    }))

    readonly property var preppedIcons: list.map(a => ({
        name: Fuzzy.prepare(`${a.icon} `),
        entry: a
    }))

    function fuzzyQuery(search: string): var { // Idk why list<DesktopEntry> doesn't work
        if (root.sloppySearch) {
            const results = list.map(obj => ({
                entry: obj,
                score: Levendist.computeScore(obj.name.toLowerCase(), search.toLowerCase())
            })).filter(item => item.score > root.scoreThreshold)
                .sort((a, b) => b.score - a.score)
            return results
                .map(item => item.entry)
        }

        return Fuzzy.go(search, preppedNames, {
            all: true,
            key: "name"
        }).map(r => {
            return r.obj.entry
        });
    }

    function iconExists(iconName) {
        if (!iconName || iconName.length == 0) return false;
        return (Quickshell.iconPath(iconName, true).length > 0) 
            && !iconName.includes("image-missing");
    }

    function getReverseDomainNameAppName(str) {
        return str.split('.').slice(-1)[0]
    }

    function getKebabNormalizedAppName(str) {
        return str.toLowerCase().replace(/\s+/g, "-");
    }

    function getUndescoreToKebabAppName(str) {
        return str.toLowerCase().replace(/_/g, "-");
    }

    property var iconCache: ({})

    function guessIcon(str) {
        if (!str || str.length == 0) return "image-missing";
        
        if (iconCache[str]) return iconCache[str];

        let result = "application-x-executable";
        const entry = DesktopEntries.byId(str);
        if (entry) {
            result = entry.icon;
        } else if (substitutions[str]) {
            result = substitutions[str];
        } else if (substitutions[str.toLowerCase()]) {
            result = substitutions[str.toLowerCase()];
        } else {
            // Regex substitutions
            let regexMatch = false;
            for (let i = 0; i < regexSubstitutions.length; i++) {
                const substitution = regexSubstitutions[i];
                const replacedName = str.replace(substitution.regex, substitution.replace);
                if (replacedName != str) {
                    result = replacedName;
                    regexMatch = true;
                    break;
                }
            }

            if (!regexMatch) {
                if (iconExists(str)) {
                    result = str;
                } else {
                    const lowercased = str.toLowerCase();
                    if (iconExists(lowercased)) {
                        result = lowercased;
                    } else {
                        const reverseDomainNameAppName = getReverseDomainNameAppName(str);
                        if (iconExists(reverseDomainNameAppName)) {
                            result = reverseDomainNameAppName;
                        } else {
                            const lowercasedDomainNameAppName = reverseDomainNameAppName.toLowerCase();
                            if (iconExists(lowercasedDomainNameAppName)) {
                                result = lowercasedDomainNameAppName;
                            } else {
                                const kebabNormalizedGuess = getKebabNormalizedAppName(str);
                                if (iconExists(kebabNormalizedGuess)) {
                                    result = kebabNormalizedGuess;
                                } else {
                                    const undescoreToKebabGuess = getUndescoreToKebabAppName(str);
                                    if (iconExists(undescoreToKebabGuess)) {
                                        result = undescoreToKebabGuess;
                                    } else {
                                        // Search in desktop entries
                                        const iconSearchResults = Fuzzy.go(str, preppedIcons, { all: true, key: "name" }).map(r => r.obj.entry);
                                        if (iconSearchResults.length > 0 && iconExists(iconSearchResults[0].icon)) {
                                            result = iconSearchResults[0].icon;
                                        } else {
                                            const nameSearchResults = root.fuzzyQuery(str);
                                            if (nameSearchResults.length > 0 && iconExists(nameSearchResults[0].icon)) {
                                                result = nameSearchResults[0].icon;
                                            } else {
                                                const heuristicEntry = DesktopEntries.heuristicLookup(str);
                                                if (heuristicEntry) result = heuristicEntry.icon;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        iconCache[str] = result;
        return result;
    }
}
