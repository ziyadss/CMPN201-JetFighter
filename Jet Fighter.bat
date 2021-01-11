@start util\DOSBox.exe -conf conf\port1.conf -c "mount M: '%~dp0''" -c "M:" -c "cd build" -c "del main.obj" -c "del main.exe" -c "..\util\masm.exe ..\asm\main.asm;" -c "..\util\link.exe main.obj;" -c "main.exe"
timeout 10
@start util\DOSBox.exe -conf conf\port2.conf -c "mount M: '%~dp0''" -c "M:" -c "cd build" -c "main.exe"