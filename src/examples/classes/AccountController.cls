public with sharing class AccountController {
	@AuraEnabled
	public static List<Account> getAccountsWithSpecialFields() {
		AccountSelector accounts = (AccountSelector) Application.Selector.newInstance(Schema.Account.sObjectType);

		return (List<Account>) Database.query(
			accounts.newQueryFactory()
				.selectFields(new List<SObjectField>{ Schema.Account.OwnerId, Schema.Account.LastModifiedDate })
				.setCondition('PersonEmail = NULL')
				.addOrdering('LastModifiedDate', fflib_QueryFactory.SortOrder.DESCENDING, false)
				.setLimit(5)
				.toSOQL()
		);
	}
}
