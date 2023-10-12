public with sharing class AccountServiceQueries {
	// custom queries
	public void doSomethingSpecial() {
		AccountSelector accounts = (AccountSelector) Application.Selector.newInstance(Schema.Account.sObjectType);

		System.debug(
			accounts.newQueryFactory()
				.selectFields(new List<SObjectField>{ Schema.Account.OwnerId, Schema.Account.LastModifiedDate })
				.setCondition('PersonEmail = NULL')
				.addOrdering('LastModifiedDate', fflib_QueryFactory.SortOrder.DESCENDING, false)
				.setLimit(5)
				.toSOQL()
		);
	}

	public void doSomethingSpecial2() {
		System.debug(
			AccountSOQL.query()
				.with(new List<SObjectField>{ Schema.Account.OwnerId, Schema.Account.LastModifiedDate })
				.whereAre(SOQL.Filter.with(Account.PersonEmail).equal(null))
				.orderBy('LastModifiedDate', 'DESC')
				.setLimit(5)
				.toString()
		);
	}
}
