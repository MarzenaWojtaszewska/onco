@echo off
setlocal EnableDelayedExpansion

pushd %~dp0
set script_dir=%CD%
popd

mkdir %script_dir%\output\
mkdir %script_dir%\input\


echo Ustawiam KATALOG ROBOCZY na: %script_dir%



set /p date=WPISZ BIEZACA DATE W FORMACIE YYYYMMDD :


cd %script_dir%\input

echo Tworze katalog dla plikow wynikowych %script_dir%\output\%date%

timeout 5 >nul

mkdir %script_dir%\output\%date%

echo Rozpoczynam analize plikow z katalogu cd %script_dir%\input

timeout 5 >nul


for %%G in (*.fastq.gz) do (
	set "filename=%%G"
        echo !filename!
        for /f "tokens=1-4 delims=_" %%a in ("%%G") do (
  	if "%%d" == "R1" ( 
        java -jar %script_dir%\mixcr.jar align -p exom-full-length --species hsa --report %%a_%%b_%%c_report %%a_%%b_%%c_R1_001.fastq.gz %%a_%%b_%%c_R2_001.fastq.gz %%a_%%b_%%c.vdjca
        java -jar %script_dir%\mixcr.jar assemble --write-alignments %%a_%%b_%%c.vdjca %%a_%%b_%%c.clones.clna -f
        java -jar %script_dir%\mixcr.jar assembleContigs %%a_%%b_%%c.clones.clna  %%a_%%b_%%c.clones.clns -f
        java -jar %script_dir%\mixcr.jar exportClones %%a_%%b_%%c.clones.clns  %%a_%%b_%%c.clones.tsv -f
        mkdir "%script_dir%\output\%date%\%%a_%%b_%%c
        MOVE "%script_dir%\input\%%a_%%b_%%c_report" "%script_dir%\output\%date%\%%a_%%b_%%c\%%a_%%b_%%c_report"
        MOVE "%script_dir%\input\%%a_%%b_%%c.clones_IGH.tsv" "%script_dir%\output\%date%\%%a_%%b_%%c\%%a_%%b_%%c.clones_IGH.tsv"
        MOVE "%script_dir%\input\%%a_%%b_%%c_R1_001.fastq.gz" "%script_dir%\output\%date%\%%a_%%b_%%c\%%a_%%b_%%c_R1_001.fastq.gz"
        MOVE "%script_dir%\input\%%a_%%b_%%c_R2_001.fastq.gz" "%script_dir%\output\%date%\%%a_%%b_%%c\%%a_%%b_%%c_R2_001.fastq.gz"
        del "%script_dir%\input\%%a_%%b_%%c.vdjca
        del "%script_dir%\input\%%a_%%b_%%c.clones.clna
        del "%script_dir%\input\%%a_%%b_%%c.clones.clns
     )
 
   )

)

echo PRZETWARZANIE PLIKOW ZAKONCZONE. KATALOG %script_dir%\input POWINIEN BYC PUSTY. JEZELI ZNAJDUJA SIE W NIM PLIKI NIE ZOSTALY ONE PRZETWORZONE.

pause