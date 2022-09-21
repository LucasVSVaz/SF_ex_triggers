public with sharing class OrderItemTriggerHandler {
    List<OrderItem> oldRecords {get; set;}
    List<OrderItem> newRecords {get; set;}
    Map<Id, OrderItem> oldMap {get; set;}
    Map<Id, OrderItem> newMap {get; set;}
    

    public OrderItemTriggerHandler(List<OrderItem> oldRecords, List<OrderItem> newRecords, Map<Id, OrderItem> oldMap, Map<Id, OrderItem> newMap) {
        this.oldRecords = oldRecords;
        this.newRecords = newRecords;
        this.oldMap = oldMap;
        this.newMap = newMap;
    }


    public void afterInsert(){
        List<Account> accountList = OrderItemHelper.summarizeAccounts(this.newRecords);

        if(!accountList.isEmpty()){
            update accountList;
        }
    }

    public void afterUpdate(){
        List<Account> accountList = OrderItemHelper.summarizeAccounts(this.oldMap, this.newMap);

        if(!accountList.isEmpty()){
            update accountList;
        }
    }

    public void afterDelete(){
        List<Account> accountList = OrderItemHelper.summarizeAccounts(this.oldRecords);
       
        if(!accountList.isEmpty()){
            update accountList;
        }
    }
}
