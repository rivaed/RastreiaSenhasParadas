<#
.SYNOPSIS
  Identifica usuários ATIVOS no Active Directory que não alteraram suas senhas há mais de X dias.

.DESCRIPTION
  O script consulta o atributo PasswordLastSet das contas ativas e permite exibir ou exportar um relatório dos usuários que não trocaram suas senhas no período especificado.
  Atenção: PasswordLastSet indica a última data em que a senha foi definida.

.NOTAS
  Autor: rivaed
  Compatível com: Windows Server 2016/2019/2022 com o módulo ActiveDirectory
  Requer: Permissões de leitura no AD
#>

# Configura o console para UTF-8
chcp 65001 > $null

# Verifica se o módulo ActiveDirectory está disponível e o importa
if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
    Write-Warning "O módulo ActiveDirectory não foi encontrado. Instale o RSAT ou o módulo apropriado."
    exit
}
Import-Module ActiveDirectory

# Solicita o número de dias de inatividade na troca de senha
$dias = Read-Host "Informe o número de dias de inatividade na troca de senha (ex: 90)"

if (-not [int]::TryParse($dias, [ref]$null) -or [int]$dias -le 0) {
    Write-Warning "Valor inválido. Insira um número inteiro maior que zero."
    exit
}

# Converte e armazena o valor como inteiro
$diasInt = [int]$dias
$dataLimite = (Get-Date).AddDays(-$diasInt)

Write-Host ""
Write-Host "Procurando usuários ATIVOS que não trocaram a senha há mais de $diasInt dias..."
Write-Host ""

# Busca usuários ativos com PasswordLastSet inferior à data limite
try {
    $usuariosSemTrocaSenha = Get-ADUser -Filter {Enabled -eq $true -and PasswordLastSet -lt $dataLimite} -Properties PasswordLastSet |
        Select-Object Name, SamAccountName, Enabled, PasswordLastSet
} catch {
    Write-Warning "Erro ao consultar o Active Directory: $_"
    exit
}

if ($usuariosSemTrocaSenha.Count -eq 0) {
    Write-Host "Nenhum usuário ativo encontrado que não tenha trocado a senha há mais de $diasInt dias."
    exit
}

# Menu de ação
Write-Host "Total encontrado: $($usuariosSemTrocaSenha.Count) usuários."
Write-Host ""
Write-Host "O que você deseja fazer?"
Write-Host "[1] Exibir os resultados no PowerShell"
Write-Host "[2] Exportar os resultados para CSV (em C:\AD_Relatorios)"
$escolha = Read-Host "Digite 1 ou 2"

switch ($escolha) {
    "1" {
        Write-Host ""
        $usuariosSemTrocaSenha | Format-Table Name, SamAccountName, PasswordLastSet -AutoSize
        Read-Host "Pressione Enter para sair"
    }
    "2" {
        $pastaRelatorio = "C:\AD_Relatorios"
        if (-not (Test-Path -Path $pastaRelatorio)) {
            New-Item -Path $pastaRelatorio -ItemType Directory | Out-Null
        }
        $nomeArquivo = "UsuariosSemTrocaSenha_${diasInt}dias.csv"
        $caminhoArquivo = Join-Path -Path $pastaRelatorio -ChildPath $nomeArquivo

        try {
            $usuariosSemTrocaSenha | Export-Csv -Path $caminhoArquivo -NoTypeInformation -Encoding UTF8
            Write-Host ""
            Write-Host "Arquivo exportado com sucesso:"
            Write-Host $caminhoArquivo
        } catch {
            Write-Warning "Erro ao exportar o arquivo: $_"
        }
        Read-Host "Pressione Enter para sair"
    }
    default {
        Write-Warning "Opção inválida. Nenhuma ação realizada."
        Read-Host "Pressione Enter para sair"
    }
}

Write-Host ""
Write-Host "Execução concluída."
