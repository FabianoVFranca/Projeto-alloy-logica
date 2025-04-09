module SistemaControleAcesso

sig Organizacao {}

// Definicao de um repositorio que pertence a uma unica organizacao
sig Repositorio {
	// o atributo (organizacao) faz uma associacao a uma organizacao
	organizacao: one Organizacao
}

// Definicao de um  usuario que pertence a uma unica organizacao ou a nenhuma
sig Usuario {
	organizacao: lone Organizacao,
	// relacao acessa: indica os repositorios que o usuario acessa
	acessa: set Repositorio
}

sig Dev extends Usuario {
    participa: set Repositorio  
}

// -- Fatos --- 
//  Esse fato controla a especificacao: "usuarios so podem acessar repositorios da mesma organizacao"
fact controleAcesso {
	all u: Usuario | all r: repositoriosAcessa[u] | r.organizacao = u.organizacao
}
// Esse fato controla a especificacao: "desenvolvedor participa ativamente de no maximo cinco repositorios"
fact limiteDeParticipacaoDev {
	all d: Dev | participaMaxCincoRepositorios[d]
}
// Esse fato controla a participacao de desenvolvedor para apenas repositorios que ele acessa
fact devAcessaApenasOndeParticipa {
    all d: Dev | participa[d] in acessa[d]
}

// ---- Predicados ----
// Predicado que verifica se um desenvolvedor esta dentro do limite de acesso a repositorios
pred participaMaxCincoRepositorios[d:Dev] {
	#repositoriosAcessa[d] <=5
}

// ---- Funcoes ----
// Funcao que retorna os repositorios acessiveis por um usuario
fun repositoriosAcessa[u:Usuario]: set Repositorio {
	u.acessa
}
// Funcao que retorna os repositorios  que um dev participa 
fun repositoriosParticipa[d:Dev]: set Repositorio {
	d.participa
}


// ---- Asserts ----
// Verifica se todos os desenvolvedores respeitam o limite de repositorios
assert verificaLimiteAcessoUsuario {
	all u: Usuario | participaMaxCincoRepositorios[u]
}
// Verifica se todos Repositorios acessados pelo Usuario sao da sua Organizacao
assert usuarioAcessaApenasRepositorioDeOrganizacao {
    not some u: Usuario | some r: u.repositoriosAcessa | r.organizacao != u.organizacao
}
// Verifica se todos os repositorios estao vinculados a uma organizacao
assert repositorioPossuiOrganizacao { 
	not some r: Repositorio | no r.organizacao 
}
// Verifica se todos Repositorios acessados pelo Dev sao da sua Organizacao
assert devAcessaApenasRepositorioDeOrganizacao {
    not some d: Dev | some r: d.repositoriosAcessa | r.organizacao != d.organizacao
}
// Verifica se todos Repositorios que o Dev participa sao da sua Organizacao
assert devParticipaApenasRepositorioDeOrganizacao {
    not some d: Dev | some r: d.repositoriosParticipa | r.organizacao != d.organizacao
}
// Verifica se todos Repositorios que o Dev acessa todos Repositorios que participa
assert devParticipaApenasRepositorioQueAcessa {
    not some d: Dev | some r: d.repositoriosParticipa | r not in d.repositoriosAcessa
}

// ---- Cenarios de Execucao ----
run {
    #Usuario >= 2
    #Repositorio >= 5
    #Organizacao > 1
} for 10 but 5 Organizacao
