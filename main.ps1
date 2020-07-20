$result = Test-NetConnection -ComputerName $computername -Port 22 -InformationLevel "Detailed"
$success = $result.TcpTestSucceeded
$lastResult = Get-Content "D:\root\lastResult.txt"
$slUrl = $slackURL
    

$Headers = @{
    channel = $slackChannel
    Authorization = $slackToken
    "Content-Type" = "application/json"
    }

$slReq = [ordered]@{
"channel" = $slackChannel
"blocks" = @(
)
}   

if ($success -notlike $lastResult){
    $addTitle =@{
    "type" = "section"
    "block_id" = "section0"
    "text" = @{
    type = "mrkdwn"
    text = "*FTP Status Change*"
        }
    }
    $slReq.blocks += $addTitle
    if($success -like "True"){
        $addToBlocks = @{
        "type" = "section"
        "block_id" = "section 1"
        "text" =@{
        type = "mrkdwn"
        text = ":heavy_check_mark: Service is *up*"
                }
            }
            $slReq.blocks += $addToBlocks
        } else {
        $addToBlocks = @{
        "type" = "section"
        "block_id" = "section 1"
        "text" =@{
        type = "mrkdwn"
        text = ":x: Service is *down*"
                }
            }
            $slReq.blocks += $addToBlocks
        }
        "$success" | Out-File -filepath "D:\root\lastResult.txt"
} else {
exit}
$JSON = $slReq | ConvertTo-Json -Depth 4
$slresult = Invoke-RestMethod -Method Post -Uri $SlUrl -Headers $Headers -Body $JSON