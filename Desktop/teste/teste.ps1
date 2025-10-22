# -------------------------
# Stubs mínimos para rodar
# -------------------------
# Define o caminho do arquivo de log
$logFile = "$env:TEMP\scan-status.log"

function Write-Log {
    param ([string]$message, [string]$level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$level] $message"
    Add-Content -Path $logFile -Value $logMessage
}

function Invoke-WebRequestSafe {
    param ([string]$Uri, [string]$Method = 'Get', [int]$Timeout = 30)
    
    # Aqui estamos definindo um cabeçalho básico, caso precise
    $headers = @{
        "User-Agent" = "PowerShell-Script"
    }
    
    return Invoke-WebRequest -Uri $Uri -Method $Method -Headers $headers -ErrorAction Stop -TimeoutSec $Timeout
}

function Handle-WebError {
    param ($ErrorObject)
    if ($ErrorObject.Exception.Response.StatusCode.value__) {
        $statusCode = $ErrorObject.Exception.Response.StatusCode.value__
        Write-Host "`nErro HTTP: $statusCode" -ForegroundColor Red
        Write-Log "Erro HTTP: $statusCode" "ERROR"
    } else {
        Write-Host "`nErro: $($ErrorObject.Exception.Message)" -ForegroundColor Red
        Write-Log "Erro: $($ErrorObject.Exception.Message)" "ERROR"
    }
}

# -------------------------
# Função Get-IpAddress
# -------------------------
function Get-IpAddress {
    param (
        [string]$domain
    )

    try {
        Write-Host "`nObtaining IP address for: $domain..." -ForegroundColor Yellow
        Write-Log "Starting Get-IpAddress for: $domain"

        # Resolvendo o IP do domínio
        $r = Resolve-DnsName -Name $domain -Type A
        if ($r) {
            Write-Host "`nIP Address(es):" -ForegroundColor Cyan
            $r.IpAddress
            Write-Log "Resolved IPs: $($r.IpAddress -join ', ')"
        } else {
            Write-Host "`nNo IP found for $domain" -ForegroundColor Red
            Write-Log "No IP found for $domain" "ERROR"
        }
    } catch {
        Write-Host "`nError while resolving IP: $($_.Exception.Message)" -ForegroundColor Red
        Write-Log "Error: $($_.Exception.Message)" "ERROR"
    }
}

# -------------------------
# Chamada correta da função Get-IpAddress
# -------------------------
Get-IpAddress -domain 'scanme.nmap.org'
