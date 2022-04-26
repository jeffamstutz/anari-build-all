## Copyright 2022 Jefferson Amstutz
## SPDX-License-Identifier: Unlicense

superbuild_subproject(
  NAME OSPRay
  URL "https://github.com/jeffamstutz/superbuild_ospray/archive/refs/heads/main.zip"
  SKIP_INSTALL_COMMAND
)

superbuild_subproject(
  NAME ANARI-OSPRay
  URL "https://github.com/ospray/anari-ospray/archive/b4d2030c3f367bb91f75c2c83e7f9ffc12be7610.zip"
  DEPENDS_ON ANARI-SDK OSPRay
)
