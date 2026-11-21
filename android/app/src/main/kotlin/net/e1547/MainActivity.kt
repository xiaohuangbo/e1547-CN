package net.e1547

import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity: FlutterFragmentActivity () {
    // This is a hack to prevent media_kit from hard-crashing the app
    override fun finishAfterTransition() {
        moveTaskToBack(true)
    }
}
