package com.kniephos.kniephos

import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        private const val SLEEP_CHANNEL = "com.kniephos.kniephos/sleep_inhibitor"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        // wex / *Guard 加固壳的 Init.init(Application) 必须拿到真实的 Application。
        // FlutterPluginBinding.applicationContext 在部分机型上是 ContextImpl 而不是
        // Application，插件里再怎么剥 ContextWrapper 都取不到，所以这里从 Activity
        // 直接绑定一次 (getApplication()) 是框架保证的 Application 实例)。
        SpiderHostPlugin.bindApplication(application)
        super.configureFlutterEngine(flutterEngine)
        // 手动注册安卓原生 jar/DEX 蜘蛛运行器 (dex2jar + unidbg 的安卓等价实现)。
        // 该插件是本地代码 (未走 pub 插件自动注册)，故在此显式添加。
        flutterEngine.plugins.add(SpiderHostPlugin())

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SLEEP_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "setKeepScreenOn") {
                    val enabled = (call.arguments as? Boolean) ?: false
                    runOnUiThread {
                        if (enabled) {
                            window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                        } else {
                            window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                        }
                    }
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }
}
class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        // wex / *Guard 加固壳的 Init.init(Application) 必须拿到真实的 Application。
        // FlutterPluginBinding.applicationContext 在部分机型上是 ContextImpl 而不是
        // Application，插件里再怎么剥 ContextWrapper 都取不到，所以这里从 Activity
        // 直接绑定一次（getApplication() 是框架保证的 Application 实例）。
        SpiderHostPlugin.bindApplication(application)
        super.configureFlutterEngine(flutterEngine)
        // 手动注册安卓原生 jar/DEX 蜘蛛运行器（dex2jar + unidbg 的安卓等价实现）。
        // 该插件是本地代码（未走 pub 插件自动注册），故在此显式添加。
        flutterEngine.plugins.add(SpiderHostPlugin())
    }
}
