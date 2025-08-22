public class NewsCategoryQueueable implements Queueable, Database.AllowsCallouts {
    // Static variable for maximum pages to fetch
    private static final Integer MAX_PAGES = 3;
    
    private News_Category__c category;
    private Integer currentPage;

    public NewsCategoryQueueable(News_Category__c category, Integer currentPage) {
        this.category = category;
        this.currentPage = currentPage;
    }

    public void execute(QueueableContext context) {
        // IMPORTANT: Create a separate instance of the category for updates
        News_Category__c updatedCategory = new News_Category__c(Id = category.Id);
        
        try {
            NewsAPIResponse apiResponse = NewsAPIService.getTopHeadlinesByCategory(category.Name, currentPage);
            List<Article__c> articles = new List<Article__c>();
            for (NewsAPIResponse.Article apiArticle : apiResponse.articles) {
                Article__c article = NewsAPIResponse.convertToSObject(apiArticle);
                articles.add(article);
            }
            
            for (Article__c article : articles) {
                article.News_Category__c = category.Id;
                article.Category__c = category.Name;
            }
            Database.insert(articles, AccessLevel.SYSTEM_MODE);
            
            if (currentPage < MAX_PAGES && apiResponse.totalResults - (currentPage * 20) > 0 && !Test.isRunningTest()) {
                Integer delayInMinutes = 2;
                System.enqueueJob(new NewsCategoryQueueable(category, currentPage + 1), delayInMinutes);
            }

            updatedCategory.Last_Synced__c = Datetime.now();
            updatedCategory.Sync__c = false;
            Database.update(updatedCategory, AccessLevel.SYSTEM_MODE);
        } catch (Exception e) {
            updatedCategory.Error_Information__c = e.getMessage();
            updatedCategory.Sync__c = false;
            Database.update(updatedCategory, AccessLevel.SYSTEM_MODE);
            System.debug(e.getMessage());
        }
    }
}