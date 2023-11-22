public with sharing class AccountSOQL extends SOQL implements SOQL.Selector {
	public static AccountSOQL query() {
		return new AccountSOQL();
	}

	private AccountSOQL() {
		super(Account.SObjectType);
		// default settings
		with(Account.Id, Account.Name, Account.Website, Account.Description, Account.BillingAddress).withSharing().orderBy('Name', 'DESC');
	}

	public AccountSOQL byRecordTypeDeveloperName(String rt) {
		whereAre(Filter.recordType().equal(rt));
		return this;
	}

	public AccountSOQL byParentId(Id parentId) {
		with(Account.ParentId).whereAre(Filter.with(Account.ParentId).equal(parentId));
		return this;
	}

	public AccountSOQL withContacts() {
		with(SOQL.SubQuery.of('Contacts').with(ContactSOQL.query().getFields()));
		return this;
	}
}
