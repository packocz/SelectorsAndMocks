public with sharing class UserSOQL extends SOQL implements SOQL.Selector {
	public static UserSOQL query() {
		return new UserSOQL();
	}

	public List<SObjectField> getFields() {
		return new List<SObjectField>{ User.Id, User.FirstName, User.LastName, User.Email };
	}

	private UserSOQL() {
		super(User.SObjectType);
		// default settings
		with(User.Id, User.FirstName, User.LastName, User.Email).withSharing().orderBy('LastName', 'ASC');
	}
}
