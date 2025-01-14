
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// **ИП Создать поле ввода контактное лицо
	ПолеВвода = Элементы.Добавить("КонтактноеЛицо",Тип("ПолеФормы"),Элементы.ГруппаШапкаПраво);
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПутьКДанным = "Объект.ИП_КонтактноеЛицо"; 
	
	//Добавление группы скидок на форму
	Группа = Элементы.Добавить("ИП_ГруппаСкидки",Тип("ГруппаФормы"),Элементы.ГруппаШапкаЛево);
	Группа.Вид = ВидГруппыФормы.ОбычнаяГруппа; 
	
	//Добавить поле ввода скидки
	ПолеВвода = Элементы.Добавить("СогласованнаяСкидка",Тип("ПолеФормы"),Элементы["ИП_ГруппаСкидки"]);
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПутьКДанным = "Объект.ИП_СогласованнаяСкидка";
	
	//Добавление команды пересчета скидок на форму
	Команда = Команды.Добавить("ИП_ПересчитатьСумму");
	Команда.Заголовок = "Пересчитать сумму";
	Команда.Картинка = БиблиотекаКартинок.Перечитать;
	Команда.Действие = "ИП_ПересчитатьСуммуНажатие";
	
	Кнопка = Элементы.Добавить("ИП_ПересчитатьСуммуНажатие",Тип("КнопкаФормы"),Элементы["ИП_ГруппаСкидки"]);
	Кнопка.ИмяКоманды = "ИП_ПересчитатьСумму";
	Кнопка.Вид = ВидКнопкиФормы.ОбычнаяКнопка;	 
	Кнопка.Отображение = ОтображениеКнопки.КартинкаИТекст;
	// ИП**
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
    ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
КонецПроцедуры

#КонецОбласти



#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура РассчитатьСуммуСтроки(ТекущиеДанные)
	// **ИП Внести возможность использования скидки
	//ТекущиеДанные.Сумма = ТекущиеДанные.Цена * ТекущиеДанные.Количество;
	ТекущиеДанные.Сумма = ТекущиеДанные.Цена * ТекущиеДанные.Количество-((ТекущиеДанные.Цена * ТекущиеДанные.Количество)/100)*Объект.ИП_СогласованнаяСкидка;
	//ИП**
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

&НаКлиенте
Асинх Процедура ИП_ПересчитатьСуммуНажатие()
	Обещание = ВопросАсинх("Пересчитать сумму документа?",РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	Результат = Ждать обещание;
	Если Результат = КодВозвратаДиалога.Да Тогда
		Для Каждого Строка из Объект.Товары Цикл
			Строка.Сумма = Строка.Цена*Строка.Количество-((Строка.Цена*Строка.Количество)/100)*Объект.ИП_СогласованнаяСкидка; 
		КонецЦикла;
	Иначе
		возврат;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура РассчитатьСуммуДокумента()
	
	Объект.СуммаДокумента = Объект.Товары.Итог("Сумма") + Объект.Услуги.Итог("Сумма");
	
КонецПроцедуры

#Область ПодключаемыеКоманды

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
    ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
    ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти  

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыПриИзменении(Элемент)
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	РассчитатьСуммуСтроки(ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСкидкаПриИзменении(Элемент)
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	РассчитатьСуммуСтроки(ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	РассчитатьСуммуСтроки(ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
		РассчитатьСуммуДокумента();
КонецПроцедуры



#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУслуги


&НаКлиенте
Процедура УслугиПриИзменении(Элемент)
	РассчитатьСуммуДокумента();
КонецПроцедуры

&НаКлиенте
Процедура УслугиКоличествоПриИзменении(Элемент)
		ТекущиеДанные = Элементы.Услуги.ТекущиеДанные;
	
	РассчитатьСуммуСтроки(ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура УслугиЦенаПриИзменении(Элемент)
	ТекущиеДанные = Элементы.Услуги.ТекущиеДанные;
	
	РассчитатьСуммуСтроки(ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура УслугиСкидкаПриИзменении(Элемент)
	ТекущиеДанные = Элементы.Услуги.ТекущиеДанные;
	
	РассчитатьСуммуСтроки(ТекущиеДанные);
КонецПроцедуры



#КонецОбласти





