extends CanvasLayer

func _ready():
	$HTTPRequest.request("http://icanhazip.com/")

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var ip = body.get_string_from_utf8()
	$IpText.text = ip

