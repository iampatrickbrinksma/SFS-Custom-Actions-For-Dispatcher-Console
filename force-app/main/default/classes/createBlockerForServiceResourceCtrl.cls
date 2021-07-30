/*************************************************************************************************************
 * @name			createBlockerForServiceResourceCtrl
 * @author			Patrick Brinksma
 * @created			30 / 07 / 2021
 * @description		Example custom action for the Salesforce Field Service Dispatcher Console. This example
 *                  creates a resource absence for one or more service resources.
 *
 * Changes (version)
 * -----------------------------------------------------------------------------------------------------------
 * 				No.		Date			Author					Description
 * 				----	------------	--------------------	----------------------------------------------
 * @version		1.0		2021-07-30		Patrick Brinksma		Initial version
 *
**************************************************************************************************************/
public class createBlockerForServiceResourceCtrl {
    
    // Service Resource - comes with standard controller
    private final ServiceResource sr;
    
    // Service Territory Member Id which is passed into the VF Page URL
    // See https://developer.salesforce.com/docs/atlas.en-us.232.0.field_service_dev.meta/field_service_dev/fsl_dev_code_samples_dispatcher.htm
    private final Id stmId;

    // Time horizon on the Gantt (passed via URL params)
    public Date start {get; private set;}
    public Date finish {get; private set;}

    // Indication the blocker was saved
    public Boolean blockerSaved {get; private set;}

    // Resource Absence used for the blocker
    public ResourceAbsence ra {get; set;}

    // Selected members from the STM
    private List<String> selectedSTMMembers = new List<String>();

    // Getter and Setter for the apex:selectCheckboxes component
    public List<String> getSelectedMembers(){
        return this.selectedSTMMembers;
    }
    public void setSelectedMembers(List<String> selectedMembers){
        this.selectedSTMMembers = selectedMembers;
    }

    // Service Territory from which the custom action was launched
    public ServiceTerritory st {
        get {
            if (st == null){
                Id stId = [select ServiceTerritoryId from ServiceTerritoryMember where Id = :this.stmId].ServiceTerritoryId;
                st = [select Id, Name from ServiceTerritory where Id = :stId];
            }
            return st;
        }
        private set;
    }

    // The other Service Territory Members which are active in the ST during the Gantt time horizon 
    private List<ServiceTerritoryMember> stms {
        get {
            if (stms == null) {
                stms = [select 
                            Id, 
                            ServiceResourceId, 
                            ServiceResource.Name 
                        from 
                            ServiceTerritoryMember 
                        where 
                            ServiceResourceId != :this.sr.Id and 
                            ServiceTerritoryId = :this.st.Id and
                            EffectiveStartDate <= :this.start and 
                            (   
                                EffectiveEndDate = null or 
                                EffectiveEndDate > :this.start
                            )
                ];
            }
            return stms;
        }
        private set;
    }

    // Resource Absence Non Availability record type id
    private Id raRTId {
        get {
            if (raRTId == null) {
                raRTId = [select Id from RecordType where SobjectType = 'ResourceAbsence' and NamespacePrefix = 'FSL' and DeveloperName = 'Non_Availability'].Id;    
            }
            return raRTId;
        }
        set;
    } 

    // Constructor
    public createBlockerForServiceResourceCtrl(ApexPages.StandardController stdCtrl) {
        // Get Service Resource details
        stdCtrl.addFields(new List<String>{'Name'});
        this.sr = (ServiceResource)stdCtrl.getRecord();

        // Get URL parameters (see https://developer.salesforce.com/docs/atlas.en-us.232.0.field_service_dev.meta/field_service_dev/fsl_dev_code_samples_dispatcher.htm)
        this.stmId = ApexPages.currentPage().getParameters().get('stm');

        // Gantt time horizon
        this.start = convertStringToDate(ApexPages.currentPage().getParameters().get('start'));
        this.finish = convertStringToDate(ApexPages.currentPage().getParameters().get('end'));
        
        // Initialize a new Resource Absence
        newResourceAbsence();

    }

    // Initialize page for new blocker
    public PageReference newBlocker(){
        newResourceAbsence();
        this.blockerSaved = false;
        return null;
    }

    // Save the Resource Absence(s)
    public PageReference saveBlocker(){
        try {
            List<ResourceAbsence> ras = new List<ResourceAbsence>();
            // If additional members where selected, create blockers for them too
            if (this.selectedSTMMembers != null){
                for (String selectedSTMMember : this.selectedSTMMembers){
                    ResourceAbsence newRA = this.ra.clone(false, false, false, false);
                    newRA.ResourceId = selectedSTMMember;
                    ras.add(newRA);
                }
            }
            ras.add(this.ra);
            insert ras;
            
            this.blockerSaved = true;
        }
        catch (Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, e.getMessage()));            
        }        

        return null;
    }

    // Collection for the apex:selectCheckboxes component
    public List<SelectOption> getSTMMembers(){
        List<SelectOption> mems = new List<SelectOption>();
        for (ServiceTerritoryMember stm : stms){
            mems.add(new SelectOption(stm.ServiceResourceId, stm.ServiceResource.Name));
        }
        return mems;
    }

    // Convert the MM-DD-YYYY string into a date
    private Date convertStringToDate(String dtStr){
        String month = dtStr.subString(0, dtStr.indexOf('-'));
        String day = dtStr.subString(dtStr.indexOf('-') + 1, dtStr.lastIndexOf('-'));
        String year = dtStr.right(4);
        return Date.valueOf(year + '-' + month + '-' + day);
    }

    // New blocker
    private void newResourceAbsence(){
        ra = new ResourceAbsence(
            RecordTypeId = this.raRTId,
            ResourceId = this.sr.Id,
            Start = this.start,
            End = this.finish
        );        
    }

}
