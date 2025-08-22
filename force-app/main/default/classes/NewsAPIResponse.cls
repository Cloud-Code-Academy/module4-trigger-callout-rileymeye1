public class NewsAPIResponse {
    public String status { get; set; }
    public Integer totalResults { get; set; }
    public List<Article> articles { get; set; }

    public class Article {
        public Source source;
        public String author;
        public String title;
        public String description;
        public String url;
        public String urlToImage;
        public String publishedAt;
        public String content;
    }

    public class Source {
        public String id;
        public String name;
    }

    public static Article__c convertToSObject(Article apiArticle) {
        // Converts the publishedAt String to a Date/Time value to be used
        Datetime publishedDateTime = (Datetime) JSON.deserialize('"' + apiArticle.publishedAt + '"', Datetime.class);

        Article__c article = new Article__c();
        article.Name = apiArticle.title.length() > 60 ? apiArticle.title.substring(0, 60) + '-' + publishedDateTime : apiArticle.title + '-' + publishedDateTime;
        if (String.isNotBlank(apiArticle.author)) {
            article.Author__c = apiArticle.author;
        }
        if (String.isNotBlank(apiArticle.content)) {
            article.Content__c = apiArticle.content.length() > 131072 ? apiArticle.content.substring(0, 131072) : apiArticle.content;
        }
        if (String.isNotBlank(apiArticle.description)) {
            article.Description__c = apiArticle.description.length() > 32768 ? apiArticle.description.substring(0, 32768) : apiArticle.description;
        }
        article.Published_At__c = publishedDateTime;
        article.Source__c = apiArticle.source.name;
        article.Title__c = apiArticle.title;
        article.url__c = apiArticle.url;
        if (String.isNotBlank(apiArticle.urlToImage)) {
            article.urlToImage__c = apiArticle.urlToImage;
        }
        
        return article;
    }
}