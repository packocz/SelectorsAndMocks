public with sharing class Application {
	public static final fflib_Application.SelectorFactory Selector = new fflib_Application.SelectorFactory(
		new Map<SObjectType, Type>{
			Account.SObjectType => AccountSelector.class,
			Contact.SObjectType => ContactSelector.class,
			User.SObjectType => UserSelector.class
		}
	);
}
