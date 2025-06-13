# Cloud Code Academy - Integration Developer Program
## Lesson 3: Outbound Callouts from Triggers

This assignment focuses on implementing outbound callouts from Salesforce, using Queueable Apex, and handling pagination from external APIs.

## 🎯 Learning Objectives

By the end of this lesson, you will be able to:
- Implement asynchronous callouts from Salesforce triggers using Queueable Apex
- Build robust API integration services with proper separation of concerns
- Implement pagination for external API callouts
- Handle error scenarios in integrations
- Create wrapper classes to deserialize JSON API responses

## 📋 Assignment Overview

In this assignment, you will be implementing a News Article integration with the NewsAPI.org service. The application will synchronize news articles based on categories defined in Salesforce, using Queueable Apex processing.

Your implementation must:
1. Make callouts when News Category records are created or updated with Sync set to true
2. Use Queueable Apex for all operations, supporting multi-page sync
3. Store the retrieved articles in Article__c custom objects

## 🔨 Prerequisites

1. A NewsAPI.org API key (sign up at https://newsapi.org)
2. Properly configured Named Credential in your org (see Setup Instructions)

## ✍️ Assignment Tasks

Your tasks for this assignment include:

1. Implement `NewsAPIResponse` class for deserializing the API response, with a static method to convert API articles to Salesforce records
2. Implement `NewsAPIService` class for making callouts to NewsAPI, using a fixed page size
3. Complete the `NewsCategoryTriggerHandler` class to handle Queueable-based callouts
4. Complete the `NewsCategoryQueueable` class to support paginated callouts with a maximum page limit
5. Make sure the trigger correctly handles both insert and update scenarios

## 🔑 Named Credential Setup

1. In Salesforce Setup, navigate to **Security > Named Credentials**
2. Click **New Named Credential**
3. Configure with appropriate settings for NewsAPI.org
4. Save the configuration

## 🧪 Testing Requirements

- Test classes have been provided for you in the `force-app/main/default/classes/tests` folder.
- `NewsCategoryTriggerHandlerTest` tests the trigger handler for insert and update operations.
- `NewsAPIServiceTest` tests the NewsAPIService class for making callouts to NewsAPI.
- Ensure all tests pass with proper coverage

## 📋 Valid News Categories

The following are valid categories for the NewsAPI:
- business
- entertainment
- general
- health
- science
- sports
- technology

## 🎯 Success Criteria

Your implementation should:
- Pass all test methods in the provided test classes
- Properly deserialize JSON responses from NewsAPI
- Create Article__c records from the API response
- Include comprehensive error handling
- Follow Salesforce best practices for integration

## 💡 Tips

- Review the API documentation at [NewsAPI Documentation](https://newsapi.org/docs)
- Use the Developer Console debug logs to troubleshoot
- Test with mock responses before making actual API calls
- Pay attention to error handling for various scenarios

## 📚 Resources

- [Apex Developer Guide: Queueable Apex](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_queueable.htm)
- [Apex Developer Guide: Callouts from Triggers](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_triggers_bestpract.htm)
- [JSON Deserialization in Apex](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_methods_system_json_overview.htm)
- [Named Credentials in Salesforce](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_callouts_named_credentials.htm)

## 🏆 Extra Credit - Optional Challenge

Once you've completed the basic implementation, try these challenges:
1. Add support for additional search parameters
2. Calculate the optimal number of pages to sync based on the API's total results
3. Implement custom logging to track integration activity
4. Add error handling that creates Error__c records with detailed information

## ❓ Support

If you need help:
- Review the test classes for expected behavior
- Check the documentation links provided
- Reach out to your instructor

---
Happy coding! 🚀

*This is part of the Cloud Code Academy Integration Developer certification program.*

## Copyright

© 2025 Cloud Code. All rights reserved.

This software is provided under the Cloud Code Developer Kickstart Program License (CCDKPL) Version 1.0.
The software is licensed, not sold, and is intended for personal educational purposes only as part of the Cloud Code Developer Kickstart Program.

See the full license terms in LICENSE.md for more details regarding usage restrictions, ownership, warranties, and limitations of liability.