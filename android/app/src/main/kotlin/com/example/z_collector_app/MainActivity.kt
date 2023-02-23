package com.example.research_buddy

import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity(), SensorEventListener {
    private val methodChannelName: String = "com.example.research_buddy/methodChannel"
    private val supportedSensors: List<Int> = listOf(
            // Motion sensors
            Sensor.TYPE_ACCELEROMETER, // [Gx, Gy, Gz] each in m/s-2
            Sensor.TYPE_LINEAR_ACCELERATION, // [Gx, Gy, Gz] each in m/s-2
            Sensor.TYPE_MAGNETIC_FIELD, // [Mx, My, Mz] each in µT
            Sensor.TYPE_GRAVITY, // [Gx, Gy, Gz] each in m/s-2
            Sensor.TYPE_GYROSCOPE, // [Px, Py, Pz] each in rad/s
            Sensor.TYPE_ROTATION_VECTOR, // [Px, Py, Pz, Pk, A] each in rad/s

            // Ambient sensors
            Sensor.TYPE_AMBIENT_TEMPERATURE, // [°C]
            Sensor.TYPE_LIGHT, // [Lux]
            Sensor.TYPE_PRESSURE, // [hPa]
            Sensor.TYPE_PROXIMITY, // [cm]
            Sensor.TYPE_RELATIVE_HUMIDITY, // [%]
    )

    private lateinit var methodChannel: MethodChannel
    private lateinit var mSensorManager: SensorManager

    // Motion sensors
    private var accelerometerValue: List<Float> = listOf(0f, 0f, 0f)
    private var linearAccelerationValue: List<Float> = listOf(0f, 0f, 0f)
    private var magneticFieldValue: List<Float> = listOf(0f, 0f, 0f)
    private var gravityValue: List<Float> = listOf(0f, 0f, 0f)
    private var gyroscopeValue: List<Float> = listOf(0f, 0f, 0f)
    private var rotationVectorValue: List<Float> = listOf(0f, 0f, 0f, 0f, 0f)

    // Ambient sensors
    private var ambientTemperatureValue: Float = 0f
    private var lightValue: Float = 0f
    private var pressureValue: Float = 0f
    private var proximityValue: Float = 0f
    private var relativeHumidityValue: Float = 0f

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        mSensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, methodChannelName)
        methodChannel.setMethodCallHandler { methodCall, result ->
            when (methodCall.method) {
                "getMotionSensorValues" -> {
                    result.success(mapOf(
                            "accelerometer" to accelerometerValue,
                            "linearAcceleration" to linearAccelerationValue,
                            "magneticField" to magneticFieldValue,
                            "gravity" to gravityValue,
                            "gyroscope" to gyroscopeValue,
                            "rotationVector" to rotationVectorValue
                    ))
                }
                "getAmbientSensorValues" -> {
                    result.success(mapOf(
                            "ambientTemperature" to ambientTemperatureValue,
                            "light" to lightValue,
                            "pressure" to pressureValue,
                            "proximity" to proximityValue,
                            "relativeHumidity" to relativeHumidityValue
                    ))
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    // --------------------- Sensor data fetch -----------------------------------------------------

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
    }

    override fun onSensorChanged(sensorEvent: SensorEvent?) {
        when (sensorEvent?.sensor?.type) {
            // Motion sensors
            Sensor.TYPE_ACCELEROMETER -> accelerometerValue = sensorEvent.values.toList()
            Sensor.TYPE_LINEAR_ACCELERATION -> linearAccelerationValue = sensorEvent.values.toList()
            Sensor.TYPE_MAGNETIC_FIELD -> magneticFieldValue = sensorEvent.values.toList()
            Sensor.TYPE_GRAVITY -> gravityValue = sensorEvent.values.toList()
            Sensor.TYPE_GYROSCOPE -> gyroscopeValue = sensorEvent.values.toList()
            Sensor.TYPE_ROTATION_VECTOR -> rotationVectorValue = sensorEvent.values.toList()
            // Ambient sensors
            Sensor.TYPE_AMBIENT_TEMPERATURE -> ambientTemperatureValue = sensorEvent.values[0]
            Sensor.TYPE_LIGHT -> lightValue = sensorEvent.values[0]
            Sensor.TYPE_PRESSURE -> pressureValue = sensorEvent.values[0]
            Sensor.TYPE_PROXIMITY -> proximityValue = sensorEvent.values[0]
            Sensor.TYPE_RELATIVE_HUMIDITY -> relativeHumidityValue = sensorEvent.values[0]
        }
    }

    // --------------------- Register/Unregister ---------------------------------------------------

    private fun registerSensors() {
        supportedSensors.forEach {
            val mSensor = mSensorManager.getDefaultSensor(it)
            mSensorManager.registerListener(this, mSensor, SensorManager.SENSOR_DELAY_NORMAL)
        }
    }

    private fun unregisterSensors() {
        mSensorManager.unregisterListener(this)
    }

    override fun onResume() {
        super.onResume()
        registerSensors()
    }

    override fun onPause() {
        super.onPause()
        unregisterSensors()
    }
}
