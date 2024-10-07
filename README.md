# SFS Custom Actions For Dispatcher Console

A set of examples for customer actions for the Salesforce Field Service Dispatcher Console.

The following examples are included:
- Toggle In Jeopardy flag for one or more selected service appointments
- Set In Jeopardy flag for one of more selected service appointments with a provided In Jeopardy Reason
- Create a resource absence for one or more service resources
- Edit a single existing resource absence

## Disclaimer
This repository contains code intended to help Salesforce Field Service customers and partners accelerate their implementations. Please note the following:
* This code is not an official Salesforce product.
* It is not officially supported by Salesforce.
* The code serves as an example of how to implement specific functionality or make use of certain features.

Before using this code in a production environment, it is crucial that you:
* Adopt the code to fit your specific needs.
* Test thoroughly to ensure it works as expected in your environment.
* Consider the code to be your own and take full responsibility for its use.

By using this code, you acknowledge that Salesforce is not liable for any issues that may arise from its use.

## How To Use

- Please review the help documentation on how to create custom actions: https://help.salesforce.com/articleView?id=sf.pfs_create_custom_actions.htm&type=5
- Please review the code examples provided here: https://developer.salesforce.com/docs/atlas.en-us.232.0.field_service_dev.meta/field_service_dev/fsl_dev_code_samples_dispatcher.htm

### Components

Type | Name | Description
--- | --- | ---
Apex Class | toggleInJeopardyForServiceAppointment | Toggles the In Jeopardy flag for one or more selected service appointments. This can be used as a custom action in the Services List, as a Bulk Action and on the Gantt.
Visualforce Page | toggleInJeopardyWithReasonForSAs | Set the In Jeopardy flag for one or more selected service appointments and allows the user to select the In Jeopary Reason. This can be used as a custom action in the Services List, as a Bulk Action and on the Gantt.
Apex Class | toggleInJeopardyWithReasonForSAsCtrl | Controller class for Visualforce Page toggleInJeopardyWithReasonForSAs.
Visualforce Page | createBlockerForServiceResource | Create a resource absence for a service resource and optionally for more selected service resources of the same service territory. This can be used as a custom action for a service resource.
Apex Class | createBlockerForServiceResourceCtrl | Controller class for Visualforce Page createBlockerForServiceResource.
Visualforce Page | editBlockerForServiceResource | Edit an existing resource absence directly on the gantt. This can be used as a custom action for a resource absence.
Apex Class | editExistingResourceAbsenceCtrl | Controller class for Visualforce Page editBlockerForServiceResource.
