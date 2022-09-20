public with sharing class OpportunityLineItemTriggerHandler {
    List<OpportunityLineItem> oldRecords {get; set;}
    List<OpportunityLineItem> newRecords {get; set;}
    Map<Id, OpportunityLineItem> oldMap {get; set;}
    Map<Id, OpportunityLineItem> newMap {get; set;}
    

    public OpportunityLineItemTriggerHandler(List<OpportunityLineItem> oldRecords, List<OpportunityLineItem> newRecords, Map<Id, OpportunityLineItem> oldMap, Map<Id, OpportunityLineItem> newMap) {
        this.oldRecords = oldRecords;
        this.newRecords = newRecords;
        this.oldMap = oldMap;
        this.newMap = newMap;
    }


    public void beforeUpdate(){
        OpportunityLineItemHelper.checkChangeQuantity(this.oldMap, this.newMap);
    }

    public void afterUpdate(){
        List<Opportunity> opportunityList = OpportunityLineItemHelper.checkItemChange(this.oldMap, this.newMap);
        update opportunityList;
    }
}
