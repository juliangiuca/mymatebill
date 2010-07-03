Feature: transaction manipulation through associations
As a user with an account and associations
I want to remove associations
and still maintain their previous relationships

##################################
# Deleting an associate mid transaction
##################################
Scenario: When I delete an associate, I expect the step and transaction to be redacted
  Given A $50 transaction from Frog to myself
    And I confirm payment
   When I delete Frog
   Then the transaction should be removed
    And all debts should be reset

  Scenario: When I delete an associate, I expect the step and transaction to be redacted
  Given A $50 transaction from Frog to myself
   When I delete Frog
   Then the transaction should be removed
    And all debts should be reset
