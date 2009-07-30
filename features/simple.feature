Feature: Simple CAS Authentication
  In order to maintain privacy and accountability while keeping IT costs low
  "Upper Management" wants to use CAS authentication
  
  Background:
    Given a Rack application exists
    And the simple version of Casrack the Authenticator is installed
  
  Scenario: not-signed-in user accesses public materical
    Given the user has not authenticated with CAS
    And the underlying Rack application returns [200, {}, "Public Information"]
    When I make a request
    Then the response should be successful
    And the response body should include "Public Information"