# These two values are obligatory for UID/pwd access, optional for OAuth access
gdata_oerp_pump_uid: example@gmail.com
gdata_oerp_pump_pwd: aPassword

# Toggle the commenting below, in order to switch to OAuth access authentication. Optional.
gdata_oerp_pump_auth_type: OAuth

# These three values are obligatory for OAuth access, optional for UID/pwd access
gdata_oerp_pump_secret: secret
gdata_oerp_pump_proj_id: id
gdata_oerp_pump_refresh_token: refresh

# This value is optional but will make the tests start sooner if the token is less than 60 minutes old.
gdata_oerp_pump_access_token: access

# [Spreadsheet]

# Used by the test "open"
gdata_oerp_pump_ss_title: title

# Used by the test "test_open_by_url"
gdata_oerp_pump_ss_url: url

# Used by the test "test_open_by_key"
gdata_oerp_pump_ss_key: key 