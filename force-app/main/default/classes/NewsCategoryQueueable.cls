public class NewsCategoryQueueable implements Queueable, Database.AllowsCallouts {
    // Static variable for maximum pages to fetch
    private static final Integer MAX_PAGES = 3;
    private static final Integer PAGE_SIZE = 20;
    private News_Category__c category;
    private Integer currentPage;
    private Integer totalResults;

    public NewsCategoryQueueable(News_Category__c category, Integer currentPage) {
        this.category = category;
        this.currentPage = currentPage;
        this.totalResults = null;
    }

    public void execute(QueueableContext context) {
        // IMPORTANT: Create a separate instance of the category for updates
        News_Category__c updatedCategory = new News_Category__c(Id = category.Id);
        
        try {
            NewsAPIResponse apiResponse = NewsAPIService.getTopHeadlinesByCategory(category.Name, currentPage);
            System.debug('ARTICLES: ' + apiResponse.articles);
            List<Article__c> articles = new List<Article__c>();
            for (NewsAPIResponse.Article apiArticle : apiResponse.articles) {
                System.debug('API ARTICLE: ' + apiArticle);
                Article__c article = NewsAPIResponse.convertToSObject(apiArticle);
                article.News_Category__c = category.Id;
                article.Category__c = category.Name;
                articles.add(article);
            }
            
            Database.insert(articles, AccessLevel.SYSTEM_MODE);

            if (currentPage == 1) {
                this.totalResults = apiResponse.totalResults;
            }
            Integer recordsFetched = currentPage * PAGE_SIZE;
            Boolean hasMoreRecords = totalResults > recordsFetched;
            Boolean withinPageLimit = currentPage < MAX_PAGES;
            
            if (hasMoreRecords && withinPageLimit && !Test.isRunningTest()) {
                this.currentPage++;
                Integer delayInMinutes = 2;
                System.enqueueJob(this, delayInMinutes);
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