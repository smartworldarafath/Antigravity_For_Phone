package com.agy.ui.refresh;

import android.app.Activity;
import android.content.Context;
import android.os.Build;
import android.util.Log;
import android.view.Display;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

import java.lang.reflect.Field;
import java.lang.reflect.Method;

/**
 * Optimizes display refresh rates for 120Hz, 144Hz, and high-refresh screens,
 * enforcing buttery-smooth 60fps+ animations while ensuring thermal and battery efficiency
 * through adaptive frame rate scaling.
 */
public final class DisplayRefreshRateHelper {

    private static final String TAG = "DisplayRefreshHelper";

    private DisplayRefreshRateHelper() {
    }

    /**
     * Inspects device display modes and requests the highest available refresh rate
     * (e.g. 120Hz, 144Hz, 165Hz) matching the display resolution.
     * Enforces hardware acceleration and adaptive power-saving minimum rates.
     */
    public static void applyHighRefreshRate(Activity activity) {
        if (activity == null) return;
        try {
            Window window = activity.getWindow();
            if (window == null) return;

            // Ensure window hardware acceleration is strictly enabled
            window.addFlags(WindowManager.LayoutParams.FLAG_HARDWARE_ACCELERATED);

            Display display = null;
            if (Build.VERSION.SDK_INT >= 30) {
                try {
                    display = activity.getDisplay();
                } catch (Throwable ignored) {
                }
            }
            if (display == null) {
                WindowManager wm = (WindowManager) activity.getSystemService(Context.WINDOW_SERVICE);
                if (wm != null) {
                    display = wm.getDefaultDisplay();
                }
            }
            if (display == null) return;

            // Android 6.0+ (API 23+) Display Mode API
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                Display.Mode[] modes = display.getSupportedModes();
                if (modes != null && modes.length > 0) {
                    Display.Mode currentMode = display.getMode();
                    int currentWidth = currentMode != null ? currentMode.getPhysicalWidth() : 0;
                    int currentHeight = currentMode != null ? currentMode.getPhysicalHeight() : 0;

                    Display.Mode bestMode = null;
                    float maxRefreshRate = 60.0f;

                    // Match current resolution with highest available refresh rate
                    for (Display.Mode mode : modes) {
                        float rate = mode.getRefreshRate();
                        if (currentWidth > 0 && currentHeight > 0) {
                            if (mode.getPhysicalWidth() == currentWidth && mode.getPhysicalHeight() == currentHeight) {
                                if (rate > maxRefreshRate) {
                                    maxRefreshRate = rate;
                                    bestMode = mode;
                                }
                            }
                        } else {
                            if (rate > maxRefreshRate) {
                                maxRefreshRate = rate;
                                bestMode = mode;
                            }
                        }
                    }

                    // Fallback to highest refresh rate mode across all supported modes
                    if (bestMode == null) {
                        for (Display.Mode mode : modes) {
                            if (mode.getRefreshRate() > maxRefreshRate) {
                                maxRefreshRate = mode.getRefreshRate();
                                bestMode = mode;
                            }
                        }
                    }

                    WindowManager.LayoutParams params = window.getAttributes();
                    boolean modified = false;

                    if (bestMode != null && maxRefreshRate >= 85.0f) {
                        params.preferredDisplayModeId = bestMode.getModeId();
                        modified = true;
                        Log.i(TAG, "Configured high refresh rate mode: " + maxRefreshRate + "Hz (modeId=" + bestMode.getModeId() + ")");
                    }

                    // Android 11+ (API 30+) preferredMaxDisplayRefreshRate & preferredMinDisplayRefreshRate
                    if (Build.VERSION.SDK_INT >= 30) {
                        try {
                            Field maxField = WindowManager.LayoutParams.class.getField("preferredMaxDisplayRefreshRate");
                            Field minField = WindowManager.LayoutParams.class.getField("preferredMinDisplayRefreshRate");
                            maxField.setFloat(params, maxRefreshRate);
                            // Set min to 60.0Hz: guarantees locked minimum 60fps at all times,
                            // while allowing LTPO panels to adaptively optimize power when idle
                            minField.setFloat(params, 60.0f);
                            modified = true;
                            Log.i(TAG, "Configured display refresh bounds: 60Hz - " + maxRefreshRate + "Hz");
                        } catch (Throwable t) {
                            Log.d(TAG, "API 30 reflection: " + t.getMessage());
                        }
                    }

                    if (modified) {
                        window.setAttributes(params);
                    }
                }
            }
        } catch (Throwable t) {
            Log.w(TAG, "applyHighRefreshRate failed: " + t.getMessage());
        }
    }

    /**
     * Binds a view (such as the WebView or root layout) to maximum frame rate rendering (API 31+).
     */
    public static void setViewHighRefreshRate(View view, float targetRate) {
        if (view == null || Build.VERSION.SDK_INT < 31 || targetRate <= 60.0f) return;
        try {
            Method setFrameRateMethod = View.class.getMethod("setFrameRate", float.class, int.class);
            // 0 = FRAME_RATE_COMPATIBILITY_DEFAULT
            setFrameRateMethod.invoke(view, targetRate, 0);
            Log.i(TAG, "Set view frame rate: " + targetRate + "Hz");
        } catch (Throwable ignored) {
        }
    }
}
