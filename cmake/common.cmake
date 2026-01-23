function(call _id)
    if (NOT COMMAND ${_id})
        message(FATAL_ERROR "Unsupported function/macro \"${_id}\"")
    else()
        set(_helper "${CMAKE_BINARY_DIR}/helpers/macro_helper_${_id}.cmake")
        if (NOT EXISTS "${_helper}")
            file(WRITE "${_helper}" "${_id}(\$\{ARGN\})\n")
        endif()
        include("${_helper}")
    endif()
endfunction()

function(lpp_make_library) #PRIVATE_DEFINE HEADERS SOURCES QT_DEPENDENCES LOCAL_LIBS LOCAL_PLUGINS)
    string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)
    message(STATUS "-------=================-------")
    message(STATUS "Project: ${PROJECT_NAME}")
    message(STATUS "${PROJECT_SOURCE_DIR}")

    file(GLOB_RECURSE UI_SRC "*.ui")
    source_group("Ui Files" FILES ${UI_SRC})

    set(CMAKE_CXX_STANDARD 17)                                                      
    set(CMAKE_CXX_STANDARD_REQUIRED ON) 


    find_package(QT NAMES Qt6 Qt5 COMPONENTS ${QT_DEPENDENCES} REQUIRED)
    find_package(Qt${QT_VERSION_MAJOR} COMPONENTS ${QT_DEPENDENCES} REQUIRED)

    if(UIS)
        if (NOT CMAKE_AUTOUIC)
            message(STATUS "  UIs: ${UIS}")
            qt_wrap_ui(UI_HEADERS ${UIS})
        endif()
    endif()

    if(RESOURCES)
        if (NOT CMAKE_AUTORCC)
            message(STATUS "  Res: ${RESOURCES}")
            qt_add_resources(RES_HEADERS ${RESOURCES})
        endif()
    endif()


    foreach(DEP IN LISTS HEADERS)
        if(NOT EXISTS "${PROJECT_SOURCE_DIR}/${DEP}")
            message(STATUS "File: ${DEP} is missing.")
        endif()
    endforeach()
    foreach(DEP IN LISTS P_HEADERS)
        if(NOT EXISTS "${PROJECT_SOURCE_DIR}/${DEP}")
            message(STATUS "File: ${DEP} is missing.")
        endif()
    endforeach()
    foreach(DEP IN LISTS SOURCES)
        if(NOT EXISTS "${PROJECT_SOURCE_DIR}/${DEP}")
            message(STATUS "File: ${DEP} is missing.")
        endif()
    endforeach()
    foreach(DEP IN LISTS UI_HEADERS)
        if(NOT EXISTS "${PROJECT_SOURCE_DIR}/${DEP}")
            message(STATUS "File: ${DEP} is missing.")
        endif()
    endforeach()
    foreach(DEP IN LISTS RESOURCES)
        if(NOT EXISTS "${PROJECT_SOURCE_DIR}/${DEP}")
            message(STATUS "File: ${DEP} is missing.")
        endif()
    endforeach()

    if(${QT_VERSION_MAJOR} LESS 6 OR (${QT_VERSION_MAJOR} EQUAL 6 AND ${QT_VERSION_MINOR} LESS 2))
        message(STATUS "add_library")
        if(DEFINED CLASS_NAME)
            add_library(${PROJECT_NAME} CLASS_NAME ${CLASS_NAME} SHARED ${HEADERS} ${P_HEADERS} ${SOURCES} ${UI_HEADERS} ${RESOURCES})
        else()
            add_library(${PROJECT_NAME} SHARED ${HEADERS} ${P_HEADERS} ${SOURCES} ${UI_HEADERS} ${RESOURCES})
        endif()
    else()
        if(DEFINED CLASS_NAME)
            qt_add_library(${PROJECT_NAME} CLASS_NAME ${CLASS_NAME} SHARED ${RESOURCES} ${HEADERS} ${P_HEADERS} ${SOURCES} ${UI_HEADERS})
        else()
            qt_add_library(${PROJECT_NAME} SHARED ${RESOURCES} ${HEADERS} ${P_HEADERS} ${SOURCES} ${UI_HEADERS})
        endif()
    endif()

    
    if(LP_PRIVATE_DEFINE)
        message(STATUS "Private defines: ${LP_PRIVATE_DEFINE}")
        foreach(DEP IN LISTS LP_PRIVATE_DEFINE)
            target_compile_definitions(${PROJECT_NAME} PRIVATE "-D${DEP}")
        endforeach()
    endif()

    set_target_properties(${PROJECT_NAME} PROPERTIES WIN32_EXECUTABLE FALSE)

    target_compile_definitions(${PROJECT_NAME} PUBLIC QT_DEPRECATED_WARNINGS )

    #message(STATUS "CMake prefix path: ${CMAKE_PREFIX_PATH}")

    if(QT_DEPENDENCES)
        message(STATUS "Qt${QT_VERSION_MAJOR} libraries to link: ${QT_DEPENDENCES}")
        foreach(DEP IN LISTS QT_DEPENDENCES)
            target_link_libraries(${PROJECT_NAME} PRIVATE Qt${QT_VERSION_MAJOR}::${DEP})
        endforeach()
    endif()

    if(THIRD_PARTY_LIBS)
        message(STATUS "Third party libraries to link: ${THIRD_PARTY_LIBS}")
        foreach(DEP IN LISTS THIRD_PARTY_LIBS)
            message(STATUS "Loading: ${DEP}")
            set(DEP_PATH "${LP_THIRD_PARTY_PREFIX}/${DEP}.cmake")
            if(EXISTS "${DEP_PATH}")
                include(${DEP_PATH})
                call(import_${DEP} ${PROJECT_NAME})
            else()
                message(STATUS "Library file ${DEP} not found (${DEP_PATH})")
            endif()
        endforeach()
    endif()

    if(LOCAL_LIBS)
        message(STATUS "Libraries to link: ${LOCAL_LIBS}")
        foreach(DEP IN LISTS LOCAL_LIBS)
            target_link_libraries(${PROJECT_NAME} PRIVATE ${DEP})
        endforeach()
    endif()
    
    if(LOCAL_PLUGINS)
    message(STATUS "Plugins to link: ${LOCAL_PLUGINS}")
        foreach(DEP IN LISTS LOCAL_PLUGINS)
            target_link_libraries(${PROJECT_NAME} PRIVATE ${DEP})
        endforeach()
    endif()

    target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_17)

    target_include_directories(${PROJECT_NAME} PUBLIC include)

    include(GNUInstallDirs) 

    list(APPEND LP_SOURCE_LIST "${PROJECT_SOURCE_DIR}")

    list(APPEND CMAKE_PREFIX_PATH "${LP_INSTALL_LIST}")
    list(APPEND CMAKE_PREFIX_PATH "${LP_SOURCE_LIST}")

    install(
        TARGETS ${PROJECT_NAME}
        EXPORT ${PROJECT_NAME}Targets
        RUNTIME DESTINATION  ${CMAKE_INSTALL_BINDIR}
        LIBRARY DESTINATION  ${CMAKE_INSTALL_LIBDIR}
        ARCHIVE DESTINATION  ${CMAKE_INSTALL_LIBDIR}
        INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${library_name}
    ) 

    message(STATUS "-------=======End=======-------")
endfunction()
