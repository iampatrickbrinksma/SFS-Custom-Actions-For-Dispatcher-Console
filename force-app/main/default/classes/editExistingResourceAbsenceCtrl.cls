/*************************************************************************************************************
 * @name			editExistingResourceAbsenceCtrl
 * @author			Patrick Brinksma
 * @created			30 / 07 / 2021
 * @description		Example custom action for the Salesforce Field Service Dispatcher Console. This example
 *                  edits a single existing resource absence.
 *
 * Changes (version)
 * -----------------------------------------------------------------------------------------------------------
 * 				No.		Date			Author					Description
 * 				----	------------	--------------------	----------------------------------------------
 * @version		1.0		2021-07-30		Patrick Brinksma		Initial version
 *
**************************************************************************************************************/
public with sharing class editExistingResourceAbsenceCtrl {

    // Resource Absence record to edit
    public ResourceAbsence ra {get; set;}

    // Indicate if record was saved
    public Boolean blockerSaved {get; set;}

    // Constructor
    public editExistingResourceAbsenceCtrl(ApexPages.StandardController stdCtrl) {
        stdCtrl.addFields(new List<String>{'Start', 'End', 'Type', 'Description', 'Resource.Name'});
        this.ra = (ResourceAbsence)stdCtrl.getRecord();
    }

    // Save the Resource Absence(s)
    public PageReference saveBlocker(){
        try {
            update this.ra;        
            this.blockerSaved = true;
        }
        catch (Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, e.getMessage()));            
        }
        return null;
    }    
}
