
if (arguments[0] == 'cover') {
    getIsbn()
} else if (arguments[0] == 'insides') {
    alert(arguments[0] + " == insides")
}

function getIsbn() {
    var isbn = null;
    for (var i = 0; i < app.activeDocument.stories.length; i++){
        var story = app.activeDocument.stories.item(i);
        var lines = story.lines;

        for (var j = 0; j < lines.length; j++){
            var contents = lines[j].contents;
            if (contents.match(/isbn/i) && !contents.match(/set/i)) {
                alert(contents)
                isbn = contents;
                break;
            }
        }
    }
    return isbn;
}
app.activeDocument.close(SaveOptions.no);