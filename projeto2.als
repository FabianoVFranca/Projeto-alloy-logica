module SistemaControleAcesso

sig Organizacao {}

sig Repositorio {
	// Repositorios sao sempre gerenciados dentro de uma unica organizacao
	organizacao: one Organizacao
}

sig Usuario {
	// Usuario pode pertencer a uma unica organizacao ou a nenhuma
	organizacao: lone Organizacao,
	// Relacao acessa: indica os repositorios que o usuario acessa
	acessa: set Repositorio
}

// Isso significa que Dev e um tipo especifico de Usuario
sig Dev extends Usuario {
    // Desenvolvedor participa de repositorios
    participa: set Repositorio  
}

// -- Fatos --- 

//  Esse fato controla a especificacao: "usuarios so podem acessar repositorios da mesma organizacao"
fact controleAcesso {
    all u: Usuario | all r: u.acessa | r.organizacao = u.organizacao     
    all d: Dev | all r: d.participa | r.organizacao = d.organizacao
}
// Esse fato controla a especificacao: "desenvolverdor participa ativamente de no maximo cinco repositorios"
fact limiteDeParticipacaoDev {
	all d: Dev | devparticipaMaxCincoRepositorios[d]
}


// ---- Predicados ----
// Predicado que verifica se um desenvolvedor esta dentro do limite de acesso a repositorios
pred devparticipaMaxCincoRepositorios[d:Dev] {
	 #d.participa <= 5
}

// ---- Asserts ----
// Verifica que todos os desenvolvedores respeitam o limite de participacao
assert verificaLimiteAcessoDev {
	all d: Dev | devparticipaMaxCincoRepositorios[d]
}
// Verifica se todos Repositorios acessados pelo Usuario sao da sua Organizacao
assert usuarioAcessaApenasRepositorioDeOrganizacao {
    not some u: Usuario | some r: u.acessa | r.organizacao != u.organizacao
}
// Verifica se todos os repositorios estao vinculados a uma organizacao
assert repositorioPossuiOrganizacao { 
	not some r: Repositorio | no r.organizacao 
}
// Verifica se todos Repositorios acessados pelo Dev sao da sua Organizacao
assert devAcessaApenasRepositorioDeOrganizacao {
    not some d: Dev | some r: d.acessa | r.organizacao != d.organizacao
}
// Verifica se todos Repositorios que o Dev participa sao da sua Organizacao
assert devParticipaApenasRepositorioDeOrganizacao {
    not some d: Dev | some r: d.participa | r.organizacao != d.organizacao
}

pred exemplo {
    #Usuario >= 3         
    #Dev >= 1           
    #(Usuario - Dev) >= 1  
    #Repositorio >= 5     
    #Organizacao >= 2      
    some d: Dev | some d.participa  // Algum Dev participa de pelo menos 1 repositorio
}

run exemplo for 5
check verificaLimiteAcessoDev for 5
check usuarioAcessaApenasRepositorioDeOrganizacao for 5
check repositorioPossuiOrganizacao for 5
check devAcessaApenasRepositorioDeOrganizacao for 5
check devParticipaApenasRepositorioDeOrganizacao for 5

