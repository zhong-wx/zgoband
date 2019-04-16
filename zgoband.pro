QT += quick
CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    main.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML2_IMPORT_PATH += D:\works\qtCreatorWorks\zgoband
QML_IMPORT_PATH += D:\works\qtCreatorWorks\zgoband

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    FlatUI/component/ErrorDialog.qmlc \
    FlatUI/component/FolderDialog.qmlc \
    FlatUI/component/VideoPlayer.qmlc \
    FlatUI/element/FlatButton.qmlc \
    FlatUI/element/FlatDialog.qmlc \
    FlatUI/element/FlatIcon.qmlc \
    FlatUI/element/FlatMainWindow.qmlc \
    FlatUI/element/FlatMenu.qmlc \
    FlatUI/element/FlatSlider.qmlc \
    FlatUI/element/FlatTags.qmlc \
    FlatUI/element/FlatTextField.qmlc \
    FlatUI/Private/AbstractWindow.qmlc \
    FlatUI/Private/ActiveColor.qmlc \
    FlatUI/Private/FlatIconName.qmlc \
    FlatUI/Private/Separator.qmlc \
    FlatUI/FlatGlobal.qmlc \
    FlatUI/ttf/NotoSansHans-DemiLight.otf \
    FlatUI/ttf/NotoSansHans-Regular.otf \
    FlatUI/ttf/flat-ui-icons-regular.ttf \
    FlatUI/ttf/lato-black.ttf \
    FlatUI/ttf/lato-bold.ttf \
    FlatUI/ttf/lato-bolditalic.ttf \
    FlatUI/ttf/lato-italic.ttf \
    FlatUI/ttf/lato-light.ttf \
    FlatUI/ttf/lato-regular.ttf \
    FlatUI/Resource/icons/Back.png \
    FlatUI/Resource/icons/BackHover.png \
    FlatUI/Resource/icons/Close.png \
    FlatUI/Resource/icons/CloseHover.png \
    FlatUI/Resource/icons/Cycle.png \
    FlatUI/Resource/icons/CycleHover.png \
    FlatUI/Resource/icons/Down.png \
    FlatUI/Resource/icons/DownHover.png \
    FlatUI/Resource/icons/File.png \
    FlatUI/Resource/icons/FileHover.png \
    FlatUI/Resource/icons/FullScreen.png \
    FlatUI/Resource/icons/FullScreenHover.png \
    FlatUI/Resource/icons/Maximize.png \
    FlatUI/Resource/icons/MaximizeHover.png \
    FlatUI/Resource/icons/Menu.png \
    FlatUI/Resource/icons/MenuHover.png \
    FlatUI/Resource/icons/Minimize.png \
    FlatUI/Resource/icons/MinimizeHover.png \
    FlatUI/Resource/icons/Once.png \
    FlatUI/Resource/icons/OnceHover.png \
    FlatUI/Resource/icons/Pause.png \
    FlatUI/Resource/icons/PauseHover.png \
    FlatUI/Resource/icons/Play.png \
    FlatUI/Resource/icons/PlayHover.png \
    FlatUI/Resource/icons/Previous.png \
    FlatUI/Resource/icons/PreviousHover.png \
    FlatUI/Resource/icons/Random.png \
    FlatUI/Resource/icons/RandomHover.png \
    FlatUI/Resource/icons/Restore.png \
    FlatUI/Resource/icons/RestoreHover.png \
    FlatUI/Resource/icons/scale.png \
    FlatUI/Resource/icons/ScaleHover.png \
    FlatUI/Resource/icons/Sequence.png \
    FlatUI/Resource/icons/SequenceHover.png \
    FlatUI/Resource/icons/Speed.png \
    FlatUI/Resource/icons/SpeedHover.png \
    FlatUI/Resource/icons/Stop.png \
    FlatUI/Resource/icons/StopHover.png \
    FlatUI/Private/qmldir \
    FlatUI/qmldir \
    FlatUI/component/ErrorDialog.qml \
    FlatUI/component/FolderDialog.qml \
    FlatUI/component/VideoPlayer.qml \
    FlatUI/element/FlatButton.qml \
    FlatUI/element/FlatCheckBox.qml \
    FlatUI/element/FlatComboBox.qml \
    FlatUI/element/FlatDialog.qml \
    FlatUI/element/FlatIcon.qml \
    FlatUI/element/FlatMainWindow.qml \
    FlatUI/element/FlatMenu.qml \
    FlatUI/element/FlatProgressBar.qml \
    FlatUI/element/FlatRadio.qml \
    FlatUI/element/FlatSlider.qml \
    FlatUI/element/FlatSwitch.qml \
    FlatUI/element/FlatTags.qml \
    FlatUI/element/FlatTextField.qml \
    FlatUI/element/FlatTip.qml \
    FlatUI/Private/AbstractWindow.qml \
    FlatUI/Private/ActiveColor.qml \
    FlatUI/Private/FlatIconName.qml \
    FlatUI/Private/Separator.qml \
    FlatUI/FlatGlobal.qml
