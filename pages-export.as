on run argv
    set inFile to item 1 of argv
    set outFile to item 2 of argv
    tell application "Pages"
        activate
	set inMacFile to POSIX file inFile as alias
        open inMacFile
        export front document to POSIX file outFile as unformatted text
        close front document
    end tell
end run
