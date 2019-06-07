import ceylon.file {
    parsePath,
    Directory,
    Resource,
    forEachLine,
    File
}

"Run the module `main`."


shared void main() {

    openDict("D:/CeylonExercises/project 10/ArrayTest");
    openDict("D:/CeylonExercises/project 10/Square");

    String path1 = "D:/CeylonExercises/project 10/ExpressionlessSquare/MainT.xml";
    String path2 = "D:/CeylonExercises/project 10/ExpressionlessSquare/SquareGameT.xml";
    String path3 = "D:/CeylonExercises/project 10/ExpressionlessSquare/SquareT.xml";

    Resource resource1 = parsePath(path1).resource;
    Resource resource2 = parsePath(path2).resource;
    Resource resource3 = parsePath(path3).resource;

    if (is File resource1) {
        variable String textOfFile = "";
        variable String pathForXmlFile ="";

        forEachLine(resource1, (String line) {
            textOfFile += line+ "\n";
        });
        print(textOfFile);
        textOfFile = parsering(textOfFile);
        pathForXmlFile = changeNameOfSuffix(resource1.name,resource1.directory.string,false);
        writeFileXml(pathForXmlFile,textOfFile);

    }

    if (is File resource2) {
        variable String textOfFile = "";
        variable String pathForXmlFile ="";

        forEachLine(resource2, (String line) {
            textOfFile += line+"\n";
        });
        parsering(textOfFile);
        textOfFile = parsering(textOfFile);
        pathForXmlFile = changeNameOfSuffix(resource2.name,resource2.directory.string,false);
        writeFileXml(pathForXmlFile,textOfFile);

    }
    if (is File resource3) {
        variable String textOfFile = "";
        variable String pathForXmlFile ="";

        forEachLine(resource3, (String line) {
            textOfFile += line+"\n";
        });
        parsering(textOfFile);
        textOfFile = parsering(textOfFile);
        pathForXmlFile = changeNameOfSuffix(resource3.name,resource3.directory.string,false);
        writeFileXml(pathForXmlFile,textOfFile);

    }
}