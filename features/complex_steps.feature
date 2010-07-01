Feature: Handling complex sub transaction actions
  As a person with a transaction
  I want to be able to change a payment's state
  so that I have an accurate idea of a bill's state

#############################
# A transaction between three people that later gets modified
#############################

 Scenario: I have a bill for rent and I mark all steps as confirmed
  Given The complex transaction setup
    And I confirm all the steps in a bill
   When I unpay a step in a transaction
   Then The transaction is automatically marked as unpaid and balances set

