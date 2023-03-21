public static Boolean isValidCNPJ(String cnpj) {
		if (cnpj == null) {
			return false;
		}
	
		// remove pontos, traços e barras do CNPJ
		cnpj = cnpj.replaceAll('[^0-9]', '');
	
		if (cnpj.length() != 14) {
			return false;
		}
	
		Integer[] pesos = new Integer[]{5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2};
	
		// cálculo dos dígitos verificadores
		Integer[] digitosVerificadores = new Integer[2];
		Boolean digitosValidos = true;
		for (Integer k = 0; k < 1; k++) {
			Integer soma = 0;
			for (Integer i = 0; i < 12 + k; i++) {
				soma += Integer.valueOf(cnpj.substring(i, i + 1)) * pesos[i + k];
			}
			Integer resto = 0;
			Integer valor = soma;
			while (valor >= 11) {
				valor -= 11;
			}
			resto = valor;
			digitosVerificadores[k] = (resto < 2) ? 0 : (11 - resto);
			if (Integer.valueOf(cnpj.substring(12 + k, 13 + k)) != digitosVerificadores[k]) {
				digitosValidos = false;
				break;
			}
		}
		return digitosValidos;
	}
