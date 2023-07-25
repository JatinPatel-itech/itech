global class SessionUtil {

    @AuraEnabled(cacheable=true)
   global static String getSessionId() {
       //String sessionId = System.currentPageReference().getParameters().get('sid');
        //return sessionId;
    return UserInfo.getSessionId();
  }
}