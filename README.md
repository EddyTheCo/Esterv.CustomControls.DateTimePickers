# Esterv.CustomControls.DateTimePickers 

[TOC]

This repo creates a QML module with custom types for date and  time selection.
Ideally, the types should look like [these](https://mui.com/x/react-date-pickers/date-time-picker/).

The types should be style-independent, but the colors used rely on the [EstervDesigns](https://github.com/EddyTheCo/Esterv.Designs)
Simple style. 
If you want to change the colors in your top QML file you can do
```
import Esterv.Styles.Simple
...

Component.onCompleted:
{
Style.frontColor1= (Style.theme)?LightThemeColor:DarkThemeColor//Like control.palette.text

Style.frontColor2= ... 
Style.frontColor3= ... 

Style.backColor1= ... 
Style.backColor2= ... 
Style.backColor3= ... 
}

``` 

## Configure, build, test, package ...
 
The project uses [CMake presets](https://cmake.org/cmake/help/latest/manual/cmake-presets.7.html) as a way to share CMake configurations.
Refer to [cmake](https://cmake.org/cmake/help/latest/manual/cmake.1.html), [ctest](https://cmake.org/cmake/help/latest/manual/ctest.1.html) and [cpack](https://cmake.org/cmake/help/latest/manual/cpack.1.html) documentation for more information on the use of presets.


## Using the module in your CMake project 

Just add to your project CMakeLists.txt

```
FetchContent_Declare(
        EstervDTPickers
        GIT_REPOSITORY https://github.com/EddyTheCo/Esterv.CustomControls.DateTimePickers.git
	GIT_TAG vMAJOR.MINOR.PATCH 
	FIND_PACKAGE_ARGS MAJOR.MINOR CONFIG  
    )
FetchContent_MakeAvailable(EstervDTPickers)
target_link_libraries(<target> <PRIVATE|PUBLIC|INTERFACE> Esterv::DTPickers) 
```
If want to use the QML module also add
```
target_link_libraries(<target> <PRIVATE|PUBLIC|INTERFACE> $<$<STREQUAL:$<TARGET_PROPERTY:Esterv::DTPickers,TYPE>,STATIC_LIBRARY>:Esterv::DTPickersplugin>)
```

Then you have to add to your [QML IMPORT PATH](https://doc.qt.io/qt-6/qtqml-syntax-imports.html) the `qrc:/esterVtech.com/imports` path.
For that one could add this to the  main function:

```
QQmlApplicationEngine engine;
engine.addImportPath("qrc:/esterVtech.com/imports");
```

## Examples

The [examples](examples) folder shows the use of the different custom types provided by the QML module.

One can also play with the types [here](https://eddytheco.github.io/qmlonline/?example_url=dtpickers)


## API reference

You can read the [API reference](https://eddytheco.github.io/Esterv.CustomControls.DateTimePickers/), or generate it yourself like
```
cmake --workflow --preset default-documentation
```

## Contributing

We appreciate any contribution!


You can open an issue or request a feature.
You can open a PR to the `develop` branch and the CI/CD will take care of the rest.
Make sure to acknowledge your work, and ideas when contributing.

