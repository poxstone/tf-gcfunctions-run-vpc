import functions_framework
import requests

@functions_framework.http
def test_http(request):
    request_json = request.get_json(silent=True)
    request_args = request.args

    if request_json and 'url' in request_json:
        url = request_json['url']
    elif request_args and 'url' in request_args:
        url = request_args['url']
    else:
        url = 'https://ipinfo.io'

    method = 'GET'
    if request_json and 'method' in request_json:
        method = request_json['method'].upper()
    elif request_args and 'method' in request_args:
        method = request_args['method'].upper()

    try:
        response = requests.request(method, url)
        return response.text, response.status_code
    except requests.exceptions.RequestException as e:
        return f'Error making request: {str(e)}', 500

# curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" https://gcf-test-network-01-28443687020.us-central1.run.app?url=http://10.20.136.2&method=GET
