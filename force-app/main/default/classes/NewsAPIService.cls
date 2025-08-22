public with sharing class NewsAPIService {
    private static final String API_NAMED_CREDENTIAL = 'callout:NewsAPI'; //https://newsapi.org
    private static final String API_ENDPOINT = '/v2/top-headlines';

    private static final Integer PAGE_SIZE = (Integer) NewsAPISettings__c.getOrgDefaults().Page_Size__c; // This is set via Custom Setting so that it can be used across classes.
    private static List<String> defaultCategories = new List<String>{
        'business', 'entertainment', 'general', 'health', 'science', 'sports', 'technology'
    };

    public static NewsAPIResponse getTopHeadlinesByCategory(String category, Integer page) {
        if (page < 0) {
            throw new IllegalArgumentException('Page cannot be negative');
        }
        if (String.isBlank(category) || !defaultCategories.contains(category.toLowerCase())) {
            throw new IllegalArgumentException('Invalid parameter, category: ' + category);
        } else if (page < 0) {
            throw new IllegalArgumentException('Invalid parameter, page: ' + page);
        }

        NewsAPI_Setting__mdt newsApiSetting = NewsAPI_Setting__mdt.getInstance('ACTIVE');
        String endpoint = API_NAMED_CREDENTIAL + API_ENDPOINT + '?apiKey=' + newsApiSetting.X_Api_Key__c + '&category=' + category + '&pageSize=' + PAGE_SIZE + '&page=' + page;
        HttpResponse res = makeCallout(endpoint);
        NewsAPIResponse newsApiResponse = parseResponse(res.getBody());
        
        return newsApiResponse;
    }

    private static HttpResponse makeCallout(String endpoint) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setTimeout(10000); // 10 seconds

        Http http = new Http();
        HttpResponse res = http.send(req);
        // Documentation for NewsAPI Error Codes https://newsapi.org/docs/errors
        if (res.getStatusCode() == 400) {
            throw new NewsAPIException('Bad Request: ' + res.getBody());
        } else if (res.getStatusCode() == 401) {
            throw new NewsAPIException('Unauthorized: ' + res.getBody());
        } else if (res.getStatusCode() == 429) {
            throw new NewsAPIException('Too Many Requests: ' + res.getBody());
        } else if (res.getStatusCode() == 500) {
            throw new NewsAPIException('Internal Server Error: ' + res.getBody());
        }
        return res;
    }

    private static NewsAPIResponse parseResponse(String jsonResponse) {
        if (String.isBlank(jsonResponse)) {
            throw new IllegalArgumentException('Parameter should be a JSON string');
        }

        NewsAPIResponse newsApiResponse;
        try {
            newsApiResponse = (NewsAPIResponse) JSON.deserialize(jsonResponse, NewsAPIResponse.class);
        } catch (Exception e) {
            throw new NewsAPIException('Could not parse response: ' + e.getMessage());
        }
        
        return newsApiResponse;
    }

    public class NewsAPIException extends Exception {}
}