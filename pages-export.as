on run argv
    set inFile to item 1 of argv
    set outFile to item 2 of argv
    tell application "Pages"
        activate
	set inMacFile to POSIX file inFile as alias
        set doc to open inMacFile
        export doc to POSIX file outFile as Microsoft Word
        close doc
    end tell
end run
