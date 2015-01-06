prepare_ios:
	sed -i -E 's/ratchet\-theme\-android\.min\.css/ratchet\-theme\-ios\.min\.css/' ebapp/source/css/all.css

build_ios: prepare_ios build

prepare_android:
	sed -i -E 's/ratchet\-theme\-ios\.min\.css/ratchet-theme-android\.min\.css/' ebapp/source/css/all.css

build_android: prepare_android build

