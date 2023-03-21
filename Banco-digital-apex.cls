Trigger RealizaVenda on Venda__c (after insert, after update) {
    // Obtém os IDs dos cartões de crédito dos registros de venda inseridos ou atualizados
    Set<Id> idsCartoes = new Set<Id>();
    for (Venda__c venda : Trigger.new) {
        idsCartoes.add(venda.Cartao_de_Credito__c);
    }
    // Obtém os cartões de crédito correspondentes aos IDs obtidos
    List<Cartao_de_Credito__c> cartoes = [SELECT Id, Limite_Disponivel__c, Limite_Utilizado__c, Valor_da_fatura__c, Status__c 
                                          FROM Cartao_de_Credito__c 
                                          WHERE Id IN :idsCartoes];
    // Atualiza o limite utilizado e o limite disponível de cada cartão de crédito
    for (Cartao_de_Credito__c cartao : cartoes) {
         if (cartao.Status__c != 'Ativo') {
            for (Venda__c venda : Trigger.new) {
                venda.addError('Não foi possível realizar a compra pois o cartão não está ativo');
            }
        } else {
        Decimal novoLimiteUtilizado = 0;
        Decimal totalVendas = 0;
        for (Venda__c venda : Trigger.new) {
                novoLimiteUtilizado += venda.Valor_da_venda__c;
                totalVendas += venda.Valor_da_venda__c;
            }        
        if (novoLimiteUtilizado > cartao.Limite_Disponivel__c) {
            for (Venda__c venda : Trigger.new) {                
                    venda.addError('O valor da nova venda de R$ ' + venda.Valor_da_venda__c + ' excede o limite disponível de R$ ' + cartao.Limite_Disponivel__c + ' do cartão de crédito.');                
            }
        } else {
            cartao.Limite_Utilizado__c = cartao.Limite_Utilizado__c + novoLimiteUtilizado;
            cartao.Limite_Disponivel__c = cartao.Limite_Disponivel__c - novoLimiteUtilizado;
            cartao.Valor_da_fatura__c = cartao.Valor_da_fatura__c + totalVendas;
            update cartao;
        	}
    	}
	}
}
