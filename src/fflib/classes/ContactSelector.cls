public with sharing class ContactSelector extends fflib_SObjectSelector {
	private static Boolean includeFieldsetFields = false;

	public ContactSelector() {
		super(includeFieldsetFields, fflib_SObjectSelector.DataAccess.USER_MODE);
	}

	public Schema.SObjectType getSObjectType() {
		return Schema.Contact.sObjectType;
	}

	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField>{ Schema.Contact.Id, Schema.Contact.FirstName, Schema.Contact.LastName, Schema.Contact.Email };
	}

	public override String getOrderBy() {
		return 'LastName ASC';
	}

	public List<Contact> selectById(Set<Id> contactIds) {
		return (List<Contact>) selectById(contactIds);
	}

	public List<Contact> selectByAccountIds(Set<Id> accountIds) {
		return (List<Contact>) Database.query(newQueryFactory().setCondition('AccountId IN :contactIds').toSOQL());
	}
}
