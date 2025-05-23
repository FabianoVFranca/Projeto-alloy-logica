module projetoAlloySistemasMultiplos

sig Sistema {}

// Cada organizacao pertence a um unico sistema.
sig Organizacao {
    compoeUmSistema: one Sistema
}

sig Repositorio {
	// Repositorios sao sempre gerenciados dentro de uma unica Organizacao
    	organizacao: one Organizacao
}

sig Usuario {
	// Usuario pode pertencer a uma unica Organizacao ou a nenhuma
    	organizacao: lone Organizacao,
	perteceASistema: one Sistema, // Usuario vinculado a um sistema
	// Subconjunto que indica os Repositorios que o Usuario acessa
   	acessa: set Repositorio,
	//  Subconjunto que indica os Repositorios que o Usuario trabalha
    	trabalha: set Repositorio 
}

// -- Fatos --- 

//  Esse fato controla a especificacao: "Usuarios so podem acessar Repositorios da mesma Organizacao"
fact controleAcesso {
    all u: Usuario | all r: u.acessa | r.organizacao = u.organizacao
    all u: Usuario | all r: u.trabalha | r.organizacao = u.organizacao
}

// Esse fato controla a especificacao: "Dev participa ativamente de no maximo cinco Repositorios"
fact limiteDeRepositoriosDeTrabalho {
	all u: Usuario | devparticipaMaxCincoRepositorios[u]
}

// Se um usuario trabalha em um Repositorio, ele obrigatoriamente tambem deve acessa-lo
fact usarioTrabalhaEAcessa {
	all u: Usuario | u.trabalha in u.acessa
}

// Garante que os usuarios e repositorios estejam corretamente isolados dentro dos sistemas.
// Isso evita que usuarios e repositorios migrem para sistemas diferentes.
fact isolamentoEntreSistemas {
    all u: Usuario | all r: u.acessa |
        r.organizacao.compoeUmSistema = u.perteceASistema
    
    all u: Usuario | all r: u.trabalha |
        r.organizacao.compoeUmSistema = u.perteceASistema
    
    all u: Usuario | some u.organizacao implies
        u.organizacao.compoeUmSistema = u.perteceASistema
}


// Predicado que verifica se um Dev esta dentro do limite de acesso a Repositorios
pred devparticipaMaxCincoRepositorios[u: Usuario] {
	 #u.trabalha <= 5
}


// ---- Asserts ----

// Verifica que todos os Devs respeitam o limite de participacao
assert verificaLimiteAcessoDev {
	all u: Usuario | devparticipaMaxCincoRepositorios[u]
}
//Verifica se nenhum Usuario acessa Repositorio de outra Organizacao
assert usuarioNaoAcessaRepositorioDeOutraOrganizacao {
	all u: Usuario | all r: u.acessa | r.organizacao = u.organizacao
}
// Verifica se todos os Usuarios trabalham apenas em Repositorios da sua Organização
assert usuarioTrabalhaApenasRepositorioDeOrganizacao {
    not some u: Usuario | some r: u.trabalha | r.organizacao != u.organizacao
}

// Verifica se todos os Repositorios estao vinculados a uma Organizacao
assert repositorioPossuiOrganizacao { 
	not some r: Repositorio | no r.organizacao 
}

// Verifica que todos os acessos respeitam a estrutura organizacional.
assert acessosDentroDaOrganizacao {
    not some u: Usuario | some r: u.acessa | r.organizacao != u.organizacao
}

// Verifica se os sistemas estao corretamente isolados,
// garantindo que usuários nao acessem ou trabalhem em repositorios de outro sistema.
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
check usuarioNaoAcessaRepositorioDeOutraOrganizacao for 5
check usuarioTrabalhaApenasRepositorioDeOrganizacao for 5
check repositorioPossuiOrganizacao for 5
check acessosDentroDaOrganizacao for 5
check sistemasCorretamenteIsolados for 5


