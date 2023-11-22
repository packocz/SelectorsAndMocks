public with sharing class AccountSomethingService {
	public static void doSomethingBasic(Set<Id> accountIds) {
		service().doSomethingBasic(accountIds);
	}
	public static void doSomethingSpecial() {
		service().doSomethingSpecial();
	}

	private static IAccountSomethingService service() {
		return (IAccountSomethingService) Application.Service.newInstance(IAccountSomethingService.class);
	}
}
