cmake_minimum_required(VERSION 3.24)
include(${CMAKE_CURRENT_BINARY_DIR}/local_conf.cmake OPTIONAL)

include(FetchContent)
FetchContent_Declare(
	ccommon
	GIT_REPOSITORY https://github.com/EddyTheCo/Common.git
	GIT_TAG v0.0.1
	)
FetchContent_MakeAvailable(ccommon)
version_from_git(
	LOG       OFF
	TIMESTAMP "%Y%m%d%H%M%S"
	)
project(DTPickersQML VERSION ${VERSION} DESCRIPTION "Date Time QML pickers" LANGUAGES CXX)


set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
include(GNUInstallDirs)

FetchContent_Declare(
	EstervDesigns
	GIT_REPOSITORY https://github.com/EddyTheCo/MyDesigns.git
        GIT_TAG improvements
	FIND_PACKAGE_ARGS 0.4 COMPONENTS SimpleStyle CustomControls CONFIG
	)
FetchContent_MakeAvailable(EstervDesigns)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Quick ShaderTools)


qt_standard_project_setup()

qt6_add_qml_module(DTPickers
        URI  Esterv.CustomControls.DateTimePickers
	VERSION ${VERSION}
	QML_FILES
	"qml/DatePicker.qml"
	"qml/TimePicker.qml"
	"qml/DateTimePicker.qml"
        "qml/ShowDateTimePicker.qml"
	RESOURCE_PREFIX
	"/esterVtech.com/imports"
	OUTPUT_TARGETS out_targets_var
	OUTPUT_DIRECTORY
        ${CMAKE_BINARY_DIR}/Esterv/CustomControls/DateTimePickers
	IMPORT_PATH ${CMAKE_BINARY_DIR} ${CMAKE_INSTALL_LIBDIR}
	IMPORTS QtQuick.Layouts 
	)

qt6_add_shaders(DTPickers "esterVtech.com.imports.DTPickers.shaders"
	BATCHABLE
	PRECOMPILE
	OPTIMIZED
	OUTPUT_TARGETS out_targets_var2
	PREFIX
	"/esterVtech.com/imports/Designs"
	FILES
	"frag/clock.frag"
	"frag/calendar.frag"
	)

target_link_libraries(DTPickers PUBLIC Qt6::Gui Qt6::Quick Qt6::Core EstervDesigns::SimpleStyle EstervDesigns::customControls 
	$<$<STREQUAL:$<TARGET_PROPERTY:EstervDesigns::SimpleStyle,TYPE>,STATIC_LIBRARY>:EstervDesigns::SimpleStyleplugin>
	$<$<STREQUAL:$<TARGET_PROPERTY:EstervDesigns::customControls,TYPE>,STATIC_LIBRARY>:EstervDesigns::customControlsplugin>
	)

install(TARGETS ${out_targets_var} ${out_targets_var2}  DTPickers
	EXPORT ${PROJECT_NAME}-config
	DESTINATION ${CMAKE_INSTALL_LIBDIR}
	COMPONENT DTPickers
	)

install(DIRECTORY ${CMAKE_BINARY_DIR}/Esterv/CustomControls/DateTimePickers
	DESTINATION ${CMAKE_INSTALL_LIBDIR}/Esterv/CustomControls
	COMPONENT DTPickers
	)

install(TARGETS DTPickersplugin
	EXPORT ${PROJECT_NAME}-config
	DESTINATION ${CMAKE_INSTALL_LIBDIR}/Esterv/CustomControls/DateTimePickers
	COMPONENT DTPickers
	)

install(EXPORT ${PROJECT_NAME}-config
	FILE ${PROJECT_NAME}-config.cmake
	DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/Esterv
	NAMESPACE ${PROJECT_NAME}::
	COMPONENT All
	)
include(CMakePackageConfigHelpers)
configure_package_config_file(${CMAKE_CURRENT_SOURCE_DIR}/Config.cmake.in
	"${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
	INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/Esterv
	)
write_basic_package_version_file(
	"${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
	VERSION ${VERSION}
	COMPATIBILITY SameMajorVersion
	)
install(FILES
	${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
	${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
	DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/Esterv
	)
export(EXPORT ${PROJECT_NAME}-config
	FILE "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-config.cmake"
	)
if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
        add_subdirectory(examples)
	set(CPACK_PACKAGE_CONTACT "estervtech")
	set(CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}-v${SEMVER}-${CMAKE_SYSTEM_NAME}_${CMAKE_SYSTEM_VERSION}-${CMAKE_SYSTEM_PROCESSOR}-${CMAKE_CXX_COMPILER_ID}")
	include(CPack)
endif()

