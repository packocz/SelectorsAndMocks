public with sharing class Application {
	public static final fflib_Application.SelectorFactory Selector = new fflib_Application.SelectorFactory(
		new Map<SObjectType, Type>{
			Account.SObjectType => AccountSelector.class,
			Contact.SObjectType => ContactSelector.class,
			User.SObjectType => UserSelector.class
		}
	);

	public static final fflib_Application.ServiceFactory Service = new fflib_Application.ServiceFactory(
		new Map<Type, Type>{ IAccountSomethingService.class => AccountSomethingServiceImpl.class }
	);
}
