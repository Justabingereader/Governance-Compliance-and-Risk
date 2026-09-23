targetScope = 'resourceGroup'

param budgetAmount int = 200
param startDate string = '${utcNow('yyyy-MM')}-01'
@description('The end date for the budget. If not provided, we default this to 10 years from the start date.')
param endDate string = dateTimeAdd(startDate, 'P1Y')
@description('Minimum budget threshold percentage.')
param minimumThreshold int = 30
@description('Average budget threshold percentage.')
param averageThreshold int = 60
@description('Maximum budget threshold percentage.')
param maximumThreshold int = 90
@description('Email addresses that receive budget threshold notifications.')
param contactEmails string[] = [
  'Harounimran04@gmail.com'
]

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
