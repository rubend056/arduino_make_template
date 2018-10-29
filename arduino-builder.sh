curr=`pwd`

./arduino-builder \
  -compile \
  -hardware $curr/arduino/hardware \
  -tools $curr/arduino/hardware/tools \
  -tools $curr/arduino/tools-builder \
  -libraries $curr/$3 \
  -fqbn $1 \
  -build-path $curr/$4 \
  $2   #Can be relative
