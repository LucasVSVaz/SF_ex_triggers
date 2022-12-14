public with sharing class OrderItemHelper {
    public OrderItemHelper() {

    }


    public static List<Account> summarizeAccounts(Map<Id, OrderItem> oldMap, Map<Id, OrderItem> newMap ){
        List<OrderItem> modifiedOrderItemList = new List<OrderItem>();

        for(OrderItem newOrderItem : newMap.values()){
            OrderItem oldOrderItem = oldMap.get(newOrderItem.id);

            if((newOrderItem.Quantity != oldOrderItem.Quantity) || (newOrderItem.UnitPrice != oldOrderItem.UnitPrice)){
                modifiedOrderItemList.add(newOrderItem);
            }
        }
        return summarizeAccounts(modifiedOrderItemList);
    }



    public static List<Account> summarizeAccounts(List<OrderItem> orderItemList){
        Set<Id> orderIdSet = new Set<Id>();

        for(OrderItem orderItem : orderItemList){
            orderIdSet.add(orderItem.OrderId);
        }

        List<Order> orderList = [
            SELECT Id, AccountId
            FROM Order
            WHERE id IN: orderIdSet
        ];


        Set<Id> accountIdSet = new Set<Id>();
        
        for(Order order : orderList){
            accountIdSet.add(order.AccountId);
        }

        List<AggregateResult> resultList = getAggregateOrderAmount(accountIdSet);

        List<Account> accountList = buildAmountData(resultList);

        return accountList;

    }


    public static List<AggregateResult> getAggregateOrderAmount(Set<Id> accountIdSet){
        List<AggregateResult> resultList = [
            SELECT AccountId, Status, SUM(TotalAmount) TotalAmount
            FROM Order
            WHERE AccountId IN: accountIdSet
            GROUP BY AccountId, Status
        ];

        return resultList;

    }

    public static List<Account> buildAmountData(List<AggregateResult> resultList){
        
        Map<String, String> statusToFieldMap = new Map<String, String>{
            'Open' => 'OpenOrderAmount__C',
            'Canceled' => 'CanceledOrderAmount__c',
            'Closed' => 'ClosedOrderAmount__c'

        };
        Map<Id, Account> accountMap = new Map<Id, Account> ();

        for(AggregateResult result : resultList){
            Decimal totalAmount = (Decimal)result.get('TotalAmount');
            Id accountId = (Id)result.get('AccountId');
            String status = (String)result.get('Status');

            if(accountMap.containsKey(accountId)){
                Account account = accountMap.get(accountId);

                if(statusToFieldMap.containsKey(status)){
                    account.put(statusToFieldMap.get(status), totalAmount);
                }
            } else {
                Account account = new Account(Id = accountId);

                if(statusToFieldMap.containsKey(status)){
                    account.put(statusToFieldMap.get(status), totalAmount);
                    accountMap.put(AccountId, account);
                } 

            }
         }
         return accountMap.values();
    }
}      
