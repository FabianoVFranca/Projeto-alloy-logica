module projeto
//tive que colocar relaçao binaria por conta do problema do pais e filho do exemplo

sig Usuario {
    organizacao: one Organizacao,
    repositoriosUsuario: set Repositorio
}

sig Organizacao {
    usuarios: set Usuario,
    repositorios: set Repositorio
}

sig Repositorio {
    organizacao: one Organizacao
}

//tem que ser circular pai pra filho filho pra pai
//talvez deixar isso em predicado seja mehlor
//talvez circular para usuario e repositorio tb
//so tenho uma organizacao?
// meu sistema quebra se tiver mais que uma organizacao
fact {
    //todo repositorio tem apenas uma organizacao
    all r: Repositorio | one o: Organizacao | r in o.repositorios
    //todo usuario e em uma unica organizacao a organizacao do usuario esta na  

    all u: Usuario | one o: Organizacao | u in o.usuarios
    
    all u: Usuario, r: u.repositoriosUsuario | r.organizacao = u.organizacao
    //numero max de ace
    all u: Usuario | #u.repositoriosUsuario <= 5
    //para toda organizacao a gente tem que garantir que a unica organizacao daqueles repositorios dele é ele mesmo
    all o:Organizacao ,r : Repositorio|r.organizacao = o
    all o:Organizacao,u:Usuario|u.organizacao=o
}

run{
    #Usuario >= 2
    #Repositorio >= 5
} for 10 but 5 Organizacao
