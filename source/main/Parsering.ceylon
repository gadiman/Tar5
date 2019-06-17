import java.util {
    ArrayList,
    LinkedList
}
import ceylon.file {
    forEachLine
}

variable String result = "";
variable Integer currTok = 1;
variable Integer numOfFields = 0;
variable Integer numOfIF = 0;
variable Integer numOfWhile = 0;
variable Integer numOfList = 0;
variable Boolean isMethod = false;
variable Boolean isConstructor = false;
variable String subName = "";
variable String className = "";

SymbolTable symbolTable = SymbolTable();

variable String space = "";


shared String  parsering(String tokens) {

    result = "";
    value tmp_ =tokens.lines;
    value arrayOfTokens =  LinkedList<String>();

    for (token in tmp_ ){
        arrayOfTokens.add(token);
    }



    currTok=1;
    classFun(arrayOfTokens);
    return result;



}


void classFun (LinkedList<String> tokens){
    currTok++; // The word "Class"
    //get the name of class
    String tmp = tokens.get(currTok);
    value index =tmp.indexOf(">");  //  <identifier> class name </identifier>
    value index_ =tmp.indexOf("/");
    className = tmp.substring(index+2,index_-2);

    currTok++; // Calss name
    currTok++; // {

    while(cleanTok(tokens.get(currTok)).contains("static") || tokens.get(currTok).contains("field")){
        if(tokens.get(currTok).contains("field")){
            numOfFields++;
        }
        classVarDecFun(tokens);
    }

    while(cleanTok(tokens.get(currTok))== "constructor" ||
    cleanTok(tokens.get(currTok)) == "function" ||
    cleanTok(tokens.get(currTok)) == "method") {

        symbolTable.startSubroutine();
        resetCounters();

        if(cleanTok(tokens.get(currTok)) == "method"){
            symbolTable.define("this", className ,"arg");
        }

        subrotineDecFun(tokens);


    }


    currTok++; // }


}

void classVarDecFun (LinkedList<String> tokens) {

    variable String name= cleanTok(tokens.get(currTok++));
    value type =cleanTok(tokens.get(currTok++));
    value kind =cleanTok(tokens.get(currTok++));
    symbolTable.define(name,type,kind);

    while (cleanTok(tokens.get(currTok)) == "," ) {
        if(kind == "field")
        {
            numOfFields++;
        }
        currTok++; // for ','
        name= cleanTok(tokens.get(currTok++));
        symbolTable.define(name,type,kind);
    }
    currTok++; // for ';'

}

void parameterListFunc(LinkedList<String> tokens){

    variable String name;
    variable String type ;

    if( cleanTok(tokens.get(currTok)) != ")" )
    {
        type = cleanTok(tokens.get(currTok++));
        name = cleanTok(tokens.get(currTok++));
        symbolTable.define(name, type, "arg");

        while(cleanTok(tokens.get(currTok)) == "," )
        {
            // ,
            currTok++; //for ','
            type = cleanTok(tokens.get(currTok++));
            name = cleanTok(tokens.get(currTok++));
            symbolTable.define(name, type, "arg");
        }
    }

}


void subrotineDecFun (LinkedList<String> tokens) {

    if(cleanTok(tokens.get(currTok)) == "method"){
        isMethod = true;
    }
    else if (cleanTok(tokens.get(currTok)) == "constructor"){
        isConstructor = true;
    }

    currTok++; // "constructor" or "method"
    currTok++; //return type;
    subName = cleanTok(tokens.get(currTok++));
    currTok++; // for '('
    parameterListFunc(tokens);
    currTok++; // for ')'
    subrutinBodyFunc(tokens);

}

void subrutinBodyFunc(LinkedList<String> tokens){

    currTok++;// for '{'

    while(cleanTok(tokens.get(currTok)) == "var"){
        varDecFunc(tokens);
    }
    result += "function " + className+ "."+ subName + " "+ symbolTable.varCount().string + "\n";

    if(isMethod){
        result += "push argument 0\n";
        result += "pop pointer 0\n";
    }
    else if(isConstructor){
        result += "push constant "+ numOfFields.string+ "\n";
        result += "call Memory.alloc 1\n";
        result += "pop pointer 0\n";
    }
    statementsFunc(tokens);
    currTok++;// for '}'

}

