@IsTest
public with sharing class ExampleMock {
	@IsTest
	static void mockDoSomethingBasic() {
		List<Account> mockAccounts = new List<Account>{
			new Account(Name = 'My Name', Description = 'My Description'),
			new Account(Name = 'My Name2', Description = 'My Description'),
			new Account(Name = 'My Name3', Description = 'My Description'),
			new Account(Name = 'My Name4', Description = 'My Description'),
			new Account(Name = 'My Name5', Description = 'My Description')
		};

		Application.Selector.setMock(new SelectorMock(mockAccounts));

		Set<Id> accountIds = new Set<Id>(); //now does not matter
		new AccountService().doSomethingBasic(accountIds);
	}

	private class SelectorMock implements fflib_ISObjectSelector {
		private List<SObject> value;
		private SelectorMock(List<SObject> returnValue) {
			this.value = returnValue;
		}

		public Schema.SObjectType sObjectType() {
			return Schema.Account.sObjectType;
		}

		public List<SObject> selectSObjectsById(Set<Id> idSet) {
			return this.value;
		}
	}

	@IsTest
	static void mockDoSomethingBasic2() {
		List<Account> mockAccounts = new List<Account>{
			new Account(Name = 'My Name', Description = 'My Description'),
			new Account(Name = 'My Name2', Description = 'My Description'),
			new Account(Name = 'My Name3', Description = 'My Description'),
			new Account(Name = 'My Name4', Description = 'My Description'),
			new Account(Name = 'My Name5', Description = 'My Description')
		};

		SOQL.setMock('doSomethingBasic2', mockAccounts);

		Set<Id> accountIds = new Set<Id>(); //now does not matter
		new AccountService().doSomethingBasic2(accountIds);
	}
}
