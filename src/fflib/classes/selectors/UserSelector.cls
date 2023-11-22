public with sharing class UserSelector extends fflib_SObjectSelector {
	private static Boolean includeFieldsetFields = false;

	public UserSelector() {
		super(includeFieldsetFields, fflib_SObjectSelector.DataAccess.USER_MODE);
	}

	public Schema.SObjectType getSObjectType() {
		return Schema.User.sObjectType;
	}

	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField>{ Schema.User.Id, Schema.User.FirstName, Schema.User.LastName, Schema.User.Email };
	}

	public override String getOrderBy() {
		return 'LastName ASC';
	}

	public List<User> selectById(Set<Id> UserIds) {
		return (List<User>) selectById(UserIds);
	}
}
