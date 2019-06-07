import ceylon.file {
    forEachLine,
    Resource,
    File,
    parsePath,
    lines,
    Directory,
    Visitor,
    home
}


variable Boolean flag = false;

shared void readFile(String filePath) {


    Resource resource = parsePath(filePath).resource;

    if (is File resource) {

        variable String textOfFile=""; //fainel result
        variable String tokens="";
        variable String pathForVMlFile ="";
        variable String dict = resource.directory.string;

        value index =resource.name.indexOf(".");
        variable String nameOfFile = resource.name.substring(0,index);

        tokens += "<tokens>\n";


        forEachLine(resource, (String line) {
            String result = makeTokens(line);
            if(result != ""){
                tokens +=result;
            }
        });

        tokens += "</tokens>";


        //Parser
        textOfFile = makeParsering(tokens);
        //Print a Tree
        pathForVMlFile = changeNameOfSuffix(resource.name,dict,false);
        writeFileVM(pathForVMlFile,textOfFile);
        textOfFile ="";
    }

}



String changeNameOfSuffix(String name,String dict,Boolean isTokens){
    value index =name.indexOf(".");
    variable String newName = name.substring(0,index);

    newName+= ".vm";
    return dict+"\\"  + newName;
}

String makeTokens(String line){
  //return String of tokens for the current line


    if(flag){
        if(line.contains("*/")){
            flag = false;
        }
        return"";
    }


    variable Integer index =0;
    variable String tmp ="";
    variable String tmp_ =" ";
    tmp =line;

    while(tmp_.startsWith(" ")){
        index++;
        tmp_ = tmp.substring(index);
    }
    if(index ==1){
        tmp_ = tmp.substring(0);
    }

    if(tmp_.startsWith("/")){
        if(tmp_.startsWith("/*") && !tmp_.contains("*/")){
            flag =true;
        }
        return "";
    }
    return tokenizer(tmp_);
}

String makeParsering(String line){
   // return the tree
    return parsering(line);
}



