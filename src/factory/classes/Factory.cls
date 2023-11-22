@NamespaceAccessible
public inherited sharing class Factory {
	private static Map<Type, Object> typeToMockImplementation = new Map<Type, Object>();

	@NamespaceAccessible
	public static Object newInstanceOf(Type requestedType) {
		if (typeToMockImplementation.containsKey(requestedType)) {
			return typeToMockImplementation.get(requestedType);
		}

		return requestedType.newInstance();
	}

	@NamespaceAccessible
	public static void setMock(Type mockedType, Object mockImplementation) {
		if (!Test.isRunningTest()) {
			//private cannot be namesapce accessible, this is alternative safecheck for use only in test
			throw new FactoryException('Cannot set mock outside of @IsTest');
		}
		typeToMockImplementation.put(mockedType, mockImplementation);
	}

	private class FactoryException extends Exception {
	}
}
