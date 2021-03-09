
var reportPath = arguments[1] + "-report.txt"
report = new File(reportPath);
report.encoding='UTF-8';
report.open('w');

if (arguments[0] == 'cover') {
    var isbn = getIsbn()
    alert(isbn);
    report.write(isbn);
} else if (arguments[0] == 'insides') {
    report.write("insides");
} else {
    report.write("failed to detect file type by file name");
}

function getIsbn() {
    var isbn = null;
    for (var i = 0; i < app.activeDocument.stories.length; i++){
        var story = app.activeDocument.stories.item(i);
        var lines = story.lines;

        for (var j = 0; j < lines.length; j++){
            var contents = lines[j].contents;
            if (contents.match(/isbn/i) && !contents.match(/set/i)) {
                isbn = contents;
                lines[j].parentStory.textContainers[0].label = isbn;
                break;
            }
        }
    }
    return isbn;
}

report.close('w');
// app.activeDocument.close(SaveOptions.yes);