/*
* Author  : Prithvi
* Created : 2nd Nov
* Purpose : Factory class.
*/
global class IntegrationFactory {
    
    global static IntegrationService getBaseIntegrationService() {
        IntegrationAPIRepository repository = IntegrationAPIRepository.getInstance();
        return new IntegrationService(repository);
    }
}