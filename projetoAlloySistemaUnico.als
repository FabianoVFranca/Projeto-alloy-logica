module projetoAlloySistemaUnico

sig Organizacao {}

sig Repositorio {
	// Repositorios sao sempre gerenciados dentro de uma unica organizacao
	organizacao: one Organizacao
}

sig Usuario {
	// Usuario pode pertencer a uma unica organizacao ou a nenhuma
	organizacao: lone Organizacao,
	// Subconjunto que indica os repositorios que o usuario acessa
	acessa: set Repositorio,
	//  Subconjunto que indica os repositorios que o usuario trabalha
        trabalha: set Repositorio  
}

// -- Fatos --- 

//  Esse fato controla a especificacao: "usuarios so podem acessar repositorios da mesma organizacao"
fact controleAcesso {
	all u: Usuario | all r: u.acessa | r.organizacao = u.organizacao     
	all u : Usuario | all r: u.trabalha | r.organizacao = u.organizacao
}

// Esse fato controla a especificacao: "desenvolverdor participa ativamente de no maximo cinco repositorios"
fact limiteDeRepositoriosDeTrabalho {
	all u: Usuario | devparticipaMaxCincoRepositorios[u]
}

// Se um usuario trabalha em um repositorio, ele obrigatoriamente tambem deve acessa-lo
fact usarioTrabalhaEAcessa {
	all u: Usuario | u.trabalha in u.acessa
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
// Verifica se todos Repositorios acessados pelo Usuario sao da sua Organizacao
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

pred exemplo {
    #Usuario >= 3         
    #Repositorio >= 5     
    #Organizacao >= 2      
    some u: Usuario | some u.trabalha // Pelo menos um usuário trabalha em algum repositório
}

run exemplo for 5