void varDecFunc(LinkedList<String> tokens) {
    variable String name;
    variable String type;
    currTok++; // keyword "var"
    type = cleanTok(tokens.get(currTok++));
    name = cleanTok(tokens.get(currTok++));
    symbolTable.define(name, type, "var");

    while(cleanTok(tokens.get(currTok))== ","){
        currTok++; // for ','
        name = cleanTok(tokens.get(currTok++));
        symbolTable.define(name, type, "var");
    }

    currTok++; // for ';'
}

void statementsFunc(LinkedList<String> tokens) {

    while(cleanTok(tokens.get(currTok)) != "}"){
        if(cleanTok(tokens.get(currTok)) =="let"){
            letStatementFunc(tokens);
        }else if(cleanTok(tokens.get(currTok)) == "if"){
            ifStatementFunc(tokens);
        }else if(cleanTok(tokens.get(currTok)) == "while"){
            whileStatementFunc(tokens);
        }else if(cleanTok(tokens.get(currTok)) == "do"){
            doStatementFunc(tokens);
            result += "pop temp 0\n";
        }else if(cleanTok(tokens.get(currTok)) == "return"){
            returnStatementFunc(tokens);
        }

    }
}

void letStatementFunc(LinkedList<String> tokens) {

    variable Boolean isArray = false;
    variable String varName;
    currTok++; //for keyword "let"
    varName = cleanTok(tokens.get(currTok++));
    if(cleanTok(tokens.get(currTok)) =="["){
        isArray = true;
        currTok++; //for '['
        expressionFunc(tokens);
        currTok++; // for ']'
        result += "push "+symbolTable.kindOf(varName)+" "+symbolTable.indexOf(varName).string + "\n";
        print(varName+symbolTable.kindOf(varName)+" "+symbolTable.indexOf(varName).string);


        result += "add\n";
    }
    currTok++; // for '='
    expressionFunc(tokens);
    if(isArray){
        result += "pop temp 0\n";
        result += "pop pointer 1\n";
        result += "push temp 0\n";
        result += "pop that 0\n";
    }else{
        result += "pop "+symbolTable.kindOf(varName)+" "+symbolTable.indexOf(varName).string +"\n";
        //print(symbolTable.kindOf(varName)+" "+symbolTable.indexOf(varName).string);

    }

    currTok++; // for ';'
}

void ifStatementFunc(LinkedList<String> tokens) {

    numOfIF++;
    currTok++; // for keyword "if"
    currTok++; // for '('
    expressionFunc(tokens);
    currTok++; // for ')'

    result += "if-goto IF_TRUE" + numOfIF.string + "\n";
    result += "if-goto IF_FALSE" + numOfIF.string + "\n";
    result += "label IF_TRUE" + numOfIF.string + "\n";

    currTok++; // for '{'
    statementsFunc(tokens);
    currTok++; // for '}'

    if(cleanTok(tokens.get(currTok)) == "else"){
        result += "goto IF_END"+numOfIF.string + "\n";
    }

    result += "label IF_FALSE"+numOfIF.string + "\n";

    if(cleanTok(tokens.get(currTok)) == "else"){
        currTok++; // for keyword "else"
        currTok++; // for "{"
        statementsFunc(tokens);
        currTok++; // for "}"

        result += "label IF_END"+numOfIF.string + "\n";

    }

}

void whileStatementFunc(LinkedList<String> tokens) {

    numOfWhile++;
    result+= "label WHILE_LOOP"+numOfWhile.string +"\n";
    currTok++; //for keyword "while"
    currTok++; // for '('
    expressionFunc(tokens);
    currTok++; // for ')'
    result+= "not\n";
    result+= "if-goto WHILE_END"+numOfWhile.string +"\n";
    currTok++; // for '{'
    statementsFunc(tokens);
    currTok++; // for '}'
    result+= "goto WHILE_LOOP"+numOfWhile.string +"\n";
    result+= "label WHILE_END"+numOfWhile.string +"\n";



}

