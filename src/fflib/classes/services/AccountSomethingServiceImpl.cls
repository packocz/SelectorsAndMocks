public with sharing class AccountSomethingServiceImpl {
	public void doSomethingBasic(Set<Id> accountIds) {
		List<Account> accountsToDoMagicWith = Application.Selector.selectById(accountIds);
		System.debug('doSomethingBasic');
		for (Account acc : accountsToDoMagicWith) {
			System.debug(acc);
		}
	}
	public void doSomethingSpecial() {
		AccountSelector accounts = (AccountSelector) Application.Selector.newInstance(Schema.Account.sObjectType);

		List<Account> accountsToDoMagicWith = (List<Account>) Database.query(
			accounts.newQueryFactory()
				.selectFields(new List<SObjectField>{ Schema.Account.OwnerId, Schema.Account.LastModifiedDate })
				.setCondition('Website = NULL')
				.addOrdering('LastModifiedDate', fflib_QueryFactory.SortOrder.DESCENDING, false)
				.setLimit(5)
				.toSOQL()
		);
		System.debug('doSomethingSpecial');
		for (Account acc : accountsToDoMagicWith) {
			System.debug(acc);
		}
	}
}
