targetScope = 'subscription'


module GovernanceBaseline './modules/Governance_class_baseline.bicep' = {
  name: 'GovernanceBaseline'
  scope: subscription()
}

module Budgets './modules/Budgets.bicep' = {
  name: 'Budgets'
  scope: resourceGroup('Errigal')
}

