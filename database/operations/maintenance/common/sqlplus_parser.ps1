Set-StrictMode -Version Latest

function ConvertFrom-SqlPlusDelimitedOutput
{
    param(
        [Parameter(Mandatory)]
        [string[]]$Lines,

        [Parameter(Mandatory)]
        [string[]]$Columns,

        [string]$Delimiter = "|"
    )

    $Rows = [System.Collections.Generic.List[object]]::new()
    foreach ($Line in $Lines)
    {
        $Text = $Line.Trim()
        if ([string]::IsNullOrWhiteSpace($Text) -or $Text -match '^(Connected to:|Disconnected from|SQL>)')
        {
            continue
        }

        $Values = $Text.Split($Delimiter)
        if ($Values.Count -ne $Columns.Count)
        {
            continue
        }

        $Row = [ordered]@{}
        for ($Index = 0; $Index -lt $Columns.Count; $Index++)
        {
            $Row[$Columns[$Index]] = $Values[$Index].Trim()
        }
        $Rows.Add([pscustomobject]$Row)
    }

    return @($Rows)
}
