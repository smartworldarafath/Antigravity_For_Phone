package com.agy.core;

import com.agy.runtime.RuntimeConfig;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

/** Cross-component state shared by the service, the bridge and the UI. */
public final class CoreRuntimeState {

    public interface StateListener {
        void onStateChanged();
    }

    private static final List<StateListener> listeners = new CopyOnWriteArrayList<>();

    private CoreRuntimeState() {
    }

    /** Published once the core answers on its loopback port. */
    public static volatile String serverUrl = null;
    public static volatile int httpsPort = RuntimeConfig.DEFAULT_HTTPS_PORT;
    public static volatile String csrfToken = null;

    /** Fail-closed startup error, surfaced to the UI instead of a hung splash. */
    public static volatile String lastError = null;
    /** True while an unexpected exit is being auto-restarted (transient, not fatal). */
    public static volatile boolean restarting = false;
    /** Bumped on every successful ready; the UI reloads the app when it changes. */
    public static volatile int readyGeneration = 0;

    public static void addListener(StateListener listener) {
        if (listener != null && !listeners.contains(listener)) {
            listeners.add(listener);
        }
    }

    public static void removeListener(StateListener listener) {
        if (listener != null) {
            listeners.remove(listener);
        }
    }

    public static void notifyStateChanged() {
        for (StateListener listener : listeners) {
            try {
                listener.onStateChanged();
            } catch (Throwable ignored) {
            }
        }
    }
}
