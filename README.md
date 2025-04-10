# Projeto Alloy — Lógica para Computação

Este projeto modela, utilizando Alloy, um sistema simples de controle de acesso a repositórios de código em uma plataforma colaborativa, com foco na consistência das regras de organização e permissões de usuários.

## 🧩 Principais Especificações do Sistema

- Cada repositório pertence **exclusivamente** a uma organização.
- Cada usuário pode pertencer a **uma única organização** ou a **nenhuma**.
- Os usuários têm acesso **apenas aos repositórios** de sua própria organização.
- Desenvolvedores (`Usuários que trabalham`) podem participar de **no máximo cinco repositórios** dentro de sua organização.
- Quando um desenvolvedor trabalha em um repositório ele também **acessa** esse repositório.

## 📌 Expansão para Múltiplos Sistemas
- O modelo Alloy do projeto2 representa um sistema único de controle de acesso a repositórios dentro de uma plataforma colaborativa, como GitHub ou GitLab.
- Ele garante que cada usuário e repositório estejam vinculados a uma única organização, respeitando as regras de isolamento e acesso interno, especificadas acima.
- **No entanto**, o modelo pode ser facilmente expandido para um contexto onde múltiplos sistemas coexistam independentemente, representado por projeto3.
- Essa ideia surgiu ao longo das reuniões do grupo para executar o projeto, e decidimos desenvolver também esse cenário com múltiplos sistemas.

## 👥 Integrantes do Grupo

- Ana Lívia Costa Celestino Santos  
- Anna Lívia dos Santos Macêdo Costa  
- Fabiano Victor de França Araújo  
- Lucas André Monteiro Sousa
- Mirelle Maria de Oliveira Rocha

## 📘 Componente Curricular

**Disciplina:** Lógica para Computação  
**Período:** 2024.2  
**Professor:** Tiago Lima Massoni
