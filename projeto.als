module SistemaControleAcesso

sig Organizacao {}

sig Repositorio {
    organizacao: one Organizacao
}

sig Usuario {
    organizacao: lone Organizacao,
    acessa: set Repositorio 
}

sig Dev extends Usuario {
    participa: set Repositorio  
}


fact controleAcesso {
    all u: Usuario | all r: u.acessa | 
        r.organizacao = u.organizacao
        
    all d: Dev | all r: d.participa |
        r.organizacao = d.organizacao
}

fact limiteParticipacaoDev {
    all d: Dev | #d.participa <= 5
}


run {
    #Usuario >= 3         
    #Dev >= 1           
    #(Usuario - Dev) >= 1  
    #Repositorio >= 5     
    #Organizacao >= 2      
    some d: Dev | some d.participa  // Algum Dev participa de pelo menos 1 repositorio
} for 5 but 5 Organizacao

