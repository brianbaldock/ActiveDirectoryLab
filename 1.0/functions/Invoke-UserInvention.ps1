
function Invoke-GPT4API {
    param (
        [string]$apiKey,
        [string]$prompt
    )

    $headers = @{
        'Content-Type' = 'application/json'
        'Authorization' = "Bearer $apiKey"
    }

    $body = @{
        prompt = $prompt
        max_tokens = 100
    } | ConvertTo-Json

    $response = Invoke-RestMethod -Uri 'https://api.openai.com/v1/engines/davinci-codex/completions' -Method 'POST' -Headers $headers -Body $body

    return $response.choices[0].text
}

# Usage example
$apiKey = 'YOUR_API_KEY'
$prompt = 'Generate a new "user" object based on parameters'

$result = Invoke-GPT4API -apiKey $apiKey -prompt $prompt
Write-Output $result
