# Errigal

### Phase 0 development

A firewall policy and policy assignment function were created, with the target scope aimed at the subscription level due to the requirement of policies to be present at the management or subscription scope. Created policies before initiative in order to have individual policy ID's for the initiative.

![Initial firewallPolicy resource, subscription-scoped, before the custom initiative was layered on top](images/phase0-firewall-policy-initial.png)

Use of a custom initiative for the defined policies, with a custom initiative assignment after. no parameters or variables were defined at the stage for the governance baseline bicep file as policies usually require minimal to no input from the user, it is the first phase that involves just one environment, and to test if the recorded policy and budget templates can successfully accomplish its task across just one environment before moving on to CI/CD pipeline deployment across ultiple environments. multiple policy assignments were not selected over one custom initiative assignment due to code readability and comprehension purposes.

The resource group for this single-environment test was created via the CLI, working through a region-availability error before landing on North Europe:

![Resource group creation via az CLI (subscription ID and username redacted)](images/phase0-resourcegroup-cli-output.png)

![The resulting resource group in the Azure portal (subscription ID, tenant domain and account details redacted)](images/phase0-resourcegroup-portal.png)

Once the custom initiative was assigned, attempting to create a resource that violates it - such as a firewall - was correctly denied:

![A firewall creation blocked by the Custom Initiative Assignment (account details redacted)](images/phase0-firewall-policy-blocked-test.png)

For the budget bicep file, three parameters are required, the overall budget cost for the operation which is represented as an integer, the start date for the budget consumption monitoring process, and the end date for the budget consumption monitoring process, with a default timeline of 10 years if no end date is specified.

![Budgets.bicep - amount and start/end date parameters, with the 30/60/90% notification thresholds (personal email redacted)](images/phase0-budgets-bicep-code.png)

alerts at 30, 60, and 90% of budget consumption were created and implemented to send an email alert to the user's personal email

![The deployed budget in Cost Management, showing the alert thresholds (account email redacted)](images/phase0-budget-deployed-portal.png)

After the creation of the policies and budgets bicep file, during deployment, an error in specification led to multiple failed deployments, with policies containing fields which used values like sku.name and sku.tier instead of the resource type prepended to the values, after some research, the source of the error was found and fixed, and the deployment was successfully published.

![The corrected field path (Microsoft.Compute/virtualMachines/sku.name) correctly enforcing the VM size policy (account details and name field redacted)](images/phase0-sku-field-fix-vm-test.png)

After the successful deployment of the custom initiative, the budget file was similarly deployed, but it failed due to the requirement of specific tags by the policy for any deployed resource, this was due to a specification of an all mode in the policy bicep file, requiring even the budgets to get assigned tags.

![The mode bug - 'CustomInitiativeAssignment' where 'Indexed' was needed](images/phase0-tags-policy-bug-mode.png)

the tags policy was then changed from an all mode to an indexed mode.

![The fix - mode set to 'Indexed'](images/phase0-tags-policy-fixed-mode.png)

This fixed the prolem, but another problem was introduced, an invalid start date, it was discovered that budgets start date must always be the first of the month.

![The budget deployment failing with "Please enter a valid start date" (subscription ID and username redacted)](images/phase0-budget-deployment-error.png)
