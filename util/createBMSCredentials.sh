#!/bin/bash -eu

ic="ibmcloud"
PUSH_NOTIFICATIONS_INSTANCE_NAME="<MODIFY_HERE_TO_FIT_YOUR_ENVIRONMENT>"
PUSH_NOTIFICATIONS_INSTANCE_ID="<MODIFY_HERE_TO_FIT_YOUR_ENVIRONMENT>"
JSON_TEMPLATE=$(cat <<END
{
    pushApikey: .apikey,
    pushUrl: .url,
    pushIam_serviceid_crn: .iam_serviceid_crn,
    pushClientSecret: .clientSecret,
    pushAppGuid: .appGuid,
    pushPlan: .plan,
    pushIam_apikey_description: .iam_apikey_description,
    pushIam_role_crn: .iam_role_crn,
    pushIam_apikey_name: .iam_apikey_name,
}
END
)

json=$($ic resource service-key $PUSH_NOTIFICATIONS_INSTANCE_ID --output json | \
    jq ".[].credentials | $JSON_TEMPLATE| .+{ appName: \"$PUSH_NOTIFICATIONS_INSTANCE_NAME\" }")


apikey=$(echo $json | jq ".pushApikey")
url=$(echo $json | jq ".pushUrl")
iam_serviceid_crn=$(echo $json | jq ".pushIam_sericeid_crn")
clientSecret=$(echo $json | jq ".pushClientSecret")
appGuid=$(echo $json | jq ".pushAppGuid")
plan=$(echo $json | jq ".pushPlan")
iam_apikey_description=$(echo $json | jq ".pushIam_apikey_description")
iam_role_crn=$(echo $json | jq ".pushIam_role_crn")
iam_apikey_name=$(echo $json | jq ".pushIam_apikey_name")
appName=$PUSH_NOTIFICATIONS_INSTANCE_NAME

XML_TEMPLATE=$(cat <<END
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>pushApikey</key>
    <string>$apikey</string>
    <key>pushUrl</key>
    <string>$url</string>
    <key>pushIam_serviceid_crn</key>
    <string>$iam_serviceid_crn</string>
    <key>pushClientSecret</key>
    <string>$clientSecret</string>
    <key>pushAppGuid</key>
    <string>$appGuid</string>
    <key>pushPlan</key>
    <string>$plan</string>
    <key>pushIam_apikey_description</key>
    <string>$iam_apikey_description</string>
    <key>pushIam_role_crn</key>
    <string>$iam_role_crn</string>
    <key>pushIam_apikey_name</key>
    <string>$iam_apikey_name</string>
    <key>appName</key>
    <string>$appName</string>
</dict>
</plist>
END
)

echo $XML_TEMPLATE | xmllint --format - > BMSCredentials.plist
echo Successfully created BMSCredentials.plist
