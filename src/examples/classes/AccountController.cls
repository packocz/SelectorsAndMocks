public with sharing class AccountController {
	@AuraEnabled
	public static List<Account> getAccountsWithSpecialFields() {
		AccountSelector accounts = (AccountSelector) Application.Selector.newInstance(Schema.Account.sObjectType);

		return (List<Account>) Database.query(
			accounts.newQueryFactory()
				.selectFields(new List<SObjectField>{ Schema.Account.OwnerId, Schema.Account.LastModifiedDate })
				.setCondition('Website = NULL')
				.addOrdering('LastModifiedDate', fflib_QueryFactory.SortOrder.DESCENDING, false)
				.setLimit(5)
				.toSOQL()
		);
	}

	private static final AccountService accounts = AccountService.newInstance();
	public static void doSomethingBasic(Set<Id> accountIds) {
		AccountService.newInstance().doSomethingBasic(accountIds);
		//nebo
		accounts.doSomethingBasic(accountIds);

		//namisto
		AccountService accounts = (AccountService) Factory.newInstanceOf(AccountService.class);
		accounts.doSomethingBasic(accountIds);
	}

	public static void doSomethingBasicFflib(Set<Id> accountIds) {
		AccountSomethingService.doSomethingBasic(accountIds);
	}
}
