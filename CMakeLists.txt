cmake_minimum_required(VERSION 3.24)

option(BUILD_EXAMPLES "Build the examples" OFF)
include(${CMAKE_CURRENT_BINARY_DIR}/local_conf.cmake OPTIONAL)

include(FetchContent)
FetchContent_Declare(
  ccommon
  GIT_REPOSITORY https://github.com/EddyTheCo/Common.git
  GIT_TAG v0.5.0)
FetchContent_MakeAvailable(ccommon)
version_from_git(LOG OFF TIMESTAMP "%Y%m%d%H%M%S")
project(
  EstervDTPickers
  VERSION ${VERSION}
  DESCRIPTION "Date Time QML pickers"
  LANGUAGES CXX)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
include(GNUInstallDirs)

FetchContent_Declare(
  EstervDesigns
  GIT_REPOSITORY https://github.com/EddyTheCo/Esterv.Designs.git
  GIT_TAG v2.0.0
  FIND_PACKAGE_ARGS
  2
  COMPONENTS
  SimpleStyle
  CustomControls
  Controls
  CONFIG)
FetchContent_MakeAvailable(EstervDesigns)

find_package(Qt6 COMPONENTS Core Gui Quick ShaderTools)
if(Qt6_FOUND)
  qt_standard_project_setup()

  qt6_add_qml_module(
    DTPickers
    URI
    Esterv.CustomControls.DateTimePickers
    VERSION
    1.0
    QML_FILES
    "qml/DatePicker.qml"
    "qml/TimePicker.qml"
    "qml/DateTimePicker.qml"
    "qml/ShowDateTimePicker.qml"
    RESOURCE_PREFIX
    "/esterVtech.com/imports"
    OUTPUT_TARGETS
    out_targets_var
    OUTPUT_DIRECTORY
    ${CMAKE_BINARY_DIR}/Esterv/CustomControls/DateTimePickers
    IMPORT_PATH
    ${CMAKE_BINARY_DIR}
    IMPORTS
    QtQuick.Layouts)

  add_library(Esterv::DTPickers ALIAS DTPickers)
  set_target_properties(DTPickers PROPERTIES VERSION ${VERSION}
                                             SOVERSION ${VERSION_MAJOR})
  add_library(Esterv::DTPickersplugin ALIAS DTPickersplugin)

  qt6_add_shaders(
    DTPickers
    "esterVtech.com.imports.DTPickers.shaders"
    BATCHABLE
    PRECOMPILE
    OPTIMIZED
    OUTPUT_TARGETS
    out_targets_var2
    PREFIX
    "/esterVtech.com/imports/Designs"
    FILES
    "frag/clock.frag"
    "frag/calendar.frag")

  target_link_libraries(
    DTPickers
    PUBLIC
      Qt6::Gui
      Qt6::Quick
      Qt6::Core
      Esterv::SimpleStyle
      Esterv::CustomControls
      $<$<STREQUAL:$<TARGET_PROPERTY:Esterv::SimpleStyle,TYPE>,STATIC_LIBRARY>:Esterv::SimpleStyleplugin>
      $<$<STREQUAL:$<TARGET_PROPERTY:Esterv::CustomControls,TYPE>,STATIC_LIBRARY>:Esterv::CustomControlsplugin>
  )

  install(
    TARGETS ${out_targets_var} ${out_targets_var2} DTPickers
    EXPORT ${PROJECT_NAME}-config
    COMPONENT ${PROJECT_NAME}
    ARCHIVE COMPONENT ${PROJECT_NAME}-dev)

  install(
    DIRECTORY ${CMAKE_BINARY_DIR}/Esterv/CustomControls/DateTimePickers
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/Esterv/CustomControls
    COMPONENT ${PROJECT_NAME}-qml)

  install(
    TARGETS DTPickersplugin
    EXPORT ${PROJECT_NAME}-config
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/Esterv/CustomControls/DateTimePickers
    COMPONENT ${PROJECT_NAME}-qml
    ARCHIVE COMPONENT ${PROJECT_NAME}-dev)

  set(SET_COMPONENTS "")
  foreach(component "DTPickers")
    if(TARGET "${component}")
      string(APPEND SET_COMPONENTS
             "set(${PROJECT_NAME}_${component}_FOUND \"ON\")\n")
    endif(TARGET "${component}")
  endforeach()

  build_exports()
  if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
    add_subdirectory(examples)
    build_cpack()
  endif(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
endif()

if(BUILD_DOCS)
  build_docs()
endif(BUILD_DOCS)
