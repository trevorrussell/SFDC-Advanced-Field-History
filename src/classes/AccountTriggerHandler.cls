public with sharing class AccountTriggerHandler {
	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	
	public AccountTriggerHandler(boolean isExecuting, integer size){
		m_isExecuting = isExecuting;
		BatchSize = size;
	}
	
	public void OnBeforeInsert(Account[] newRecords){
	}
	
	public void OnAfterInsert(Account[] newRecords){
	}
	
	@future public static void OnAfterInsertAsync(Set<ID> newRecordIDs){
	}
	
	public void OnBeforeUpdate(Account[] oldRecords, Account[] updatedRecords, Map<ID, Account> recordMap){
	}
	
	public void OnAfterUpdate(Account[] oldRecords, Account[] updatedRecords, Map<ID, Account> oldRecordMap,  Map<ID, Account> newRecordMap){
		AdvancedFieldHistoryAction.RecordFieldChanges(oldRecordMap, newRecordMap);
	}
	
	@future public static void OnAfterUpdateAsync(Set<ID> updatedRecordIDs){
	}
	
	public void OnBeforeDelete(Account[] recordsToDelete, Map<ID, Account> recordMap){
	}
	
	public void OnAfterDelete(Account[] deletedRecords, Map<ID, Account> recordMap){
	}
	
	@future public static void OnAfterDeleteAsync(Set<ID> deletedRecordIDs){
	}
	
	public void OnUndelete(Account[] restoredRecords){
	}
	
	public boolean IsTriggerContext{
		get{ return m_isExecuting;}
	}
	
	public boolean IsVisualforcePageContext{
		get{ return !IsTriggerContext;}
	}
	
	public boolean IsWebServiceContext{
		get{ return !IsTriggerContext;}
	}
	
	public boolean IsExecuteAnonymousContext{
		get{ return !IsTriggerContext;}
	}
}