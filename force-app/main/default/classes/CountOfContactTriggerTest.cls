@isTest
public class CountOfContactTriggerTest {
    
    @isTest
    static void testBeforeInsert() {
        // Create test data (insert Contact records).
        List<Contact> testContacts = new List<Contact>();
        for (Integer i = 0; i < 3; i++) {
            testContacts.add(new Contact(FirstName = 'Test', LastName = 'Contact ' + i, AccountId = null));
        }
        insert testContacts;
        
        // Query Account records and assert their countofcontact__c values.
        List<Account> testAccounts = [SELECT Id, Name, countofcontact__c FROM Account];
        for (Account acc : testAccounts) {
            System.assertEquals(0, acc.countofcontact__c, 'countofcontact__c should be 0 for new accounts');
        }
    }
    
    @isTest
    static void testAfterInsert() {
        // Create a test Account and a related Contact.
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = testAccount.Id);
        insert testContact;
        
        // Query the Account and assert countofcontact__c value.
        Account updatedAccount = [SELECT Id, Name, countofcontact__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(1, updatedAccount.countofcontact__c, 'countofcontact__c should be 1 after contact insert');
    }
    
    @isTest
    static void testBeforeDelete() {
        // Create a test Account with a Contact.
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = testAccount.Id);
        insert testContact;
        
        // Delete the Contact record.
        delete testContact;
        
        // Query the Account and assert countofcontact__c value.
        Account updatedAccount = [SELECT Id, Name, countofcontact__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(0, updatedAccount.countofcontact__c, 'countofcontact__c should be 0 after contact delete');
    }
   
}