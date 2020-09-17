file(GLOB BASE_SRC "*.cpp" "../external/imgui/*.cpp")
file(GLOB BASE_HEADERS "*.hpp")

if(WIN32)
    add_library(base STATIC ${BASE_SRC} ${BASE_HEADERS})
    target_link_libraries(base ${Vulkan_LIBRARY} ${ASSIMP_LIBRARIES} ${WINLIBS})
elseif(APPLE)
    set(BASE_SRC
        ${BASE_SRC}
        macOSMain.mm
        DemoView.mm
    )
    set(BASE_HEADERS
        ${BASE_SRC}
        DemoView.h
    )
    add_library(base STATIC ${BASE_SRC} ${BASE_HEADERS})
    target_link_libraries(base ${Vulkan_LIBRARY} ${ASSIMP_LIBRARIES} ${XCB_LIBRARIES} ${WAYLAND_CLIENT_LIBRARIES} ${CMAKE_THREAD_LIBS_INIT})
else(WIN32)
    add_library(base STATIC ${BASE_SRC} ${BASE_HEADERS})
    target_link_libraries(base ${Vulkan_LIBRARY} ${ASSIMP_LIBRARIES} ${XCB_LIBRARIES} ${WAYLAND_CLIENT_LIBRARIES} ${CMAKE_THREAD_LIBS_INIT})
endif(WIN32)