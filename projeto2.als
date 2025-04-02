// esse codigo modela um sistema de controle de acesso a repositorios 
// em uma plataforma colaborativa

module SistemaControleAcesso

// Definicao de uma organizacao
sig Organizacao{}


// Definicao de um repositorio que pertence a uma unica organizacao
sig Repositorio{
	// o atributo (organizacao) indica a que organizacao o repositorio pertence
	organizacao: one Organizacao
}

// Definicao de um  usuario que pertence a uma unica organizacao 
sig Usuario{
	organizacao: one Organizacao,
	// relacao - acessa - indica os repositorios que o usuario pode acessar
	acessa: set Repositorio
}
-- Fatos --- 
//  esse fato controla a especificacao: usuarios so podem acessar repositorios da mesma organizacao
fact controleAcessoUsuario{
	all u: Usuario | all r: repositoriosUsuarioAcessa[u] | r.organizacao = u.organizacao
}

// esse fato controla a especificacao: desenvolverdor participa ativamente de no maximo cinco repositorios
fact limiteDeAcessoUsuario{
	all u: Usuario |  participaMaxCincoRepositorios[u]
}

// Predicado que verifica se um usuario esta dentro do limite de acesso a repositorios
pred participaMaxCincoRepositorios[u:Usuario]{
	#repositoriosUsuarioAcessa[u] <=5
}

// Funcaoo que retorna os repositorios acessiveis por um usuario
fun repositoriosUsuarioAcessa[u:Usuario]: set Repositorio{
	u.acessa
}


assert VerificaLimiteAcessoUsuario{
	all u: Usuario | participaMaxCincoRepositorios[u]
}


run{
    #Usuario >= 2
    #Repositorio >= 5
    #Organizacao > 1
} for 10 but 5 Organizacao
