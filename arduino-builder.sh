curr=`pwd`

# So, FQBN, PRJ_PATH, BUILD_PATH, SENSOR_TYPE(optional)
./arduino-builder \
  -compile \
  -hardware $curr/arduino/hardware \
  -hardware ~/.arduino15/packages \
  -tools $curr/arduino/hardware/tools \
  -tools $curr/arduino/tools-builder \
  -libraries $curr/lib \
  -prefs=build.extra_flags=-DSENSOR_TYPE=$4 \
  -fqbn $1 \
  -build-path $curr/$3 \
  $2   #Can be relative
