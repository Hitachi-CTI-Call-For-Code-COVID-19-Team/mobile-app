## COVSAFE mobile-app

<img src="img/1.png width="30%">
<img src="img/2.png width="30%">


## How to Install and Setup
- Open a workspace file and build it on Xcode
    - Before you build you shold modify BMSCredential.plist to fit your environment
    - Running this script, you can create BMSCredentials.plist
        ```
        $ ./utils/createBMSCredentials.sh
        ```
- Before you run the app, you shold register device-id to staff_asset db of  cloudant. Currently this mobile app only supports the device-id registration manually.

## License
- see [LICENSE](./LICENSE)