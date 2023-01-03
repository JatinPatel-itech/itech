public class demo_collection_apex {
    
    public static void list_method()
    {
        List<String> namelist = new List<String>();
        namelist.add('jatin');
        namelist.add('purvi');
        namelist.add('akshay');
        namelist.add('rajendrabhai');
        namelist.add('pragnaben');
      
        System.debug('All list value:'+namelist);
        
        List<account> acc = new List<account>([select id,name,website,rating from account]);
        account objacc = new account();
        
        objacc = acc.get(0);
  
        System.debug('account data: '+acc);
        System.debug('account dobject data: '+objacc);
        System.debug('account name data: '+objacc.Name);
        System.debug('account rating data: '+objacc.Rating);
        System.debug('account website data: '+objacc.Website);
    } 
    public static void set_method()
    {
        set<String> nameset = new set<String>();
        nameset.add('jatin');
        nameset.add('purvi');
        nameset.add('akshay');
        nameset.add('jatin');
        nameset.add('rajendrabhai');
        nameset.add('pragnaben');
        System.debug('All set value:'+nameset);
        
        set<account> acc = new set<account>([select id,name from account]);
        System.debug('All set account value:'+acc);
    }
    public static void map_method()
    {
        map<integer, string> maplist = new map<integer,string>();
        maplist.put(1,'jatin');
        maplist.put(2,'hardik');
        maplist.put(2,'jatin');
        System.debug('all map data: '+maplist);
        
        map<id, account> acc = new map<id,account>([select id, name from account]);
        System.debug('all account data: '+acc);
        
    }
}