Feature: Required CAS Authentication
  In order make it dead-simple for users to implement a CAS-login requirement
  Casrack the Authenticator provides a RequireCAS middleware.
  
  Background:
    Given a Rack application exists
    And the RequireCAS middleware is installed
    And the simple version of Casrack the Authenticator is installed
    And the underlying Rack application returns [200, {}, "Public Information"]
    
  Scenario: not-signed-in user makes a request
    When I make a request
    Then I should be redirected to CAS
    
  Scenario: signed-in-user makes a request
    When I return to "http://myapp.org/bar" with a valid CAS ticket for "tperon"
    Then the response should be successful
    And the response body should include "Public Information"
