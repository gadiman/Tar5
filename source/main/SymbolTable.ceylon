import ceylon.collection { LinkedList, HashMap }
class SymbolTable() {

    variable Integer index_of_static = 0;
    variable Integer index_of_field = 0;
    variable Integer index_of_var = 0;
    variable Integer index_of_arg = 0;


    value class_scope=HashMap<String,String>();
    value sub_routine=HashMap<String,String>();


    shared void reset() {
        index_of_static = 0;
         index_of_field = 0;
         index_of_var = 0;
         index_of_arg = 0;
    }


    shared Integer varCount(){
        return index_of_var ;
    }

    shared void define(String name,String type,String kind ){

        if (kind=="static"){
            class_scope.put(name, type + " static " + index_of_static.string);
            index_of_static = index_of_static + 1;
        }
        else if (kind=="field"){
            class_scope.put(name, type + " this " + index_of_field.string);
            index_of_field = index_of_field + 1;
        }
        else if (kind=="arg"){
            sub_routine.put(name, type + " argument " + index_of_arg.string);
            index_of_arg = index_of_arg + 1;
        }
        else if (kind=="var"){
            sub_routine.put(name, type + " local " + index_of_var.string);
            index_of_var = index_of_var + 1;
        }

    }

    shared void startSubroutine(){
        sub_routine.clear();
        index_of_var=0;
        index_of_arg=0;

    }

    shared String kindOf ( String name ){
        value check_sub = sub_routine.get(name);

        if(exists identifier_sub=check_sub){
            value id_sub =  identifier_sub.split();
            String? kind_id = id_sub.rest.first;
            assert(exists kind_id);
            return kind_id;
        }
        else{
            value check_class= class_scope.get(name);
            if(exists identifier_class = check_class)
            {
                value id_class =  identifier_class.split();
                String? kind_class = id_class.rest.first;
                assert(exists kind_class);
                return kind_class;
            }
        }
        return "None";
    }

    shared String typeOf ( String name ){
        value check_sub= sub_routine.get(name);
        if(exists identifier_sub=check_sub)
        {
            value id_sub =  identifier_sub.split();
            String? type_sub = id_sub.first;
            assert(exists type_sub);
            return type_sub;

        }
        else
        {
            value check_class= class_scope.get(name);
            if(exists identifier_class=check_class)
            {
                value id_class =  identifier_class.split();
                String? type_class = id_class.first;
                assert(exists type_class);
                return type_class;
            }
        }

        return "None";
    }

    shared Integer indexOf ( String name ){
        value check_sub= sub_routine.get(name);
        if(exists identifier_sub=check_sub)
        {
            value id_sub =  identifier_sub.split();
            String? x = id_sub.rest.rest.first;
            assert(exists x);
            Integer? index_sub = parseInteger(x);
            assert(exists index_sub);
            return index_sub;
        }
        else
        {

            value check_class= class_scope.get(name);
            if(exists identifier_class=check_class)
            {
                value id_class =  identifier_class.split();
                String? x = id_class.rest.rest.first;
                assert(exists x);
                Integer? index_class = parseInteger(x);
                assert(exists index_class);
                return index_class;
            }
        }
        return -1;
    }



}