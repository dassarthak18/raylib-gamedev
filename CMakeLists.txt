cmake_minimum_required(VERSION 3.15)
project(${PROJECT_NAME})

message(STATUS "Project root is: ${CMAKE_SOURCE_DIR}")
set(CMAKE_CXX_STANDARD 17)

add_executable(${PROJECT_NAME}
                src/main.cpp
)

include_directories(${CMAKE_SOURCE_DIR}/bin/include)

target_link_libraries(${PROJECT_NAME}
    ${CMAKE_SOURCE_DIR}/bin/lib/libraylib.a
    ${CMAKE_SOURCE_DIR}/bin/lib/libbox2d.a
    ${CMAKE_SOURCE_DIR}/bin/lib/libJolt.a
    opengl32
    gdi32
    winmm
)
