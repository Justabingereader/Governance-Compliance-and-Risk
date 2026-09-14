param budgetAmount int
param startDate string = '${utcNow('yyyy-MM')}-01'
@description('The end date for the budget. If not provided, we default this to 10 years from the start date.')
param endDate string = dateTimeAdd(startDate, 'P1Y')

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
    notifications: {
      Actual_GreaterThan_30_Percent: {
        enabled: true
        operator: 'GreaterThan'
        threshold: 30
        contactEmails: [
          'Harounimran04@gmail.com'
        ]
      }
      Actual_GreaterThan_60_Percent: {
        enabled: true
        operator: 'GreaterThan'
        threshold: 60
        contactEmails: [
          'Harounimran04@gmail.com'
        ]
      }
      Actual_GreaterThan_90_Percent: {
        enabled: true
        operator: 'GreaterThan'
        threshold: 90
        contactEmails: [
          'Harounimran04@gmail.com'
        ]
      }
    }
  }
}

