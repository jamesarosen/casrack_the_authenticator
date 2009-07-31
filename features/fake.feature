Feature: Fake CAS Authentication
  In order to support developers who work away from the office
  Casrack the Authenticator provides a Fake middleware.
  
  Background:
    Given a Rack application exists
    And the fake Casrack middleware is installed with user "missy"
    
  Scenario: not-signed-in user makes a request to a public area
    Given the underlying Rack application returns [200, {}, "Public Information"]
    When I make a request
    Then the response should be successful
    And the response body should include "Public Information"
    And the CAS user should be nil
    
  Scenario: not-signed-in user makes a request to a private area
    Given the underlying Rack application returns [401, {}, 'Restricted. Go away.']
    When I make a request
    Then I should be presented with a HTTP Basic authentication request
    And the CAS user should be nil
  
  Scenario: user presenting invalid credentials makes a request to a private area
    Given the underlying Rack application returns [401, {}, 'Restricted. Go away.']
    When I make a request as "thomas"
    Then I should be presented with a HTTP Basic authentication request
    And the CAS user should be nil
    
  Scenario: user presenting credentials makes a request to a private area
    Given the underlying Rack application returns [200, {}, 'Restricted. Shh.']
    When I make a request as "missy"
    Then the response should be successful
    And the response body should include "Restricted. Shh."
    And the CAS user should be "missy"
    