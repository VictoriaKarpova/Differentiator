# Differentiator
В данном репозитории представлены файлы, необходимый прохождения всех этапов разработки цифровой интегральной схемы широкополосного дифференциатора. 
Дифференциатор обладает следующими характеристиками:

•	Полоса пропускания равна 0.8;

•	Неравномерность в полосе пропускания не более 0.1 дБ;

•	Разрядность входных и выходных отсчётов равна 20;

•	Абсолютная погрешность относительно точности «double» – 2 LSB;

•	Относительная погрешность относительно точности «double» – 0,1%;

Репозиторий состоит из двух веток, текущей "current" и главной "main", а также содержит файл README.md c описанием проекта.
Ниже приведено описание всех файлов, содержащихся в репозитории.
| Наименование файла	| Описане |
|---------------------|---------|
| Filter_test_24.v | Описание цифрового устройства на языке Verilog HDL, основной модуль |
| Filter_test_24_tb.v | Testbench для этапа Behavioral level |
| Filter_test_24_layout.v	| Testbench для моделирования после Layout |
| Input1.dat | Файл с отсчётами входного сигнала |
| Output1_expected.dat	| Файл с ожидаемыми отсчётами выходного сигнала |
| Diff1.sdc	| Файл временных ограничений |
| Diff2.sdc	| Файл временных ограничений |
| MyModule_synth_typ.tcl	| Файл для логического синтеза для typical corner |
| MyModule_synth_slow.tcl	| Файл для логического синтеза для slow corner |
| MyModule_synth_fast.tcl	| Файл для логического синтеза для fast corner |
| X-FAB_typ.tcl	| Вспомогательный tcl-файл с путями на библиотеку цифровых ячеек для typical corner |
| X-FAB_slow.tcl	| Вспомогательный tcl-файл с путями на библиотеку цифровых ячеек для slow corner |
| X-FAB_fast.tcl	| Вспомогательный tcl-файл с путями на библиотеку цифровых ячеек для fast corner |
| MMMC.tcl	| MMMC-файл для описания Corners |
| Module_pins	| Файл привязки пинов |
| Filter_test_24_PaR.tcl	| Файл для генерации топологии |

_________
Для создания цифровой интегальной схемы широкополосного дифференциатора необходимо пройти три этапа:
1)	Составление описания цифрового устройствана языке Verilog (Behavioral level);
2)	Логический синтез (Synthesis);
3)	Генерация топологии (Layout).

При этом после каждого этапа необходимо проводить моделирование с помощью Cadence Incisive.

___________
Для моделирования на функциональном уровне необходимо создать папку Incisive, перейти в эту папку и через терминал запустить команду Incisive.

Для моделирования Вам понадобятся следующие файлы:

*	`../Source/Filter_test_24.v`

*	`../Source/Filter_test_24_tb.v`

*	`../Source/Input.dat`

*	`../Source/Output_expected.dat`

___________
Для проведения логического синтеза необходимо создать папку RTL_Compiler, перейти в эту папку и через ввести в терминал одну из следующих команд:

* 	`../Scripts/MyModule_syn.tcl (для типичного случая)`

* 	`../Scripts/MyModule_syn_slow.tcl (для наихудшего случая)`

* 	`../Scripts/MyModule_syn_fast.tcl (для наилучшего случая)` 

Полученные Timing и Area Reports можно посмотреть в папке ../Reports/RTL_Compiler.
Полученные результаты синтеза находятся в папке ../Outputs/RTL_Compiler.

____________
Для моделирования на уровне ячеек библиотек необходимо создать папку Incisive, перейти в эту папку и через терминал запустить команду Incisive.
Для моделирования Вам понадобятся следующие файлы:

*	 `../Source/Filter_test_24.v`

*	 `../Source/Filter_test_24_tb.v`

*	 `../Source/Input.dat`

*	 `../Source/Output_expected.dat`

______________
Для генерации топологии необходимо создать папку Encounter, перейти в эту папку и через ввести через терминал следующую команду:
`../Source/Scripts/Filter_test_24_PaR.tcl`

Полученные временные отчеты, а также результаты проверок можно посмотреть в папке ../Reports/Encounter.
Полученные результаты генерации топологии находятся в папке ../Outputs/Encounter.

__________________
Для моделирования с учетом топологии необходимо создать папку Incisive, перейти в эту папку и через терминал запустить команду Incisive.
Для моделирования Вам понадобятся следующие файлы:

*	 `../Source/Filter_test_24.v`

*	 `../Source/Filter_test_24_tb_layout.v`

*	 `../Source/Input.dat`

*	 `../Source/Output_expected.dat`
___________
Для прохождения LVS и DRC проверок необходимо выполнить следующие действия:
1) Создать папку Virtuoso и перейти в нее
2) Через терминал запустить команду Virtuoso
3) Создать библиотеку Virtuoso1
4) Импортировать файл Outputs/Encounter/Physical_netlist.v
5) Импортировать файл Outputs/Encounter/Filter_test_24.def
6) Запустить DRC и LVS анализ
