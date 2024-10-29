
Feature: Articles

    Background: Define URL
        Given url 'https://conduit-api.bondaracademy.com/api/'
        * def tokenResponse callonce read('classpath:helpers/CreateToken.feature') {"email": "karatekid10@gmail.com", "password": "password"}
        * def token = tokenRespose.authToken

    @ignore @skipme
    Scenario: Create a new article
        Given header Authorization = 'Token ' + token
        Given path 'articles'
        And request {"article": {"title": "Testers3", "description": "testing", "body": "testing", "tagList": []}}
        When method Post
        Then status 201
        And match response.article.title == 'Testers3'

    @token
    Scenario: Create and delete article
        Given header Authorization = 'Token ' + token
        Given path 'articles'
        And request {"article": {"title": "TestersWorld", "description": "testing", "body": "testing", "tagList": []}}
        When method Post
        Then status 201
        *def articleId = response.article.slug

        Given header Authorization = 'Token ' + token
        Given params {limit: 10, offset: 0}
        Given path 'articles'
        When method Get
        Then status 200
        And match response.articles[0].title == 'TestersWorld'

        Given header Authorization = 'Token ' + token
        Given path 'articles',articleId
        When method Delete
        Then status 204

        Given header Authorization = 'Token ' + token
        Given params {limit: 10, offset: 0}
        Given path 'articles'
        When method Get
        Then status 200
        And match response.articles[0].title != 'TestersWorld'