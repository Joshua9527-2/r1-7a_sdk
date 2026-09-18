cmake_minimum_required(VERSION 3.10)
project(r1_arm LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin)

find_package(Threads REQUIRED)

# ----- IM6014 motor_controller (vendored) -----
set(MOTOR_CONTROLLER_ROOT ${CMAKE_SOURCE_DIR}/thirdparty/motor_controller)
find_library(MOTOR_CONTROLLER_LIB motor_controller
  PATHS ${MOTOR_CONTROLLER_ROOT}/lib NO_DEFAULT_PATH REQUIRED)

add_executable(test_arm_lowlevel
  src/test_arm_lowlevel.cpp
  src/arm_motor_bus.cpp
)
add_executable(calibrate_joints
  src/calibrate_joints.cpp
  src/arm_motor_bus.cpp
)

foreach(tgt test_arm_lowlevel calibrate_joints)
  target_include_directories(${tgt} PRIVATE
    ${CMAKE_SOURCE_DIR}/include
    ${MOTOR_CONTROLLER_ROOT}/include
  )
  target_link_directories(${tgt} PRIVATE ${MOTOR_CONTROLLER_ROOT}/lib)
  target_link_libraries(${tgt} PRIVATE
    ${MOTOR_CONTROLLER_LIB}
    Threads::Threads
  )
  target_compile_definitions(${tgt} PRIVATE MOTOR_CONTROLLER_SHARED)
endforeach()

set_target_properties(test_arm_lowlevel calibrate_joints PROPERTIES
  BUILD_RPATH "${MOTOR_CONTROLLER_ROOT}/lib"
  INSTALL_RPATH "$ORIGIN/../thirdparty/motor_controller/lib"
)
