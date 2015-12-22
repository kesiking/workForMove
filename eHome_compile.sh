
rm -rf ~/Desktop/eHome版本/eHome-`date +%Y%m%d`/

xcodebuild clean -configuration Distribution

xcodebuild archive -project eHome.xcodeproj -scheme eHome -destination generic/platform=iOS -archivePath ~/Desktop/eHome版本/eHome-`date +%Y%m%d`/eHome.xcarchive


xcodebuild -exportArchive -archivePath ~/Desktop/eHome版本/eHome-`date +%Y%m%d`/eHome.xcarchive -exportPath ~/Desktop/eHome版本/eHome-`date +%Y%m%d`/eHome.ipa -exportFormat ipa -exportProvisioningProfile eHomeProduct CODE_SIGN_IDENTITY="iPhone Distribution: China Mobile (Hangzhou) Information Technology Co., Ltd."

rm -rf build/