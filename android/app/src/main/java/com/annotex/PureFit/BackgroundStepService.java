package com.annotex.PureFit;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Build;
import android.os.IBinder;
import android.util.Log;

import androidx.core.app.NotificationCompat;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class BackgroundStepService extends Service implements SensorEventListener {
    private static final String CHANNEL_ID = "step_tracking_channel";
    private static final int NOTIFICATION_ID = 1001;
    private static final String TAG = "BackgroundStepService";
    
    private SensorManager sensorManager;
    private Sensor stepCounterSensor;
    private int initialSteps = 0;
    private int currentSteps = 0;
    private int dailyGoal = 1000; // Default goal
    private boolean isFirstLaunch = true;
    private SharedPreferences prefs;
    private String lastResetDate = "";
    private boolean goalAchievedToday = false;
    private long lastDateCheckTime = 0; // Cache to avoid checking date on every sensor event

    @Override
    public void onCreate() {
        super.onCreate();
        Log.d(TAG, "BackgroundStepService created");
        
        // Initialize sensor manager
        sensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
        stepCounterSensor = sensorManager.getDefaultSensor(Sensor.TYPE_STEP_COUNTER);
        
        // Initialize SharedPreferences
        prefs = getSharedPreferences("step_tracking", Context.MODE_PRIVATE);
        
        // Load saved data
        loadSavedData();
        
        // Create notification channel
        createNotificationChannel();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.d(TAG, "BackgroundStepService started");
        
        // FIRST: Check if it's a new day and reset if needed (before loading data)
        checkAndResetForNewDay();
        
        // THEN: Reload data including goal updates
        loadSavedData();
        
        // Start foreground service
        startForeground(NOTIFICATION_ID, createNotification());
        
        // Register step counter sensor
        if (stepCounterSensor != null) {
            sensorManager.registerListener(this, stepCounterSensor, SensorManager.SENSOR_DELAY_NORMAL);
            Log.d(TAG, "Step counter sensor registered");
        } else {
            Log.e(TAG, "Step counter sensor not available");
        }
        
        // Return START_STICKY to restart service if killed
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        Log.d(TAG, "BackgroundStepService destroyed");
        
        if (sensorManager != null) {
            sensorManager.unregisterListener(this);
        }
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        if (event.sensor.getType() == Sensor.TYPE_STEP_COUNTER) {
            // CRITICAL: Check for new day on EVERY sensor event (handles midnight crossover)
            checkAndResetForNewDay();
            
            int totalSteps = (int) event.values[0];
            
            if (isFirstLaunch) {
                initialSteps = totalSteps;
                currentSteps = 0;
                isFirstLaunch = false;
                Log.d(TAG, "First launch - Initial steps: " + initialSteps);
                
                // Save to SharedPreferences IMMEDIATELY
                saveStepData();
                
                // Update notification immediately
                updateNotification();
            } else {
                currentSteps = totalSteps - initialSteps;
                if (currentSteps < 0) currentSteps = 0;
                
                Log.d(TAG, "Steps today: " + currentSteps);
                
                // Save to SharedPreferences IMMEDIATELY (every step)
                saveStepData();
                
                // Reload goal from SharedPreferences to check for updates
                int latestGoal = prefs.getInt("stepGoal", dailyGoal);
                if (latestGoal != dailyGoal) {
                    dailyGoal = latestGoal;
                    Log.d(TAG, "Goal updated in background service: " + dailyGoal);
                }
                
                // Update notification (every step for real-time updates)
                updateNotification();
                
                // Check for goal achievement
                checkGoalAchievement();
            }
        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
        // Not needed for step counter
    }

    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(
                CHANNEL_ID,
                "Step Tracking",
                NotificationManager.IMPORTANCE_LOW
            );
            channel.setDescription("Tracks your daily steps in the background");
            channel.setShowBadge(false);
            channel.setSound(null, null);
            channel.enableVibration(false);
            
            NotificationManager manager = getSystemService(NotificationManager.class);
            manager.createNotificationChannel(channel);
        }
    }

    private Notification createNotification() {
        Intent notificationIntent = new Intent(this, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(
            this, 0, notificationIntent, 
            PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE
        );

        // Calculate progress percentage using actual goal
        // Avoid division by zero if dailyGoal is 0
        int progress = (dailyGoal > 0) ? Math.min(100, (currentSteps * 100) / dailyGoal) : 0;
        
        // Create modern notification with progress bar
        return new NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("🏃‍♂️ PureFit")
            .setContentText(String.format(Locale.getDefault(), "%,d steps today", currentSteps))
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setCategory(NotificationCompat.CATEGORY_SERVICE)
            .setProgress(dailyGoal, currentSteps, false)
            .setStyle(new NotificationCompat.BigTextStyle()
                .bigText(String.format(Locale.getDefault(), 
                    "🎯 Daily Goal: %,d steps\n📊 Progress: %d%%\n🚶‍♂️ Steps taken: %,d\n\nKeep moving! Every step counts towards your fitness journey.",
                    dailyGoal, progress, currentSteps)))
            .setColor(0xFF000000) // Green color for fitness theme
            .setShowWhen(false) // Hide timestamp for cleaner look
            .build();
    }

    private void updateNotification() {
        // Update notification every step for real-time updates
        startForeground(NOTIFICATION_ID, createNotification());
    }

    private void loadSavedData() {
        initialSteps = prefs.getInt("initialSteps", 0);
        currentSteps = prefs.getInt("currentSteps", 0);
        isFirstLaunch = prefs.getBoolean("isFirstLaunch", true);
        lastResetDate = prefs.getString("lastResetDate", "");
        dailyGoal = prefs.getInt("stepGoal", 1000);
        goalAchievedToday = prefs.getBoolean("goalAchievedToday", false);
        
        Log.d(TAG, "Loaded goal from SharedPreferences: " + dailyGoal);
    }
    
    private void saveStepData() {
        prefs.edit()
            .putInt("initialSteps", initialSteps)
            .putInt("currentSteps", currentSteps)
            .putBoolean("isFirstLaunch", isFirstLaunch)
            .putString("lastResetDate", lastResetDate)
            .putInt("stepGoal", dailyGoal)
            .putBoolean("goalAchievedToday", goalAchievedToday)
            .apply();
    }
    
    private void checkAndResetForNewDay() {
        // Optimization: Only check date every 60 seconds to avoid expensive date formatting on every step
        long currentTime = System.currentTimeMillis();
        if (currentTime - lastDateCheckTime < 60000) {
            // Less than 1 minute since last check, skip
            return;
        }
        lastDateCheckTime = currentTime;
        
        String today = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(new Date());
        
        if (!today.equals(lastResetDate)) {
            Log.d(TAG, "New day detected, resetting step counter");
            
            // Get current total steps from sensor (since this is TYPE_STEP_COUNTER)
            // This becomes the new initialSteps for today
            if (sensorManager != null && stepCounterSensor != null) {
                // We'll get the actual value from onSensorChanged when it fires
                // For now, we need to mark as first launch
                isFirstLaunch = true;
            }
            
            currentSteps = 0;
            lastResetDate = today;
            goalAchievedToday = false;
            saveStepData();
            
            Log.d(TAG, "Reset complete - isFirstLaunch: " + isFirstLaunch);
        }
    }
    
    private void checkGoalAchievement() {
        // Check if goal is achieved and not already celebrated today
        if (!goalAchievedToday && currentSteps >= dailyGoal) {
            goalAchievedToday = true;
            saveStepData();
            
            // Show celebration notification
            showGoalAchievementNotification();
            Log.d(TAG, "Goal achieved! Steps: " + currentSteps + " / " + dailyGoal);
        }
    }
    
    private void showGoalAchievementNotification() {
        NotificationManager notificationManager = getSystemService(NotificationManager.class);
        
        // Create celebration notification
        Notification celebrationNotification = new NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("🎉 Goal Achieved!")
            .setContentText(String.format(Locale.getDefault(), "You've reached %,d steps!", dailyGoal))
            .setSmallIcon(R.mipmap.ic_launcher)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setAutoCancel(true)
            .setStyle(new NotificationCompat.BigTextStyle()
                .bigText(String.format(Locale.getDefault(), 
                    "🎉 Congratulations! You've achieved your daily goal of %,d steps!\n\n🚶‍♂️ Steps taken: %,d\n\nKeep up the great work! Your fitness journey continues!",
                    dailyGoal, currentSteps)))
            .setColor(0xFF4CAF50)
            .build();
            
        notificationManager.notify(1002, celebrationNotification);
    }
}
