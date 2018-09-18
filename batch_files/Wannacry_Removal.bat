@echo off

::Cleanup

.\taskkill /f /im mssecsvc.exe
del /a C:\Windows\mssecsvc.exe C:\Windows\qeriuwjhrf  C:\Windows\tasksche.exe

sc stop mssecsvc2.0
sc delete mssecsvc2.0