
# RastreiaSenhasParadas – Verificação de Inatividade na Troca de Senha no AD

**Aviso Legal:**  
Este script é fornecido para fins técnicos e educacionais. Utilize-o apenas em sistemas sob sua responsabilidade e com autorização. O uso indevido pode causar problemas de segurança e compliance.

## Descrição

O **RastreiaSenhasParadas** é um script em PowerShell que identifica usuários ATIVOS no Active Directory que não alteraram suas senhas há mais de X dias. Ele consulta o atributo `PasswordLastSet` e permite visualizar os resultados na tela ou exportá-los para um arquivo CSV em `C:\AD_Relatorios`.

## Funcionalidades

- Solicita ao usuário o período (em dias) para verificar a inatividade na troca de senha.
- Consulta o Active Directory para identificar contas ativas cujo `PasswordLastSet` é anterior à data de corte.
- Oferece duas opções:
  1. Exibir os resultados no PowerShell.
  2. Exportar os resultados para um arquivo CSV (o script cria a pasta `C:\AD_Relatorios` caso necessário).

## Requisitos

- Windows Server (ou ambiente com Active Directory) com o módulo **ActiveDirectory** instalado.
- Permissões de leitura no Active Directory.
- PowerShell 5.1 ou superior.
- O script deve ser executado com privilégios de Administrador.

## Como Usar

1. **Baixe** o arquivo `RastreiaSenhasParadas.ps1`.
2. **Abra** o PowerShell como Administrador.
3. (Opcional) Se o script foi baixado da Internet, desbloqueie-o:
   ```powershell
   Unblock-File -Path .\RastreiaSenhasParadas.ps1
   ```
4. **Execute** o script:
   ```powershell
   .\RastreiaSenhasParadas.ps1
   ```
5. **Informe** o número de dias de inatividade na troca de senha quando solicitado (exemplo: 90).
6. **Escolha** entre:
   - [1] Exibir os resultados no PowerShell.
   - [2] Exportar os resultados para CSV (o arquivo será salvo em `C:\AD_Relatorios\UsuariosSemTrocaSenha_[Xdias].csv`).

## Considerações

- O script utiliza o atributo `PasswordLastSet`, que reflete a última vez que a senha foi alterada.
- Execute o script periodicamente para auditorias e manutenção do ambiente.
- Teste em um ambiente controlado antes de aplicar em produção.

## Licença

Distribuído sob a licença [MIT](LICENSE).  
Você pode usar, modificar e redistribuir este script, desde que mantenha o aviso de licença.

---

**Criado por [rivaed](https://github.com/rivaed) – Ferramentas para manter o AD seguro e atualizado.**
