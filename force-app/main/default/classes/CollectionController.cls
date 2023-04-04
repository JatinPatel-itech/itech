public class CollectionController {
    
    public Static void mapUpdateDIffrentObject(){
        map<string,map<string,object>> maplist = new map<string,map<string,object>>();
        for(account listAccount : [select id,name,description,website from account where name In ('temp-28','temp-27')]){
            if(!maplist.containsKey(listAccount.name)){
                //map<string,object> allData = new map<string,object>();
                //allData.put('description',listAccount.description);
                //allData.put('website',listAccount.website);
                //maplist.put(listAccount.name,allData);
                maplist.put(listAccount.name,new Map<String,Object>{'description'=>listAccount.description,'website'=>listAccount.website});
            }
            System.debug('mp list of data'+maplist);
        }
        
        List<lead> allleadlist = new List<lead>();
        for(lead led : [select id,name,description,website from lead where name in : maplist.keySet()]){
            System.debug('mapaclist@@'+maplist.get(led.name));
            led.description = String.valueOf(maplist.get(led.name).get('description'));
            led.website = String.valueOf(maplist.get(led.name).get('website'));
            allleadlist.add(led);
        }
        update allleadlist;
    }
}