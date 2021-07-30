/*************************************************************************************************************
 * @name			toggleInJeopardyForServiceAppointment
 * @author			Patrick Brinksma
 * @created			30 / 07 / 2021
 * @description		Example custom action for the Salesforce Field Service Dispatcher Console. This example
 *                  toggles the In Jeopardy flag for one or more selected service appointments.
 *
 * Changes (version)
 * -----------------------------------------------------------------------------------------------------------
 * 				No.		Date			Author					Description
 * 				----	------------	--------------------	----------------------------------------------
 * @version		1.0		2021-07-30		Patrick Brinksma		Initial version
 *
**************************************************************************************************************/
global class toggleInJeopardyForServiceAppointment implements FSL.CustomGanttServiceAppointmentAction {

    // Implement action interface method
    global String action(List<Id> serviceAppointmentsIds, Datetime ganttStartDate, Datetime ganttEndDate, Map<String, Object> additionalParameters) {
        // Toggle In Jeopardy checkbox on SAs
        List<String> saNames = new List<String>();
        if (!serviceAppointmentsIds.isEmpty()) {
            List<ServiceAppointment> listOfSA = [select Id, AppointmentNumber, FSL__InJeopardy__c, FSL__InJeopardyReason__c from ServiceAppointment where Id in :serviceAppointmentsIds];
            for (ServiceAppointment sa : listOfSA) {
                saNames.add(sa.AppointmentNumber);
                sa.FSL__InJeopardy__c = !sa.FSL__InJeopardy__c;
                if (!sa.FSL__InJeopardy__c){
                    sa.FSL__InJeopardyReason__c = null;
                }
            }
            update listofSA;
        }
        // This return message is shown in the notification envelop on the Gantt
        return 'In Jeopardy toggled for appointments: ' + String.join(saNames, ', ');
    }
}