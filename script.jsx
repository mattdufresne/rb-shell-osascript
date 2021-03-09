var filePath = arguments[0];
var companionFilePath = arguments[1];

var reportPath = filePath + "-report.txt"
report = new File(reportPath);
report.encoding='UTF-8';
report.open('w');

var isbn = getIsbn()
setCompanionIsbn(isbn, companionFilePath)
report.write(isbn);

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
    alert(isbn);
    return isbn;
}

function setCompanionIsbn(isbn, companionFilePath) {
    app.open(companionFilePath)
    alert(companionFilePath)
    alert("Setting companion with " + isbn)
    var textFrame = app.activeDocument.pages[0].textFrames.add();
    textFrame.properties = {geometricBounds: [0,0,0,0], label: isbn}
}

report.close('w');
// app.activeDocument.close(SaveOptions.yes);