Feature: Simple CAS Authentication
  In order to maintain privacy and accountability while keeping IT costs low
  "Upper Management" wants to use CAS authentication
  
  Background:
    Given a Rack application exists
    And the simple version of Casrack the Authenticator is installed
  
  Scenario: not-signed-in user accesses public material
    Given the underlying Rack application returns [200, {}, "Public Information"]
    When I make a request
    Then the response should be successful
    And the response body should include "Public Information"
    
  Scenario: not-signed-in user accesses restricted material
    Given the underlying Rack application returns [401, {}, "Restricted!"]
    When I make a request to "http://myapp.com/foo?bar=baz"
    Then I should be redirected to CAS
    And CAS should return me to "http://myapp.com/foo?bar=baz"
    
  Scenario: returning from a successful CAS sign-in
    Given the underlying Rack application returns [200, {}, "Information for jswanson"]
    When I return to "http://myapp.org/bar" with a valid CAS ticket for "jswanson"
    Then the CAS user should be "jswanson"
    And the response should be successful
    And the response body should include "Information for jswanson"