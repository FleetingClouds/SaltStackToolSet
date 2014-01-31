refresh_token = {{ pillar['gdata_oerp_pump_refresh_token'] }}
client_secret = {{ pillar['gdata_oerp_pump_secret'] }}
client_id = {{ pillar['gdata_oerp_pump_proj_id'] }}
#
key_ring = {}
key_ring['grant_type'] = 'refresh_token'
key_ring['refresh_token'] = refresh_token
key_ring['client_secret'] = client_secret
key_ring['client_id'] = client_id
#
access_token = {{ pillar['gdata_oerp_pump_access_token'] }}
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
