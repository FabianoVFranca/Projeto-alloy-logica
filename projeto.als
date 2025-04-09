module SistemaControleAcesso

sig Organizacao {}

sig Repositorio {
    organizacao: one Organizacao
}

sig Usuario {
    organizacao: one Organizacao,
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

fact devAcessaApenasOndeParticipa {
    all d: Dev | d.acessa in d.participa
}




run {
    #Usuario >= 3       
    #Dev >= 1           
    #(Usuario - Dev) >= 1  
    #Repositorio >= 5
    #Organizacao > 1
    some participa      
} for 10 but 5 Organizacao
