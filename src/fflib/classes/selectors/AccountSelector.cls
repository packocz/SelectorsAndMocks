public with sharing class AccountSelector extends fflib_SObjectSelector {
	private static Boolean includeFieldsetFields = false;

	public AccountSelector() {
		super(includeFieldsetFields, fflib_SObjectSelector.DataAccess.USER_MODE);
	}

	public Schema.SObjectType getSObjectType() {
		return Schema.Account.sObjectType;
	}

	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField>{
			Schema.Account.Id,
			Schema.Account.Name,
			Schema.Account.Website,
			Schema.Account.Description,
			Schema.Account.BillingAddress
		};
	}

	public override String getOrderBy() {
		return 'Name DESC';
	}

	public List<Account> selectById(Set<Id> accountIds) {
		return (List<Account>) selectById(accountIds);
	}

	public List<Account> selectByIdWithContacts(Set<Id> accountIds) {
		ContactSelector contacts = (ContactSelector) Application.Selector.newInstance(Schema.Contact.sObjectType);
		fflib_QueryFactory accountQuery = newQueryFactory().setCondition('Id IN :accountIds');
		accountQuery.subselectQuery('Contacts').selectFields(contacts.getSObjectFieldList());
		return (List<Account>) Database.query(accountQuery.toSOQL());
	}

	public List<Account> selectByRecordTypeDeveloperName(String rtName) {
		return (List<Account>) Database.query(newQueryFactory().setCondition('RecordType.DeveloperName = :rtName').toSOQL());
	}

	public List<Account> selectByParentId(Id parentId) {
		return (List<Account>) Database.query(newQueryFactory().setCondition('ParentId = :parentId').toSOQL());
	}
}