void doStatementFunc(LinkedList<String> tokens) {

    variable String varName;
    variable String subroutineName;
    currTok++; //for keyword "do"
    if(cleanTok(tokens.get(currTok+1)) == "("){
        varName = cleanTok(tokens.get(currTok));
        currTok++; //for subrotine name
        currTok++; //for "("
        result += "push pointer 0\n";
        expressionListFunc(tokens);
        result+="call "+ className+"."+varName + " " + (numOfList+1).string + "\n";
        numOfList = 0;
        currTok++; // for ')'
    }
    else if(cleanTok(tokens.get(currTok+1)) == "."){
        varName = cleanTok(tokens.get(currTok++));
        currTok++; //for '.'
        subroutineName = cleanTok(tokens.get(currTok++));
        currTok++; //for '('

        if(symbolTable.kindOf(varName) != "None"){
            result += "push "+symbolTable.kindOf(varName)+" "+symbolTable.indexOf(varName).string + "\n";
            print(varName+symbolTable.kindOf(varName)+" "+symbolTable.indexOf(varName).string);
            varName = symbolTable.typeOf(varName);
            numOfList++;
        }
        expressionListFunc(tokens);
        result+= "call "+ varName+"."+subroutineName + " " + numOfList.string + "\n";
        numOfList =0;
        currTok++; //for ')'
    }
    currTok++; //for ';'
}

void returnStatementFunc(LinkedList<String> tokens) {
    currTok++; // for keyword "return"
    if( cleanTok(tokens.get(currTok)) != ";")
    {
        expressionFunc(tokens);
    }
    else
    {
        result += "push constant 0\n";
    }
    result += "return\n";
    currTok++; // for ";"
}

void expressionFunc(LinkedList<String> tokens) {

    variable String opToken;
    termFunc(tokens);
    variable String dividTok;


    while (tokens.get(currTok).contains("+") ||
    tokens.get(currTok).contains("-") ||
    tokens.get(currTok).contains("*") ||
    tokens.get(currTok).contains("> / <")||
    tokens.get(currTok).contains("&amp") ||
    tokens.get(currTok).contains("|") ||
    tokens.get(currTok).contains("&lt") ||
    tokens.get(currTok).contains("&gt")||
    tokens.get(currTok).contains("=")) {

        dividTok = tokens.get(currTok);
        opToken = cleanTok(tokens.get(currTok++));
        termFunc(tokens);

        if( opToken.contains("+"))
        {
            result+="add\n";
        }
        else if( opToken.contains("-") )
        {
            result+="sub\n";
        }
        else if( opToken.contains("*"))
        {
            result+="call Math.multiply 2\n";
        }
        else if(dividTok.contains("> / <") )
        {
            result+="call Math.divide 2\n";
        }
        else if( opToken.contains("&amp"))
        {
            result+="and\n";
        }
        else if( opToken.contains("|"))
        {
            result+="or\n";
        }
        else if( opToken.contains("&lt") )
        {
            result+="lt\n";
        }
        else if( opToken.contains("&gt"))
        {
            result+="gt\n";
        }
        else if( opToken.contains("="))
        {
            result+="eq\n";
        }


    }

}

void subrotineCallFunc(LinkedList<String> tokens) {

    //result += space + "<subrotineCall>\n";

    if(tokens.get(currTok+1).contains("("))
    {
        result += space + tokens.get(currTok++) + "\n"; // Name of subroutin
        result += space + tokens.get(currTok++) + "\n"; // token--> (
        expressionListFunc(tokens);
        result += space + tokens.get(currTok++) + "\n"; // token--> )

    }
    else
    {
        result += space + tokens.get(currTok++) + "\n"; // Name of class or var
        result += space + tokens.get(currTok++) + "\n"; // token--> .
        result += space + tokens.get(currTok++) + "\n"; // token--> Name of subroutin
        result += space + tokens.get(currTok++) + "\n"; // token--> (
        expressionListFunc(tokens);
        result += space + tokens.get(currTok++) + "\n"; // token--> )
    }

    //result += space + "</subrotineCall>\n";

}

