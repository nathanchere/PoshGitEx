#Requires -Version 2.0

#Because git is retarded and often outputs normal result messages to stderr we have to do bullshit like this
Function Invoke-Git
{
    param([string] $command)
    
    $console_output_array = Invoke-Expression "& git $command 2>&1"
        
    $result = ""
    foreach($line in $console_output_array)
    {
        $val = ""
        if($line.GetType().Name -eq "ErrorRecord")
        {        
            $val = $line.Exception.Message
        }else{
            $val = $line
        }   
        $result = "$result`r`n$val"
    }

    return $result
}

Export-ModuleMember -Function Invoke-Git
