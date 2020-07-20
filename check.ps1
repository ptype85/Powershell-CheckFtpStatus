$result = Test-NetConnection -ComputerName "82.30.106.154" -Port 22 -InformationLevel "Detailed"
$success = $result.TcpTestSucceeded
$lastResult = Get-Content "D:\pandm-up-test\lastResult.txt"
$slUrl = "https://hooks.slack.com/services/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"
    

$Headers = @{
    channel = "C017JF6LDK6"
    Authorization = "Bearer xoxb-1274171482496-1262958110897-f9bRBYzGngfZWhtmlNZWiiNb"
    "Content-Type" = "application/json"
    }

$slReq = [ordered]@{
"channel" = "G0B1UBZN2"
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
        "$success" | Out-File -filepath "D:\pandm-up-test\lastResult.txt"
} else {
exit}
$JSON = $slReq | ConvertTo-Json -Depth 4
$slresult = Invoke-RestMethod -Method Post -Uri $SlUrl -Headers $Headers -Body $JSON