void termFunc(LinkedList<String> tokens) {

    variable String opToken;


    if(cleanTok(tokens.get(currTok)) =="(") {
        currTok++; // fro '('
        expressionFunc(tokens);
        currTok++; // fro ')'
    }
    else if(cleanTok(tokens.get(currTok)) == "-") {
        opToken = cleanTok(tokens.get(currTok++));
        termFunc(tokens);
        result += "neg\n";
    }
    else if(cleanTok(tokens.get(currTok))== "~") {
        opToken = cleanTok(tokens.get(currTok++));
        termFunc(tokens);
        result += "not\n";
    }
    else if (tokens.get(currTok).contains("<integerConstant>")){
        result += "push constant "+cleanTok(tokens.get(currTok++)) +"\n";
    }
    else if(tokens.get(currTok).contains("<stringConstant>")){
        variable String tmp = cleanTok(tokens.get(currTok));
        Integer x = tmp.size;
        result += "push constant " + (x).string +"\n";//length
        result += "call String.new 1\n";

        for(it in tmp)
        {
            Integer asciiCode = it.integer;
            result += "push constant " + asciiCode.string +"\n";
            result += "call String.appendChar 2\n";
        }
       currTok++;

    }

    else if(cleanTok(tokens.get(currTok)) == "true"){
        result += "push constant 0\n";
        result+= "not\n";
        currTok++;

    }
    else if(cleanTok(tokens.get(currTok)) == "false" ||
    cleanTok(tokens.get(currTok)) == "null"){
        result += "push constant 0\n";
        currTok++;

    }
    else if(cleanTok(tokens.get(currTok)) == "this"){
        result += "push pointer 0\n";
        currTok++;
    }
    else if(cleanTok(tokens.get(currTok+1)) == "["){
        variable String varName = cleanTok(tokens.get(currTok++));
        currTok++; //for '['
        expressionFunc(tokens);
        currTok++; // for']'

        result +="push "+symbolTable.kindOf(varName)+" "+symbolTable.indexOf(varName).string +"\n";
        print(varName+symbolTable.kindOf(varName)+" "+symbolTable.indexOf(varName).string);
        result += "add\n";
        result += "pop pointer 1\n";
        result += "push that 0\n";

    }
    else if(cleanTok(tokens.get(currTok+1)) == "("){
        variable String nameOfSub;
        nameOfSub = cleanTok(tokens.get(currTok++));
        result += "push argument 0\n";
        currTok++; // for (
        expressionListFunc(tokens);
        currTok++; // for )
        result += "call "+ nameOfSub + (symbolTable.varCount()+1).string + "\n";
    }
    else if(cleanTok(tokens.get(currTok+1)) == "."){

        variable String varName;
        variable String subroutinName;

        varName = cleanTok(tokens.get(currTok++));
        currTok++; // for '.'
        subroutinName = cleanTok(tokens.get(currTok++));
        currTok++; // for '('

        if(symbolTable.kindOf(varName) != "None"){
            result += "push "+symbolTable.kindOf(varName)+" "+symbolTable.indexOf(varName).string + "\n";
            print(varName+symbolTable.kindOf(varName)+" "+symbolTable.indexOf(varName).string);
            varName = symbolTable.typeOf(varName);
            numOfList++;
        }
        expressionListFunc(tokens);
        result+= "call "+ varName+"."+subroutinName + " " + numOfList.string + "\n";
        numOfList =0;
        currTok++; //for ')'
    }
    else{
        result += "push "+symbolTable.kindOf(cleanTok(tokens.get(currTok)))+" "+symbolTable.indexOf(cleanTok(tokens.get(currTok))).string + "\n";
        print(  (cleanTok(tokens.get(currTok))) + " " + symbolTable.indexOf(cleanTok(tokens.get(currTok))).string);
        currTok++; // for var name
    }
}


void expressionListFunc(LinkedList<String> tokens) {

    if(cleanTok(tokens.get(currTok)) !=")" ){
        numOfList++;
        expressionFunc(tokens);
        while(cleanTok(tokens.get(currTok)) == ","){
            numOfList++;
            currTok++;
            expressionFunc(tokens);
        }

    }
}

void resetCounters() {
    numOfIF =0;
    numOfWhile=0;
}

String cleanTok(String token){
    String tmp = token;
    value index =tmp.indexOf(">");  //  <identifier> class name </identifier>
    value index_ =tmp.indexOf("/");
    return tmp.substring(index+2,index_-2);
}
