
import ceylon.file {
    File,
    parsePath,
    Directory
}

"Run the module `openDict`."

shared void openDict(String dictPath){

    value resource_ = parsePath(dictPath).resource;


    if (is Directory resource_) {

    for (path in resource_.childPaths("*.jack")) {
        String currentFilePhath = path.string;
        value pathOfF = parsePath(currentFilePhath).resource;

        readFile(currentFilePhath);
    }

        }
    }