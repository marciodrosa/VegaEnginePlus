:: args:
set _configuration=%1

:: input:
set _scriptspath=..\script
set _contentpath=..\content
set _vegapath=..\..\VegaSDK

:: output:
set _outputpath=%_configuration%
set _scriptsoutputpath=%_outputpath%\script
set _contentoutputpath=%_outputpath%\content

:: other:
set _vegadlls=libjpeg-8.dll libpng15-15.dll libtiff-5.dll libwebp-2.dll lua52.dll SDL.dll SDL_image.dll zlib1.dll

:: start:
echo "Starting post build of Lua SDK..."

:: remove old dirs and create new ones:
echo "Create directories on output dir..."
if exist "%_scriptsoutputpath%" rd /s /q "%_scriptsoutputpath%"
if exist "%_contentoutputpath%" rd /s /q "%_contentoutputpath%"
md "%_scriptsoutputpath%"
md "%_contentoutputpath%"

:: copy and compile Lua scripts:
echo "Moving and compiling Lua scripts..."
robocopy "%_scriptspath%" "%_scriptsoutputpath%" /e
robocopy "%_vegapath%\script\vega" "%_scriptsoutputpath%\vega" /e
forfiles /p %_scriptsoutputpath%\ /m *.lua /s /c "luac luac -o @path @path"

:: copy content files:
echo "Moving content dir..."
robocopy "%_contentpath%" "%_contentoutputpath%" /e

:: copy DLLs:
echo "Moving DLLs..."
robocopy "%_vegapath%\windows\lib" "%_outputpath%" %_vegadlls%

:: finished:
echo "Post build of Lua SDK finished."