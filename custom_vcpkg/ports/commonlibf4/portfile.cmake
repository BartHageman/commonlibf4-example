vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO Ryan-rsm-McKenzie/CommonLibF4
  REF cdd932ad1f4e37f33c28ea7d7e429428f5be43dd
  SHA512 fd72180dbecb8145547100e77d39de95400e944c66849ddcf6fdf349c65324551cd8316f25fb70543d0b724fd4241f9f935c4e239efbd4136662a490413d2185
  HEAD_REF master
)
# There's no way to select cmake presets with vcpkg currently, so we have to copy all the params from them.
if ( VCPKG_HOST_IS_WINDOWS AND VCPKG_TARGET_IS_WINDOWS AND NOT VCPKG_TARGET_IS_MINGW AND DEFINED $ENV{VisualStudioVersion} )
  # Ignoring this from presets
  # set( MSVC_RUNTIME_VCPKG_CONFIG_ARG "-DCMAKE_MSVC_RUNTIME_LIBRARY=\"MultiThreaded$<$<CONFIG:Debug>:Debug>DLL\"")
  # VS2022
  if ( $ENV{VisualStudioVersion} STREQUAL "17.0")
    set( CXX_FLAGS_VCPKG_CONFIG_ARG "-DCMAKE_CXX_FLAGS=\"/EHsc /MP /W4 /WX /external:anglebrackets /external:W0\"")
  else()
    set( CXX_FLAGS_VCPKG_CONFIG_ARG "-DCMAKE_CXX_FLAGS=\"/EHsc /MP /W4 /WX /external:W0\"")
  endif()  
else()
  set( MSVC_RUNTIME_VCPKG_CONFIG_ARG "")
  set( CXX_FLAGS_VCPKG_CONFIG_ARG "")
endif()

vcpkg_configure_cmake(
  SOURCE_PATH "${SOURCE_PATH}"
  OPTIONS
    -DVCPKG_OVERLAY_PORTS="${SOURCE_PATH}/cmake/ports/"
    # Ignoring these from presets
    # -DBoost_USE_STATIC_LIBS=ON
    # -DBoost_USE_STATIC_RUNTIME=OFF
    -DCMAKE_EXE_LINKER_FLAGS_RELEASE="/DEBUG:FASTLINK"
    PREFER_NINJA
    # ${MSVC_RUNTIME_VCPKG_CONFIG_ARG}
    ${CXX_FLAGS_VCPKG_CONFIG_ARG}
    MAYBE_UNUSED_VARIABLES VCPKG_OVERLAY_PORTS
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup(
  PACKAGE_NAME CommonLibF4
  CONFIG_PATH "lib/cmake/CommonLibF4"
)
file(GLOB CMAKE_CONFIGS "${CURRENT_PACKAGES_DIR}/share/CommonLibF4/CommonLibF4/*.cmake")
file(INSTALL ${CMAKE_CONFIGS} DESTINATION "${CURRENT_PACKAGES_DIR}/share/CommonLibF4")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/CommonLibF4/CommonLibF4")

file(
  INSTALL "${SOURCE_PATH}/LICENSE"
  DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
  RENAME copyright)
