package com.agy.core;

import android.content.Context;
import android.os.PowerManager;
import android.util.Log;

/** Holds a partial wake lock with battery-efficient safety timeouts. */
public final class WakeLockHolder {

    private static final String TAG = "WakeLockHolder";
    private static final long DEFAULT_STARTUP_TIMEOUT_MS = 180_000; // 3 minutes timeout

    private PowerManager.WakeLock wakeLock;

    public void acquire(Context context) {
        acquire(context, DEFAULT_STARTUP_TIMEOUT_MS);
    }

    public void acquire(Context context, long timeoutMs) {
        try {
            PowerManager pm = (PowerManager) context.getSystemService(Context.POWER_SERVICE);
            if (pm != null) {
                if (wakeLock == null) {
                    wakeLock = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "agy::core");
                    wakeLock.setReferenceCounted(false);
                }
                if (!wakeLock.isHeld()) {
                    if (timeoutMs > 0) {
                        wakeLock.acquire(timeoutMs);
                        Log.i(TAG, "Acquired partial wakelock with timeout " + timeoutMs + "ms");
                    } else {
                        wakeLock.acquire();
                        Log.i(TAG, "Acquired partial wakelock");
                    }
                }
            }
        } catch (Exception e) {
            Log.w(TAG, "wakelock acquire failed", e);
        }
    }

    public void release() {
        try {
            if (wakeLock != null && wakeLock.isHeld()) {
                wakeLock.release();
                Log.i(TAG, "Released partial wakelock to conserve battery");
            }
        } catch (Exception e) {
            Log.w(TAG, "wakelock release failed", e);
        }
    }
}
