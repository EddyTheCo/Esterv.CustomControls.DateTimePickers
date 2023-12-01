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
project(QMLModules VERSION ${VERSION} DESCRIPTION "Date Time QML pickers" LANGUAGES CXX)

set(default_build_type "Release")
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
        message(STATUS "Setting build type to '${default_build_type}' as none was specified.")
        set(CMAKE_BUILD_TYPE "${default_build_type}" CACHE
                STRING "Choose the type of build." FORCE)
        # Set the possible values of build type for cmake-gui
        set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
                "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
include(GNUInstallDirs)

find_package(Qt6 COMPONENTS Core Gui Quick ShaderTools)

if (Qt6_FOUND)
        qt_standard_project_setup()

	qt6_add_qml_module(DTPickers
		URI  DTPickers
                VERSION 1.0
                QML_FILES
                "qml/DatePicker.qml"
                "qml/TimePicker.qml"
                "qml/DateTimePicker.qml"
                "qml/ShowDateTime.qml"
                RESOURCE_PREFIX
                "/esterVtech.com/imports"
                OUTPUT_TARGETS out_targets_var
                OUTPUT_DIRECTORY
		${CMAKE_BINARY_DIR}/DTPickers
                RESOURCES
                   "fonts/Roboto/Roboto-Light.ttf"
                   "fonts/Roboto/Roboto-Regular.ttf"
                )

        qt6_add_shaders(DTPickers "esterVtech.com.imports.DTPickers.shaders"
                BATCHABLE
                PRECOMPILE
                OPTIMIZED
                OUTPUT_TARGETS out_targets_var2
                PREFIX
                "/esterVtech.com/imports/DTPickers"
                FILES
                "frag/clock.frag"
                "frag/calendar.frag"
		"frag/hollowArrowHead.frag"
		"frag/filledArrowHead.frag"
                )

	target_link_libraries(DTPickers PUBLIC Qt6::Gui Qt6::Quick Qt6::Core )


if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME AND BUILD_EXAMPLES)
        add_subdirectory(Examples)
endif()

        install(TARGETS ${out_targets_var} ${out_targets_var2}  DTPickers 
                EXPORT DTPickersTargets
                DESTINATION ${CMAKE_INSTALL_LIBDIR})
        install(TARGETS DTPickersplugin
                EXPORT DTPickersTargets
		DESTINATION ${CMAKE_INSTALL_LIBDIR}/QMLPlugins/DTPickers)

        install(DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/include/
                DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/omqml)
        install(DIRECTORY ${CMAKE_BINARY_DIR}/DTPickers/
                DESTINATION ${CMAKE_INSTALL_LIBDIR}/QMLPlugins/DTPickers
                )
        install(EXPORT DTPickersTargets
                FILE DTPickersTargets.cmake
                DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/DTPickers
                )
        include(CMakePackageConfigHelpers)
        # generate the config file that is includes the exports
        configure_package_config_file(${CMAKE_CURRENT_SOURCE_DIR}/Config.cmake.in
                "${CMAKE_CURRENT_BINARY_DIR}/DTPickersConfig.cmake"
                INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/DTPickers"
                )
        write_basic_package_version_file(
                "${CMAKE_CURRENT_BINARY_DIR}/DTPickersConfigVersion.cmake"
                VERSION ${VERSION}
                COMPATIBILITY SameMajorVersion
                )
        install(FILES
                ${CMAKE_CURRENT_BINARY_DIR}/DTPickersConfig.cmake
                ${CMAKE_CURRENT_BINARY_DIR}/DTPickersConfigVersion.cmake
                DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/DTPickers
                )
        export(EXPORT DTPickersTargets
                FILE "${CMAKE_CURRENT_BINARY_DIR}/DTPickersTargets.cmake"
                )
        if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
                set(CPACK_PACKAGE_CONTACT "estervtech")
                set(CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}-v${SEMVER}-${CMAKE_SYSTEM_NAME}_${CMAKE_SYSTEM_VERSION}-${CMAKE_SYSTEM_PROCESSOR}-${CMAKE_CXX_COMPILER_ID}")
                include(CPack)
        endif()

endif(Qt6_FOUND)

