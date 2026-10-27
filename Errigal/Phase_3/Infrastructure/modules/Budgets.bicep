targetScope = 'resourceGroup'

param budgetAmount int
param startDate string
@description('The end date for the budget.')
param endDate string
@description('Minimum budget threshold percentage.')
param minimumThreshold int
@description('Average budget threshold percentage.')
param averageThreshold int
@description('Maximum budget threshold percentage.')
param maximumThreshold int
@description('Email addresses that receive budget threshold notifications.')
param contactEmails string[]

var budgetNotifications = {
  Minimum_Threshold: {
    enabled: true
    operator: 'GreaterThan'
    threshold: minimumThreshold
    contactEmails: contactEmails
  }
  Average_Threshold: {
    enabled: true
    operator: 'GreaterThan'
    threshold: averageThreshold
    contactEmails: contactEmails
  }
  Maximum_Threshold: {
    enabled: true
    operator: 'GreaterThan'
    threshold: maximumThreshold
    contactEmails: contactEmails
  }
}

resource BudgetConsumption 'Microsoft.Consumption/budgets@2023-03-01' = {
  name: 'BudgetConsumption'
  properties: {
    category: 'Cost'
    amount: budgetAmount
    timeGrain: 'Monthly'
    timePeriod: {
      startDate: startDate
      endDate: endDate
    }
    notifications: budgetNotifications
  }
}

output BudgetId string = BudgetConsumption.id
