sdkmanager emulator

sdkmanager platform-tools

sudo apt -y install libpulse-dev

sudo apt-get update
sudo apt install qemu-kvm
sudo apt install virt-manager

echo 'KERNEL=="kvm", GROUP="kvm", MODE="0666", OPTIONS+="static_node=kvm"' | sudo tee /etc/udev/rules.d/99-kvm4all.rules
sudo udevadm control --reload-rules
sudo udevadm trigger --name-match=kvm

sudo adduser "$USER" kvm
sudo chown "$USER" /dev/kvm

echo "\n\n Installing system image"
sdkmanager --install 'system-images;android-30;google_apis_playstore;x86_64'

echo "\n\n Creating emulator"
echo "no" | avdmanager create avd -n TestAVD -k "system-images;android-30;google_apis_playstore;x86_64"

echo "\n\n Starting emulator and waiting for boot to complete...."
"$ANDROID_HOME"/emulator/emulator -avd TestAVD -no-skin -no-audio -no-window &
"$ANDROID_HOME"/platform-tools/adb wait-for-device 
echo "Emulator has finished booting"
adb devices

echo "\n\n Emulator boot status"
adb shell getprop sys.boot_completed

echo "\n\n Installing application"
./gradlew installDebug

echo "\n\n Launching app"
sleep 2
adb shell am start -n com.example.githubactionssampleproject3/com.example.githubactionssampleproject3.MainActivity
