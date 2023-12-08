# Date and Time pickers types for QML 

This repo creates a QML module with custom types for date and  time selection.
Ideally the types should look like [these](https://mui.com/x/react-date-pickers/date-time-picker/).

The types should be style independent, but the colors used relies on the [EstervDesigns](https://github.com/EddyTheCo/MyDesigns)
Simple style. 
If you want to change the colors in your top qml file one can do
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

## Installing the module 

### From source code
```
git clone https://github.com/EddyTheCo/DateTimePickers.git 

mkdir build
cd build
qt-cmake -G Ninja -DCMAKE_INSTALL_PREFIX=installDir -DCMAKE_BUILD_TYPE=Release -DQTDEPLOY=OFF -DBUILD_EXAMPLES=OFF -DBUILD_DOCS=OFF ../DateTimePickers

cmake --build . 

cmake --install . 
```
where `installDir` is the installation path, `QTDEPLOY` install the examples and Qt dependencies using the  [cmake-deployment-api](https://www.qt.io/blog/cmake-deployment-api).
One can choose to build or not the example and the documentation with the `BUILD_EXAMPLES` and `BUILD_DOCS` variables.


### From GitHub releases
Download the releases from this repo. 

## Using the module in your CMake project 

Just add to your project CMakeLists.txt

```
FetchContent_Declare(
        DTPickersQML
        GIT_REPOSITORY https://github.com/EddyTheCo/DateTimePickers.git
	GIT_TAG v1.0.0 
        FIND_PACKAGE_ARGS 1.0 CONFIG
    )
FetchContent_MakeAvailable(DTPickersQML)
target_link_libraries(yourAppTarget PRIVATE DTPickersQML::DTPickers 
$<$<STREQUAL:$<TARGET_PROPERTY:DTPickersQML::DTPickers,TYPE>,STATIC_LIBRARY>:DTPickersQML::DTPickersplugin>
)
```

Then you have to add to your [QML IMPORT PATH](https://doc.qt.io/qt-6/qtqml-syntax-imports.html) the `qrc:/esterVtech.com/imports` path.
For that one could add this to the  main function:

```
QQmlApplicationEngine engine;
engine.addImportPath("qrc:/esterVtech.com/imports");
```

## Examples

The [examples](examples) folder shows the use of the different custom types provided by the QML module.



## Contributing

We appreciate any contribution!


You can open an issue or request a feature also.
You can open a PR to the `develop` branch and the CI/CD will take care of the rest.
Make sure to acknowledge your work, ideas when contributing.

