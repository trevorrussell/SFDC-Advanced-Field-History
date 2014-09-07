@isTest (seeAllData=false)
public class AdvancedFieldHistoryAction_Test {
	
	public static testMethod void myTest(){
		//create Account records to test
		Map<ID,Account> oldMap = new Map<ID,Account>();
		Map<ID,Account> newMap = new Map<ID,Account>();
		Account acc = new Account(name = 'TestOld');
		insert acc;
		oldMap.put(acc.id, acc);
		acc.name = 'TestNew';
		acc.phone = '408-555-1212';
		update acc;
		newMap.put(acc.id, acc);
		AdvancedFieldHistoryAction.RecordFieldChanges(oldMap, newMap);
		Advanced_Field_History__c afh = [SELECT id
										, Field_Name__c
										, Old_Value__c
										, New_Value__c
										FROM Advanced_Field_History__c
										WHERE Field_Name__c = 'Account Name'
										LIMIT 1];
		system.debug('afh: '+ afh);

		system.assertEquals(afh.Old_Value__c, 'TestOld');
		system.assertEquals(afh.New_Value__c, 'TestNew');
		
		}
}