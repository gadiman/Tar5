
{String*} keywords={"class","constructor","function","method","field","static","var","int","char","boolean","void","true","false","null","this","let","do","if","else","while","return"};
shared String  tokenizer(String line) {

    variable String token ="";
    variable String result ="";
    variable Integer index = 0;
    variable Integer startTok = 0;
    token = line.substring(0,1);


    while(index != line.size){
        index++;
        if(token == " ") {
            token = "";
            startTok++;
        }
        else if(token == '"'.string){
            while(token.substring(index-1,index) != '"'.string)
            {
                index++;
                token = line.substring(0,index);
            }
            token = line.substring(startTok+1,index-1);

            result += "<stringConstant>" + " " + token + " " + "</stringConstant>\n";
            startTok = index;
            token="";

        }
        else if("{}()[].,;+-*/&|<>=~".contains(token)){

            if (token == ">") {
                token = "&gt;";
            }
            if (token == "<") {
                token = "&lt;";
            }
            if (token == "&") {
                token = "&amp;";
            }
            if((token == '/'.string || token == "*") &&
                (line.substring(index,index+1) == "*"
                ||line.substring(index,index+1) == "/")){
                break;
            }
            result += "<symbol>" + " " + token + " " + "</symbol>\n";
            startTok = index;
            token ="";
        }
        else {
            if (token == "	") {
                token = "";
                startTok++;
            }
            else
            {
                if (line.substring(index, index +1 ) == " " ||"{}()[].,;+-*/&|<>=~".contains(line.substring(index, index + 1))) {

                    if (keywords.contains(token)) {
                        result += "<keyword>" + " " + token + " " + "</keyword>\n";
                        startTok = index;
                    } else if (exists num = parseInteger(token)) {
                        result += "<integerConstant>" + " " + token + " " + "</integerConstant>\n";
                        startTok = index;
                    } else if (token != " ") {
                        result += "<identifier>" + " " + token + " " + "</identifier>\n";
                        startTok = index;
                    }
                    token = "";


                }

            }
        }

        token = line.substring(startTok,index+1);

    }
    return result;
}