
-keep class com.app_cms_ghc. { ; }


-keep class extends android.app.Activity
-keep class * extends android.app.Application
-keep class * extends android.app.Service
-keep class * extends android.content.BroadcastReceiver
-keep class * extends android.content.ContentProvider


-keepclassmembers class * {
    public void (android.view.View);
    public void(android.view.MenuItem);
}


-keepclassmembers class * implements android.os.Parcelable {
    static  CREATOR;
}