/**
 * Copyright (c), FinancialForce.com, inc
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, 
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, 
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, 
 *      this list of conditions and the following disclaimer in the documentation 
 *      and/or other materials provided with the distribution.
 * - Neither the name of the FinancialForce.com, inc nor the names of its contributors 
 *      may be used to endorse or promote products derived from this software without 
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

/**
 * Class provides inner classes implementing factories for the main components
 * of the Apex Enterprise Patterns, Service, Unit Of Work, Selector and Domain.
 *   See the sample applications Application.cls file for an example
 **/
public virtual class fflib_Application
{
	


	/**
	 * Class implements a Selector class factory
	 **/
	public virtual class SelectorFactory implements fflib_ISelectorFactory
	{
		protected Map<SObjectType, Type> m_sObjectBySelectorType;
		protected Map<SObjectType, fflib_ISObjectSelector> m_sObjectByMockSelector;

		/**
		 * Constructs a simple Selector Factory
		 **/
		public SelectorFactory() { }

		/**
		 * Consturcts a Selector Factory linking SObjectType's with Apex Classes implement the fflib_ISObjectSelector interface
		 *   Note that the factory does not check the given Apex Classes implement the interface
		 *     currently this is not possible in Apex.
		 *
		 * @Param sObjectBySelectorType Map of SObjectType's to Selector Apex Classes
		 **/
		public SelectorFactory(Map<SObjectType, Type> sObjectBySelectorType)
		{
			m_sObjectBySelectorType = sObjectBySelectorType;
			m_sObjectByMockSelector = new Map<SObjectType, fflib_ISObjectSelector>();		
		}

		/**
		 * Creates a new instance of the associated Apex Class implementing fflib_ISObjectSelector
		 *   for the given SObjectType, or if provided via setMock returns the Mock implementation
		 *
		 * @param sObjectType An SObjectType token, e.g. Account.SObjectType
		 **/
		public virtual fflib_ISObjectSelector newInstance(SObjectType sObjectType)
		{
			// Mock implementation?
			if(m_sObjectByMockSelector.containsKey(sObjectType))
				return m_sObjectByMockSelector.get(sObjectType);

			// Determine Apex class for Selector class			
			Type selectorClass = m_sObjectBySelectorType.get(sObjectType);
			if(selectorClass==null)
				throw new DeveloperException('Selector class not found for SObjectType ' + sObjectType);

			// Construct Selector class and query by Id for the records
			return (fflib_ISObjectSelector) selectorClass.newInstance();			
		}

		/**
		 * Helper method to query the given SObject records
		 *   Internally creates an instance of the registered Selector and calls its
		 *     selectSObjectById method
		 *
		 * @param recordIds The SObject record Ids, must be all the same SObjectType
		 * @exception Is thrown if the record Ids are not all the same or the SObjectType is not registered
		 **/
		public virtual List<SObject> selectById(Set<Id> recordIds)
		{
			// No point creating an empty Domain class, nor can we determine the SObjectType anyway
			if(recordIds==null || recordIds.size()==0)
				throw new DeveloperException('Invalid record Id\'s set');	

			// Determine SObjectType
			SObjectType domainSObjectType = new List<Id>(recordIds)[0].getSObjectType();
			for(Id recordId : recordIds)
				if(recordId.getSobjectType()!=domainSObjectType)
					throw new DeveloperException('Unable to determine SObjectType, Set contains Id\'s from different SObject types');	

			// Construct Selector class and query by Id for the records
			return newInstance(domainSObjectType).selectSObjectsById(recordIds);
		}

		/**
		 * Helper method to query related records to those provided, for example
		 *   if passed a list of Opportunity records and the Account Id field will
		 *   construct internally a list of Account Ids and call the registered 
		 *   Account selector to query the related Account records, e.g.
		 *
		 *     List<Account> accounts = 
		 *        (List<Account>) Application.Selector.selectByRelationship(myOpps, Opportunity.AccountId);
		 *
		 * @param relatedRecords used to extract the related record Ids, e.g. Opportunity records
		 * @param relationshipField field in the passed records that contains the relationship records to query, e.g. Opportunity.AccountId
		 **/
		public virtual List<SObject> selectByRelationship(List<SObject> relatedRecords, SObjectField relationshipField)
		{
			Set<Id> relatedIds = new Set<Id>();
			for(SObject relatedRecord : relatedRecords)
			{
				Id relatedId = (Id) relatedRecord.get(relationshipField);
				if(relatedId!=null)
					relatedIds.add(relatedId);
			}
			return selectById(relatedIds);
		}

		@TestVisible
		protected virtual void setMock(fflib_ISObjectSelector selectorInstance)
		{
			m_sObjectByMockSelector.put(selectorInstance.sObjectType(), selectorInstance);
		} 
	}


	/**
	 * Exception representing a developer coding error, not intended for end user eyes
	 **/
	public class DeveloperException extends Exception { } 
}