@echo off
sc stop wuauserv
sc stop bits
sc stop dosvc
SLEEP 5
sc config wuauserv start=disabled
del c:\windows\SoftwareDistribution /q /s
