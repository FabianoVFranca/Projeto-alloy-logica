module SistemaControleAcesso

sig Sistema {}

sig Organizacao {
    compoeUmSistema: one Sistema
}

sig Repositorio {
    organizacao: one Organizacao
}

sig Usuario {
    organizacao: lone Organizacao,
    acessa: set Repositorio,
    PerteceASistema: one Sistema,
    participa: set Repositorio 
}

fact controleAcesso {
    all u: Usuario | all r: u.acessa | r.organizacao = u.organizacao
    all u: Usuario | all r: u.participa | r.organizacao = u.organizacao
    
   
}

fact limiteDeParticipacao {
    all u: Usuario | #u.participa <= 5
}

fact isolamentoEntreSistemas {
    all u: Usuario | all r: u.acessa |
        r.organizacao.compoeUmSistema = u.PerteceASistema
    
    all u: Usuario | all r: u.participa |
        r.organizacao.compoeUmSistema = u.PerteceASistema
    
    all u: Usuario | some u.organizacao implies
        u.organizacao.compoeUmSistema = u.PerteceASistema
}

// ---- Asserts ----
assert verificaLimiteParticipacao {
    all u: Usuario | #u.participa <= 5
}

assert acessosDentroDaOrganizacao {
    not some u: Usuario | some r: u.acessa | r.organizacao != u.organizacao
}

assert participacaoDentroDaOrganizacao {
    not some u: Usuario | some r: u.participa | r.organizacao != u.organizacao
}

assert sistemasCorretamenteIsolados {
    not some u: Usuario, r: u.acessa |
        r.organizacao.compoeUmSistema != u.PerteceASistema
    
    not some u: Usuario, r: u.participa |
        r.organizacao.compoeUmSistema != u.PerteceASistema
}



pred exemplo {
    #Usuario >= 3
    #Repositorio >= 5
    #Organizacao > 2
    #Sistema > 2
    some u: Usuario | no u.organizacao
}

run exemplo for 5
check verificaLimiteParticipacao for 5
check acessosDentroDaOrganizacao for 5
check participacaoDentroDaOrganizacao for 5
check sistemasCorretamenteIsolados for 5

