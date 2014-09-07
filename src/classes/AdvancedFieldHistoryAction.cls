public class AdvancedFieldHistoryAction {
    
    public static void RecordFieldChanges(Map<ID,SObject> oldRecordMap, Map<ID,SObject> newRecordMap){
        
        string objectLabel = string.valueOf(oldRecordMap.getSObjectType().getDescribe().getLabel());
        string[] objectName = new string[]{string.valueOf(oldRecordMap.getSObjectType())};
        List<Schema.FieldSetMember> trackedFields = LookupTrackedFields(objectName);
        List<Advanced_Field_History__c> fieldChanges = new List<Advanced_Field_History__c>();
        String lookupFieldName = 'Record__c'; //default id field if no lookup found
        
        // get the advanced field history lookup field name that matches the object name
        Map <String, String> labelToAPIName = new Map <String, String> ();
        Map<String, Schema.SObjectField> fieldsMap = Schema.SObjectType.Advanced_Field_History__c.fields.getMap();
        for (Schema.SObjectField field : fieldsMap.values()){
            labelToAPIName.put(field.getDescribe().getLabel(), field.getDescribe().getName());
        }

        if(labelToAPIName.get(objectLabel) != null) lookupFieldName = labelToAPIName.get(objectLabel);
        
        for(ID recordID:newRecordMap.keySet()){
            SObject myNewRecord = newRecordMap.get(recordID);
            SObject myOldRecord = oldRecordMap.get(recordID);
            for (Schema.FieldSetMember fsm : trackedFields) {
                String fieldName  = fsm.getFieldPath();
                String fieldLabel = fsm.getLabel();
                
                if (myNewRecord.get(fieldName) != myOldRecord.get(fieldName)) {
                    String oldValue = String.valueOf(myOldRecord.get(fieldName));
                    String newValue = String.valueOf(myNewRecord.get(fieldName));
                    if (oldValue != null && oldValue.length()>255) oldValue = oldValue.substring(0,255);
                    if (newValue != null && newValue.length()>255) newValue = newValue.substring(0,255); 
                    
                    Advanced_Field_History__c afh = new Advanced_Field_History__c();
                    afh.Field_Name__c      = fieldLabel;
                    afh.API_Field_Name__c  = fieldName;
                    afh.ChangedBy__c  = UserInfo.getUserId();
                    afh.Old_Value__c  = oldValue;
                    afh.New_Value__c  = newValue;
                    afh.Object__c = objectName[0];
                    afh.put(lookupFieldName, recordID);
                    fieldChanges.add(afh);
                }
            }
        }
        insert fieldChanges;
    }
    
    
    public static list<Schema.FieldSetMember> LookupTrackedFields(string[] objectName){
        //string[] objectName = new string[]{'Account'};
        
        List<Schema.FieldSetMember> trackedFields = new List<Schema.FieldSetMember>();
        
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(objectName);
        for(Schema.DescribeSobjectResult res : results) {
            trackedFields = res.fieldsets.getMap().get('HistoryTracking').getFields();
        }
        if (trackedFields.isEmpty()) return null;
        return trackedFields;
    }
}
