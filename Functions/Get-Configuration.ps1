function Get-Configuration {
<#
.SYNOPSIS
Obtiene la información de los datos de configuración del módulo.

.DESCRIPTION
Obtiene la información de los datos de configuración del módulo a partir de los datos en el archivo <%=$PLASTER_PARAM_ModuleName%>.config

.INPUTS
None

.EXAMPLE
Get-Configuration
Obtiene la información de configuración del módulo.

.EXAMPLE
Get-Configuration | Get-Member -MemberType Properties
Obtiene los nombres de las propiedades incluidas en el objeto de retorno.

.LINK
[Set-Configuration](Set-Configuration.md)

.LINK
[Test-Configuration](Test-Configuration.md)

.NOTES
Autor: <%=$PLASTER_PARAM_ModuleAuthor%> 
#>    
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param()
    
    try {

        if ($Script:ConfigurationCache) {
            'Get-Configuration From Cache' | Write-Verbose
            $Script:ConfigurationCache | Write-Output
            return
        }
    
        $ConnectionStrings = Get-ConnectionStringSection -Path $Script:AppConfig
        $AppSettings = Get-AppSettingSection -Path $Script:AppConfig

        # Agregue a continuación los valores de configuración del módulo.
        # Los valores que se muestran a continuación son de carácter demostrativo. Quítelos al finalizar
        $Script:ConfigurationCache = [PSCustomObject] @{
			PSTypeName                 = 'Processa.Management.Automation.<%=$PLASTER_PARAM_ModuleName%>.Configuration'
            MySqlDummyConnectionString = $ConnectionStrings['Sql:Local']
			Configured                 = [bool]($AppSettings['configured'] -match 'true|t|1|yes')
            SqlDummyStatement          = Get-Content -Path "$Script:SQLScriptPath\Get-Dummy.sql" -Raw
			AppConfig                  = $Script:AppConfig
        }

        $Script:ConfigurationCache | Write-Output
    }
    catch {
        throw
    }
}
