public with sharing class AccountService {
	public static AccountService newInstance() {
		return (AccountService) Factory.newInstanceOf(AccountService.class);
	}

	public void doSomethingBasic(Set<Id> accountIds) {
		List<Account> accountsToDoMagicWith = Application.Selector.selectById(accountIds);
		System.debug('doSomethingBasic');
		for (Account acc : accountsToDoMagicWith) {
			System.debug(acc);
		}
	}

	public void doSomethingBasic2(Set<Id> accountIds) {
		List<Account> accountsToDoMagicWith = AccountSOQL.query().byIds(accountIds).mockId('doSomethingBasic2').toList();
		System.debug('doSomethingBasic2');
		for (Account acc : accountsToDoMagicWith) {
			System.debug(acc);
		}
	}

	// predefined queries
	public void doSomethingFrequent(String rtName) {
		AccountSelector accounts = (AccountSelector) Application.Selector.newInstance(Schema.Account.sObjectType);
		List<Account> accountsToDoMagicWith = accounts.selectByRecordTypeDeveloperName(rtName);
		System.debug('doSomethingFrequent');
		for (Account acc : accountsToDoMagicWith) {
			System.debug(acc);
		}
	}

	public void doSomethingFrequent2(String rtName) {
		List<Account> accountsToDoMagicWith = AccountSOQL.query().byRecordTypeDeveloperName('rtName').toList();
		System.debug('doSomethingFrequent2');
		for (Account acc : accountsToDoMagicWith) {
			System.debug(acc);
		}
	}

	// custom queries
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

	public void doSomethingSpecial2() {
		List<Account> accountsToDoMagicWith = AccountSOQL.query()
			.with(new List<SObjectField>{ Schema.Account.OwnerId, Schema.Account.LastModifiedDate })
			.whereAre(SOQL.Filter.with(Account.Website).equal(null))
			.orderBy('LastModifiedDate', 'DESC')
			.setLimit(5)
			.mockId('Service.method')
			.toList();
		System.debug('doSomethingSpecial2');
		for (Account acc : accountsToDoMagicWith) {
			System.debug(acc);
		}
	}

	public void queryWithChildren() {
		AccountSelector accounts = (AccountSelector) Application.Selector.newInstance(Schema.Account.sObjectType);
		System.debug('queryWithChildren');
		for (
			Account acc : accounts.selectByIdWithContacts(new Set<Id>{ '0011w00001ktMuIAAU', '0011w00001ktMuHAAU', '0011w00001ktMuEAAU' })
		) {
			System.debug(acc.Contacts);
		}
	}

	public void queryWithChildren2() {
		System.debug('queryWithChildren2');
		for (
			Account acc : (List<Account>) AccountSOQL.query()
				.withContacts()
				.byIds(new Set<Id>{ '0011w00001ktMuIAAU', '0011w00001ktMuHAAU', '0011w00001ktMuEAAU' })
				.toList()
		) {
			System.debug(acc.Contacts);
		}
	}

	public void queryParent() {
		AccountSelector accounts = (AccountSelector) Application.Selector.newInstance(Schema.Account.sObjectType);
		UserSelector users = (UserSelector) Application.Selector.newInstance(Schema.User.sObjectType);
		List<Account> accountsWithCreatedAndModifiedBy = (List<Account>) Database.query(
			accounts.newQueryFactory()
				.setLimit(5)
				.selectFields(users.getRelatedFieldListString('LastModifiedBy').split(','))
				.selectFields(users.getRelatedFieldListString('CreatedBy').split(','))
				.toSOQL()
		);
		System.debug('queryParent');
		for (Account acc : accountsWithCreatedAndModifiedBy) {
			System.debug(acc.Name);
			System.debug(acc.LastModifiedBy);
			System.debug(acc.CreatedBy);
		}
	}

	public void queryParent2() {
		System.debug('queryParent');
		for (
			Account acc : (List<Account>) AccountSOQL.query()
				.with('LastModifiedBy', UserSOQL.query().getFields())
				.with('CreatedBy', UserSOQL.query().getFields())
				.setLimit(5)
				.toList()
		) {
			System.debug(acc.Name);
			System.debug(acc.LastModifiedBy);
			System.debug(acc.CreatedBy);
		}
	}
}
