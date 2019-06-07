import ceylon.file {
    Resource,
    createFileIfNil,
    File,
    parsePath,
    Nil
}
"Run the module `writeFile`."


void writeFileVM(String filePath,String text) {

    Resource resource = parsePath(filePath).resource;
    if (is File|Nil resource) {
        File file = createFileIfNil(resource);

        try (appender = file.Appender()) { //Appender not remove the exists text
            appender.write(text);
        }
    }

}
