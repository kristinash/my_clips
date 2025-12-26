def process_ingredients(input_file, output_file):
    try:
        with open(input_file, 'r', encoding='utf-8') as f:
            lines = f.readlines()

        clips_facts = []
        for line in lines:
            line = line.strip()
            
            # Пропускаем комментарии, пустые строки и заголовки
            if not line or line.startswith('#'):
                continue
            
            # Разделяем id и название
            if ';' in line:
                parts = line.split(';')
                name = parts[1].strip()
                # Формируем структуру CLIPS
                clips_facts.append(f'    (ingredient (name "{name}"))')

        # Сохраняем результат в файл
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(";\n; Автоматически сгенерированные ингредиенты\n;\n")
            f.write("\n".join(clips_facts))
            
        print(f"Успешно! Обработано строк: {len(clips_facts)}")
        print(f"Результат сохранен в: {output_file}")

    except FileNotFoundError:
        print("Ошибка: Исходный файл не найден.")
    except Exception as e:
        print(f"Произошла ошибка: {e}")

# Запуск
process_ingredients('facts.txt', 'f.clp')