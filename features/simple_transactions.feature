Feature: transaction manipulation
  As a person with an account
  I want to be able to manipulate my transactions
  so that I have an accurate description of my life transactions

########################
# A simple transaction between two entities
########################
  Scenario: I want to create a transaction between myself and a bill
   Given I have an account
     And an association with Rent
    When A bill for $50 arrives for me from Rent
    Then The transaction and steps should be linked to myself and Rent
     And I should be $50 poorer
     And Rent should be $50 richer
     And I should be the owner of the transaction

########################
# Completing the simple transaction
########################
  Scenario: I want to complete a transaction between myself and a bill
   Given A $50 transaction between myself and Rent
    Then I should be $50 poorer
     And Rent should be $50 richer
    When I confirm payment
    Then I should be $0 poorer
     And Rent should be $0 richer

########################
# Simple transactions between friends
########################
  Scenario: I owe Frog $20
   Given A $20 transaction from myself to Frog
    Then I should be $20 poorer
     And Frog should be $20 richer
    When I confirm payment
    Then I should be $0 poorer
     And Frog should be $0 richer

  Scenario: Frog owes me $50
   Given A $50 transaction from Frog to myself
    Then Frog should be $50 poorer
     And I should be $50 richer
    When I confirm payment
    Then Frog should be $0 poorer
     And I should be $0 richer
