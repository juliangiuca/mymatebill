Feature: complex transactions between multiple people
  As a person with an accpimt
  I want to be able to interact with other people
  so that I have an accurate description of my lifes transactions

#############################
# A transaction between three people
#############################
  Scenario: I want to create a transaction between a biller, myself and three other people
  Given I have an account
    And Frog has an account
    And Rabbit has an account
    And Captain has an account
    And Rent exists as a biller
   When A bill for rent arrives for $1300
   Then the bill should be created
    And everyone should have to an bill for an equal share

#############################
# A transaction between three people that later has steps modified
#############################
  Scenario: I have a bill for rent that I later update to include another person
  Given The complex transaction setup
    And Hooch has an account
   When I add Hooch to the bill for $260
   Then The bill should be updated to $1560

  Scenario: I have a bill for rent and I remove a person from that bill via their identity
  Given The complex transaction setup
   When I remove Frog from the transaction
   Then The bill should be updated to $975

 Scenario: I have a bill for rent and I remove a person from that bill via the transaction steps
  Given The complex transaction setup
   When I remove Frog from the transaction step
   Then The bill should be updated to $975

#############################
# A transaction between three people that later gets modified
#############################

 Scenario: I have a bill for rent and I delete it
  Given The complex transaction setup
   When I remove the bill
   Then All the steps and balances are removed too

 Scenario: I have a bill for rent and I delete all the steps
  Given The complex transaction setup
   When I remove the steps to a bill
   Then All the steps and balances are removed too

 Scenario: I have a bill for rent and I mark all steps as confirmed
  Given The complex transaction setup
   When I confirm all the steps in a bill
   Then The transaction is automatically marked as paid and balances set

 Scenario: I have a bill for rent and I mark it as confirmed
  Given The complex transaction setup
   When I confirm the transaction
   Then The transaction is automatically marked as paid and balances set

