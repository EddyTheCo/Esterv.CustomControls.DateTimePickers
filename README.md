# Date and Time pickers types for QML 

This repo creates a QML module with custom types for date and  time selection.


## Use it in your project

Just add to your project CMakeLists.txt

```
FetchContent_Declare(
        DTPickers
        GIT_REPOSITORY https://github.com/EddyTheCo/DateTimePickers.git
        GIT_TAG main
        FIND_PACKAGE_ARGS 0.0 CONFIG
    )
FetchContent_MakeAvailable(DTPickers)
target_link_libraries(yourAppTarget PRIVATE DTPickers 
$<$<STREQUAL:$<TARGET_PROPERTY:DTPickers,TYPE>,STATIC_LIBRARY>:DTPickersplugin>
)
```

Then you have to add to your [QML IMPORT PATH](https://doc.qt.io/qt-6/qtqml-syntax-imports.html) the `qrc:/esterVtech.com/imports` path.
For that one could add this to the  main function:

```
QQmlApplicationEngine engine;
engine.addImportPath("qrc:/esterVtech.com/imports");
```
The different types can be used in QML like
```
import DTPickers

DateTimePicker
{
}
```

TODO You can play with the QML element [here](https://eddytheco.github.io/qmlonline/?example_url=omclient). 


## Contributing

We appreciate any contribution!


You can open an issue or request a feature also.
You can open a PR to the development branch and the CI/CD will take care of the rest.
Make sure to acknowledge your work, ideas when contributing.

