refresh_token = "{{ pillar['refresh_token'] }}"
client_secret = "{{ pillar['client_secret'] }}"
client_id = "{{ pillar['client_id'] }}"
#
key_ring = {}
key_ring['grant_type'] = 'refresh_token'
key_ring['refresh_token'] = refresh_token
key_ring['client_secret'] = client_secret
key_ring['client_id'] = client_id
#
access_token = "{{ pillar['access_token'] }}"
#
#
credentials = {
      'cred_type': 'oauth'
    , 'key_ring': key_ring
    , 'access_token': access_token
}
#
smtp_access_token = ''
smtp_refresh_token = ''
#
