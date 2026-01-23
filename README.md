Example for [this post](https://stackoverflow.com/questions/79872574/msvc-linker-lnk2011-error-but-with-symbol-present).

UPD:

SOLVED!

For some uncertain reason, the `LPLOGGER_LIBRARY` definition were falling through from `lpLogger`'s `CMakeLists.txt` into `QtCommonTools`. Thus, `QtCommonTools` `__dllexport`'ed static fields of all Qt classes (i.e. all `Q_OBJECT` macros) instead of `__dllimport`'ing them. But these static fields had no implementation, just as linker said, because implementations from `lpLogger.dll` were ignored (no `__dllimport`). And so, doing some word magic around `target_compile_definitions` did the trick.

Still, it is unclear to me, why was the `LPLOGGER_LIBRARY` definition passed through. `common.cmake` only uses  `target_compile_definitions` macro, which only affects the current project. And `PRIVATE_DEFINE` variable were of local scope.

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

Tested in QtCreator and Visual Studio Code.

CMake:
   * MinGW build [OK]
   * MSVC build `error LNK2001: unresolved external symbol "public: static struct QMetaObject const lpLogger::staticMetaObject" (?staticMetaObject@lpLogger@@2UQMetaObject@@b)`

qmake:
   * MinGW build [OK]
   * MSVC build [OK]

The successful qmake `link.exe` command be like
```
set Qt=C:\qt\6.9.0\msvc2022_64
link.exe /NOLOGO /DYNAMICBASE /NXCOMPAT /DEBUG /DLL /SUBSYSTEM:WINDOWS /MANIFEST:embed /OUT:lpLibs\QtCommonTools\debug\QtCommonTools.dll lpLibs\QtCommonTools\debug\utils.obj lpLibs\lpLogger\debug\lpLogger.lib %Qt%\lib\Qt6Guid.lib %Qt%\lib\Qt6Cored.lib
```
VSCode generates something like
```
set Qt=C:\qt\6.9.0\msvc2022_64
link.exe /nologo lpLibs\QtCommonTools\CMakeFiles\QtCommonTools.dir\Debug\QtCommonTools_autogen\mocs_compilation_Debug.cpp.obj lpLibs\QtCommonTools\CMakeFiles\QtCommonTools.dir\Debug\src\utils.cpp.obj /out:lpLibs\QtCommonTools\Debug\QtCommonTools.dll /implib:lpLibs\QtCommonTools\Debug\QtCommonTools.lib /pdb:lpLibs\QtCommonTools\Debug\QtCommonTools.pdb /dll /version:0.0 /machine:x64 /debug /INCREMENTAL %Qt%\lib\Qt6Networkd.lib lpLibs\lpLogger\Debug\lpLogger.lib %Qt%\lib\Qt6Cored.lib ws2_32.lib mpr.lib userenv.lib kernel32.lib user32.lib gdi32.lib winspool.lib shell32.lib ole32.lib oleaut32.lib uuid.lib comdlg32.lib advapi32.lib /MANIFEST /MANIFESTFILE:lpLibs\QtCommonTools\CMakeFiles\QtCommonTools.dir\Debug/intermediate.manifest lpLibs\QtCommonTools\CMakeFiles\QtCommonTools.dir\Debug/manifest.res
```
