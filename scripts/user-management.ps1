# .SYNOPSIS
#   Basic user management automation that supports Active Directory or local accounts.

param(
    [ValidateSet('Add','Disable','ResetPassword')]
    [string]$Action,

    [Parameter(Mandatory=$true)]
    [string]$UserName,

    [string]$GivenName,
    [string]$Surname,
    [string]$OU,
    [switch]$UseAD,
    [string]$AuditLog = ".\user-management-audit.csv"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Audit {
    param(
        [string]$User,
        [string]$ActionTaken,
        [string]$Details = ''
    )
    $record = [PSCustomObject]@{
        Time = (Get-Date).ToString('u')
        User = $User
        Action = $ActionTaken
        Details = $Details
        Actor = $env:USERNAME
    }
    $exists = Test-Path -Path $AuditLog
    $record | Export-Csv -Path $AuditLog -Append -NoTypeInformation -Force
}

function Ensure-ADModule {
    if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
        throw "ActiveDirectory module is not available. Install RSAT/AD PowerShell modules."
    }
    Import-Module ActiveDirectory -ErrorAction Stop
}

function Generate-TempPassword {
    $length = 12
    $chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%&*()-_=+'
    -join ((1..$length) | ForEach-Object { $chars[(Get-Random -Minimum 0 -Maximum $chars.Length)] })
}

try {
    if ($UseAD) {
        Ensure-ADModule
    }

    switch ($Action) {
        'Add' {
            if ($UseAD) {
                if (-not $GivenName -or -not $Surname) { throw "GivenName and Surname are required for AD user creation." }
                $temp = Generate-TempPassword
                $securePass = ConvertTo-SecureString $temp -AsPlainText -Force
                $sam = $UserName
                $name = "$GivenName $Surname"
                $params = @{
                    Name = $name
                    SamAccountName = $sam
                    GivenName = $GivenName
                    Surname = $Surname
                    AccountPassword = $securePass
                    Enabled = $true
                }
                if ($OU) { $params['Path'] = $OU }
                Write-Output "Creating AD user $sam"
                New-ADUser @params -ErrorAction Stop
                Set-ADUser -Identity $sam -ChangePasswordAtLogon $true
                Write-Audit -User $sam -ActionTaken 'Add (AD)' -Details "TempPasswordProvided:True"
                Write-Output "Temporary password for $sam: $temp (showing here for demonstration; do not store plaintext passwords in production)"
            }
            else {
                if (-not (Get-Command -Name New-LocalUser -ErrorAction SilentlyContinue)) {
                    throw "New-LocalUser command is not available on this system."
                }
                $temp = Generate-TempPassword
                $secure = ConvertTo-SecureString $temp -AsPlainText -Force
                $displayName = if ($GivenName -or $Surname) { "$GivenName $Surname".Trim() } else { $UserName }
                New-LocalUser -Name $UserName -Password $secure -FullName $displayName -Description "Created by automation" -ErrorAction Stop
                Add-LocalGroupMember -Group 'Users' -Member $UserName -ErrorAction SilentlyContinue
                Write-Audit -User $UserName -ActionTaken 'Add (Local)' -Details "TempPasswordProvided:True"
                Write-Output "Temporary password for $UserName: $temp (showing here for demonstration; do not store plaintext passwords in production)"
            }
        }
        'Disable' {
            if ($UseAD) {
                Write-Output "Disabling AD account $UserName"
                Disable-ADAccount -Identity $UserName -ErrorAction Stop
                Write-Audit -User $UserName -ActionTaken 'Disable (AD)'
            }
            else {
                if (-not (Get-Command -Name Disable-LocalUser -ErrorAction SilentlyContinue)) {
                    throw "Disable-LocalUser command is not available on this system."
                }
                Write-Output "Disabling local account $UserName"
                Disable-LocalUser -Name $UserName -ErrorAction Stop
                Write-Audit -User $UserName -ActionTaken 'Disable (Local)'
            }
        }
        'ResetPassword' {
            $temp = Generate-TempPassword
            if ($UseAD) {
                $securePass = ConvertTo-SecureString $temp -AsPlainText -Force
                Set-ADAccountPassword -Identity $UserName -Reset -NewPassword $securePass -ErrorAction Stop
                Set-ADUser -Identity $UserName -ChangePasswordAtLogon $true
                Write-Audit -User $UserName -ActionTaken 'ResetPassword (AD)' -Details "TempPasswordProvided:True"
                Write-Output "Temporary password for $UserName: $temp"
            }
            else {
                $secure = ConvertTo-SecureString $temp -AsPlainText -Force
                try {
                    Set-LocalUser -Name $UserName -Password $secure -ErrorAction Stop
                    Write-Audit -User $UserName -ActionTaken 'ResetPassword (Local)'
                    Write-Output "Temporary password for $UserName: $temp"
                }
                catch {
                    throw "Failed to reset local password: $_"
                }
            }
        }
    }
}
catch {
    Write-Error "ERROR: $_"
    exit 1
}