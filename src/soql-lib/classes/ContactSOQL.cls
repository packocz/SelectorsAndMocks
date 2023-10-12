public with sharing class ContactSOQL extends SOQL implements SOQL.Selector {
	public static ContactSOQL query() {
		return new ContactSOQL();
	}

	//could extend
	public List<SObjectField> getFields() {
		return new List<SObjectField>{ Schema.Contact.Id, Schema.Contact.FirstName, Schema.Contact.LastName, Schema.Contact.Email };
	}

	private ContactSOQL() {
		super(Contact.SObjectType);
		// default settings
		with(Schema.Contact.Id, Schema.Contact.FirstName, Schema.Contact.LastName, Schema.Contact.Email)
			.withSharing()
			.orderBy('LastName', 'ASC');
	}

	public ContactSOQL byAccountIds(Set<Id> accountIds) {
		whereAre(Filter.with(Schema.Contact.AccountId).isIn(accountIds));
		return this;
	}
}
