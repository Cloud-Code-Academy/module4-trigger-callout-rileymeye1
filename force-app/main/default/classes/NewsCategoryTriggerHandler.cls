public with sharing class NewsCategoryTriggerHandler {

    public static void handleInsert(List<News_Category__c> newRecords) {
        List<News_Category__c> categoriesToSync = new List<News_Category__c>();
        for (News_Category__c category : newRecords) {
            if (category.Sync__c) {
                categoriesToSync.add(category);
            }
        }
        syncCategoriesWithQueueable(categoriesToSync);
    }

    public static void handleUpdate(List<News_Category__c> newRecords, Map<Id, News_Category__c> oldMap) {
        List<News_Category__c> categoriesToSync = new List<News_Category__c>();
        for (News_Category__c category : newRecords) {
            if (category.Sync__c && !oldMap.get(category.Id).Sync__c) {
                categoriesToSync.add(category);
            }
        }
        syncCategoriesWithQueueable(categoriesToSync);
    }

    private static void syncCategoriesWithQueueable(List<News_Category__c> categoriesToSync) {
        AsyncOptions asyncOptions = new AsyncOptions();
        asyncOptions.MaximumQueueableStackDepth = 200; // Fail safe to prevent infinite queueing
        for (News_Category__c category : categoriesToSync) {
            System.enqueueJob(new NewsCategoryQueueable(category, 0), asyncOptions);
        }
    }
}