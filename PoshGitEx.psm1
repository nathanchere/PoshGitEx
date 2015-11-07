#Requires -Version 2.0
#
# TODO:
# - option to check if last message is merge commit and replace with random message (for the 'no merge commit' police)
#

Function Git-Fix-Commit
{
	git commit --amend -m "$((New-Object System.Net.WebClient).DownloadString("http://whatthecommit.com/index.txt"))"
}

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
Export-ModuleMember -Function Git-*
