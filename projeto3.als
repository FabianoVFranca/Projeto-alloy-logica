module SistemaControleAcesso

sig Sistema {}

sig Organizacao {
    compoeUmSistema: one Sistema
}

sig Repositorio {
	// Repositorios sao sempre gerenciados dentro de uma unica organizacao
    	organizacao: one Organizacao
}

sig Usuario {
	// Usuario pode pertencer a uma unica organizacao ou a nenhuma
    	organizacao: lone Organizacao,
	perteceASistema: one Sistema,
	// Subconjunto que indica os repositorios que o usuario acessa
   	acessa: set Repositorio,
	//  Subconjunto que indica os repositorios que o usuario trabalha
    	trabalha: set Repositorio 
}

// -- Fatos --- 

//  Esse fato controla a especificacao: "usuarios so podem acessar repositorios da mesma organizacao"
fact controleAcesso {
    all u: Usuario | all r: u.acessa | r.organizacao = u.organizacao
    all u: Usuario | all r: u.trabalha | r.organizacao = u.organizacao
}

// Esse fato controla a especificacao: "desenvolverdor participa ativamente de no maximo cinco repositorios"
fact limiteDeRepositoriosDeTrabalho {
	all u: Usuario | devparticipaMaxCincoRepositorios[u]
}

// Se um usuario trabalha em um repositorio, ele obrigatoriamente tambem deve acessa-lo
fact usarioTrabalhaEAcessa {
	all u: Usuario | u.trabalha in u.acessa
}

fact isolamentoEntreSistemas {
    all u: Usuario | all r: u.acessa |
        r.organizacao.compoeUmSistema = u.perteceASistema
    
    all u: Usuario | all r: u.trabalha |
        r.organizacao.compoeUmSistema = u.perteceASistema
    
    all u: Usuario | some u.organizacao implies
        u.organizacao.compoeUmSistema = u.perteceASistema
}


// Predicado que verifica se um desenvolvedor esta dentro do limite de acesso a repositorios
pred devparticipaMaxCincoRepositorios[u: Usuario] {
	 #u.trabalha <= 5
}


// ---- Asserts ----

// Verifica que todos os desenvolvedores respeitam o limite de participacao
assert verificaLimiteAcessoDev {
	all u: Usuario | devparticipaMaxCincoRepositorios[u]
}
// Verifica se todos repositorios acessados pelo usuario sao da sua organizacao
assert usuarioAcessaApenasRepositorioDeOrganizacao {
    not some u: Usuario | some r: u.acessa | r.organizacao != u.organizacao
}
// Verifica se todos os usuarios trabalham apenas em repositorios da sua organização
assert usuarioTrabalhaApenasRepositorioDeOrganizacao {
    not some u: Usuario | some r: u.trabalha | r.organizacao != u.organizacao
}
// Verifica se todos os repositorios estao vinculados a uma organizacao
assert repositorioPossuiOrganizacao { 
	not some r: Repositorio | no r.organizacao 
}

assert acessosDentroDaOrganizacao {
    not some u: Usuario | some r: u.acessa | r.organizacao != u.organizacao
}

assert participacaoDentroDaOrganizacao {
    not some u: Usuario | some r: u.trabalha | r.organizacao != u.organizacao
}

assert sistemasCorretamenteIsolados {
    not some u: Usuario, r: u.acessa |
        r.organizacao.compoeUmSistema != u.perteceASistema
    
    not some u: Usuario, r: u.trabalha |
        r.organizacao.compoeUmSistema != u.perteceASistema
}

pred exemplo {
    #Usuario >= 3
    #Repositorio >= 5
    #Organizacao > 2
    #Sistema > 2
    some u: Usuario | no u.organizacao
}

run exemplo for 5
check verificaLimiteAcessoDev for 5
check acessosDentroDaOrganizacao for 5
check participacaoDentroDaOrganizacao for 5
check sistemasCorretamenteIsolados for 5
