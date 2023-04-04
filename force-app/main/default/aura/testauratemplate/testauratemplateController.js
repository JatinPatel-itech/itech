({
    toggleSection : function(component, event, helper) {
        component.set('v.isSidebarCollapsed', !component.get('v.isSidebarCollapsed'));
        component.set('v.mainsize', '12');
        
        if(component.get("v.isSidebarCollapsed")==true){
            component.set('v.mainsize', '12');
           
        }if(component.get("v.isSidebarCollapsed")==false){
           component.set('v.mainsize', '8'); 
           
        }
        
    }
})