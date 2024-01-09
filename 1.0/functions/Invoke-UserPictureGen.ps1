
function Invoke-UserPictureGen {
    param (
        [Parameter(Mandatory = $true)]
        [string]$UserName,
        
        [Parameter(Mandatory = $true)]
        [string]$Prompt
    )

    # Set up the API request
    $apiKey = "YOUR_API_KEY"
    $apiUrl = "https://api.openai.com/v1/engines/davinci-codex/completions"
    $headers = @{
        "Authorization" = "Bearer $apiKey"
        "Content-Type" = "application/json"
    }
    $body = @{
        "prompt" = $Prompt
        "max_tokens" = 100
    } | ConvertTo-Json

    # Send the API request
    $response = Invoke-RestMethod -Uri $apiUrl -Method Post -Headers $headers -Body $body

    # Process the response
    $portrait = $response.choices[0].text

    # Display the generated portrait
    Write-Host "Generated portrait for user $($UserName):"
    Write-Host $portrait
}

# Usage example
Invoke-UserPictureGen -UserName "John Doe" -Prompt "Generate a portrait of a user with brown hair and blue eyes."
