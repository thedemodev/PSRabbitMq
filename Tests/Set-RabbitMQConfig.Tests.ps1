﻿$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here\TestSetup.ps1"
. "$here\..\PSRabbitMQ\$sut"

Describe "Set-RabbitMqConfig" {

    context "Setting current RabbitMQ Configuration" {
        It "sets the current Configuration"{
            $Script:RabbitMqConfig = [pscustomobject]@{
                ComputerName = $null
            }
            $computerName = "rabbitmq.contoso.com"
            Set-RabbitMqConfig -ComputerName $computerName
            $Script:RabbitMqConfig.ComputerName | Should be $computerName
        }        
    }

    context "Persisting the RabbitMQ Configuration"{

        It "persists the current Configuration"{
            Mock Export-CliXml {}
            Set-RabbitMqConfig -Persist
            Assert-MockCalled -CommandName Export-CliXml -Times 1
        }

        It "handles an UnauthorizedAccessException"{
            Mock Export-Clixml {throw [System.UnauthorizedAccessException]}
            {Set-RabbitMqConfig -Persist -WarningAction SilentlyContinue} | Should Not Throw            
        }
    }
}