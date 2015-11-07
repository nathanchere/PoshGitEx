#Requires -Version 2.0

Function HasError($result)
{
	if($result -match "^usage: .*")
	{
		return @{
			"Error" = "Incorrect git usage";
			"Detail" = $result;
		}		
	}
	
	if($result -match "^error: (.*)$")
	{
		return @{
			"Error" = $matches[1];
			"Detail" = $result;
		}		
	}
	
	if($result -match "^fatal: (.*)$")
	{
		return @{
			"Error" = $matches[1];
			"Detail" = $result;
		}		
	}
	
	return $false;
}

#####
##### Standard git methods
#####

Function Git-Branch
{
	$result = Invoke-Git("branch $args")
	$error = HasError($result)
	if($error){
		return $error;		
	}
	
	return $result;
}

Function Git-Checkout
{
	### EXPECTED RESPONSES: 
	#Already on 'somebranch'
	#Switched to branch 'somebranch'
	#Switched to a new branch 'somebranch'
	#error: pathspec 'somebranch' did not match any file(s) known to git.
	#fatal: A branch named 'somebranch' already exists.	
	
	$result = Invoke-Git("checkout $args")
	$error = HasError($result)
	if($error){
		return $error;		
	}
	
	return $result;
}

Function Git-Rebase
{
	$result = Invoke-Git("rebase $args")
	$error = HasError($result)
	if($error){
		return $error;		
	}
	
	return $result;
}

Function Git-Merge
{
	$result = Invoke-Git("merge $args")
	$error = HasError($result)
	if($error){
		return $error;		
	}
	
	return $result;
}

Function Git-Pull
{
	$result = Invoke-Git("pull $args")
	$error = HasError($result)
	if($error){
		return $error;		
	}
	
	return $result;
}

Function Git-Push
{
	$result = Invoke-Git("push $args")
	$error = HasError($result)
	if($error){
		return $error;		
	}
	
	return $result;
}

Function Git-Diff
{
	$result = Invoke-Git("diff $args")
	$error = HasError($result)
	if($error){
		return $error;		
	}
	
	return $result;
}

Function Git-Reset
{
	$result = Invoke-Git("reset $args")
	$error = HasError($result)
	if($error){
		return $error;		
	}
	
	return $result;
}

Function Git-Fetch
{
	$result = Invoke-Git("fetch $args")
	$error = HasError($result)
	if($error){
		return $error;		
	}
	
	return $result;
}

Function Git-Remote
{
	$result = Invoke-Git("remote $args")
	$error = HasError($result)
	if($error){
		return $error;		
	}
	
	return $result;
}

Function Git-Status
{
	Write-Error "Not done"
	Exit
}

Function Git-Add
{
	$result = Invoke-Git("add $args")
	$error = HasError($result)
	if($error){
		return $error;		
	}
	
	return $result;
}

Function Git-Commit
{
	$result = Invoke-Git("commit $args")
	$error = HasError($result)
	if($error){
		return $error;		
	}
	
	return $result;
}

Function Git-Log
{
	$result = Invoke-Git("log $args")
	$error = HasError($result)
	if($error){
		return $error;		
	}
	
	return $result;
}

Function Git-Tag
{
	$result = Invoke-Git("tag $args")
	$error = HasError($result)
	if($error){
		return $error;		
	}
	
	return $result;
}

Function Git-Clone
{
	$result = Invoke-Git("clone $args")
	$error = HasError($result)
	if($error){
		return $error;		
	}
	
	return $result;
}

Function Git-Init
{
	$result = Invoke-Git("init $args")
	$error = HasError($result)
	if($error){
		return $error;		
	}
	
	return $result;
}

#####
##### Extra helper methods
#####

Function Git-GetBranch
{
    $currentBranch = ''
    git branch | foreach {
        if ($_ -match "^\* (.*)") {
            $currentBranch += $matches[1]
        }
    }
    return $currentBranch
}

Function Git-FixCommit
{	
	#TODO: check if last was merge commit
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

    return $result.Trim()
}

Export-ModuleMember -Function Invoke-Git
Export-ModuleMember -Function Git-*
