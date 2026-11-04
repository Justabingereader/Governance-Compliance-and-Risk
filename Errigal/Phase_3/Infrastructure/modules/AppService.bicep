param tags object

resource ServerFarm 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: 'asp-errigal-neu'
  location: resourceGroup().location
  tags: tags
  sku: {
    name: 'B1'
    tier: 'Basic'
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}
