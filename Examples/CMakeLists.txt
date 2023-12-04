cmake_minimum_required(VERSION 3.11)

foreach(example "datepickerExample"
		"timepickerExample"
		"datetimepickerExample"
		)
	qt_add_executable(${example} ${example}.cpp )

	qt6_add_qml_module(${example}
		URI  E${example}
		VERSION 1.0
		QML_FILES
		"qml/${example}.qml"
		RESOURCE_PREFIX
		"/esterVtech.com/imports"
		IMPORT_PATH ${CMAKE_BINARY_DIR}
		)

	target_link_libraries(${example} PRIVATE Qt::Gui Qt::Qml Qt::Quick DTPickers
		$<$<STREQUAL:$<TARGET_PROPERTY:DTPickers,TYPE>,STATIC_LIBRARY>:DTPickersplugin>
		)

	set_target_properties(${example} PROPERTIES
		WIN32_EXECUTABLE ON
		MACOSX_BUNDLE ON
		)
	install(TARGETS ${example}
		BUNDLE  DESTINATION .
		DESTINATION ${CMAKE_INSTALL_BINDIR}
		)
	if(QTDEPLOY)
		qt_generate_deploy_qml_app_script(
			TARGET ${example}
			OUTPUT_SCRIPT deploy_script
			)
		install(SCRIPT ${deploy_script})
	endif(QTDEPLOY)
endforeach()
