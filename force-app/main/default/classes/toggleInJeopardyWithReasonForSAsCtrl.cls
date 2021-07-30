/*************************************************************************************************************
 * @name			toggleInJeopardyForServiceAppointment
 * @author			Patrick Brinksma
 * @created			30 / 07 / 2021
 * @description		Example custom action for the Salesforce Field Service Dispatcher Console. This example
 *                  sets the In Jeopardy flag for one or more selected service appointments with a 
 *                  provided reason.
 *
 * Changes (version)
 * -----------------------------------------------------------------------------------------------------------
 * 				No.		Date			Author					Description
 * 				----	------------	--------------------	----------------------------------------------
 * @version		1.0		2021-07-30		Patrick Brinksma		Initial version
 *
**************************************************************************************************************/
public with sharing class toggleInJeopardyWithReasonForSAsCtrl {

    private final List<Id> saIds;

    public ServiceAppointment sa {get; set;}
    public Boolean sasSaved {get; private set;}

    public toggleInJeopardyWithReasonForSAsCtrl() {
        // Get URL parameters (see https://developer.salesforce.com/docs/atlas.en-us.232.0.field_service_dev.meta/field_service_dev/fsl_dev_code_samples_dispatcher.htm)
        String saId = ApexPages.currentPage().getParameters().get('id');
        String saIds = ApexPages.currentPage().getParameters().get('services');

        if (saId != null){
            this.saIds = new List<Id>{saId};
        } else if (saIds != null){
            this.saIds = saIds.split(',');
        }

        this.sa = new ServiceAppointment();
    }

    public PageReference saveSAs(){
        try {
            List<ServiceAppointment> sas = new List<ServiceAppointment>();
            for (Id saId : saIds){
                sas.add(
                    new ServiceAppointment(
                        Id = saId,
                        FSL__InJeopardy__c = true,
                        FSL__InJeopardyReason__c = this.sa.FSL__InJeopardyReason__c
                    )
                );
            }
            if (!sas.isEmpty()){
                update sas;
            }
            this.sasSaved = true;
        }
        catch (Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, e.getMessage()));            
        }        

        return null;
    }
}
