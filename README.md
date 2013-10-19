Vega SDK
==================

2D game engine for mobile devices made with C++ and LUA.

(Earlier, I had named it "Vega Engine Plus", so some files can appear with this name, but it is a deprecated alias.)

-------------------------------

Folder structure explanation:

- src: C++ source files
- include: C++ header files
- script: Lua scripts
  - test: unit tests of Lua scripts
  - vega: scripts of the Vega SDK
- samples: C++ header and source files for samples
- android, ios, windows: projects, libraries and binaries for each platform (main project, unit tests and samples)

-------------------------------

External libraries:
- GLFW: http://www.glfw.org
- lodepng: http://lodev.org/lodepng