using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using System.Text.RegularExpressions;
using System.Linq;
using System.Globalization;
using CLIPSNET; // Библиотека экспертной системы
using System.IO;

namespace ClipsFormsExample
{
    public partial class ClipsFormsExample : Form
    {
        // Явное указание пространства имен для устранения неоднозначности
        private CLIPSNET.Environment clips = new CLIPSNET.Environment();
        private string loadedFilePath = "";

        public ClipsFormsExample()
        {
            InitializeComponent();
            SetupListViews();
        }

        private void SetupListViews()
        {
            // Настройка таблицы выбора ингредиентов
            listView1.View = View.Details;
            listView1.CheckBoxes = true;
            listView1.FullRowSelect = true;
            listView1.Columns.Clear();
            listView1.Columns.Add("Ингредиент", 200);
            listView1.Columns.Add("Наличие", 70);

            // Настройка таблицы результатов
            listView2.View = View.Details;
            listView2.FullRowSelect = true;
            listView2.Columns.Clear();
            listView2.Columns.Add("Блюдо / Продукт", 200);
            listView2.Columns.Add("Уверенность (CF)", 110);
        }

        #region Вспомогательные методы (Кодировка и Очистка)

        // Исправляет "кракозябры", переводя системную кодировку в UTF-8
        private string DecodeClipsString(string text)
        {
            if (string.IsNullOrEmpty(text)) return "";
            try
            {
                byte[] bytes = Encoding.Default.GetBytes(text);
                return Encoding.UTF8.GetString(bytes);
            }
            catch { return text; }
        }

        // Удаляет лишние символы из кода CLIPS перед парсингом
        private string CleanTextContent(string text)
        {
            if (string.IsNullOrEmpty(text)) return text;
            if (text.StartsWith("\ufeff")) text = text.Substring(1);
            return Regex.Replace(text, @"[\u0000-\u0008\u000B\u000C\u000E-\u001F]", "");
        }

        #endregion

        #region Обработка файлов

        private void openFile_Click(object sender, EventArgs e)
        {
            if (clipsOpenFileDialog.ShowDialog() == DialogResult.OK)
            {
                try
                {
                    loadedFilePath = clipsOpenFileDialog.FileName;
                    string content = File.ReadAllText(loadedFilePath, Encoding.UTF8);
                    codeBox.Text = CleanTextContent(content);

                    ParseClipsFile(content);
                    outputBox.Text = "Файл успешно загружен: " + Path.GetFileName(loadedFilePath) + "\r\n";
                    outputBox.AppendText("Выберите ингредиенты и нажмите 'Дальше'." + "\r\n");
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Ошибка при чтении файла: " + ex.Message);
                }
            }
        }

        private void ParseClipsFile(string text)
        {
            listView1.Items.Clear();
            listView2.Items.Clear();

            // Поиск всех определений ингредиентов в файле
            var matches = Regex.Matches(text, @"\(ingredient\s+\(name\s+""([^""]+)""\)", RegexOptions.IgnoreCase);
            var uniqueNames = new HashSet<string>();

            foreach (Match match in matches)
            {
                uniqueNames.Add(match.Groups[1].Value);
            }

            foreach (var name in uniqueNames)
            {
                // Исходный список для выбора
                var lvi1 = new ListViewItem(name);
                lvi1.SubItems.Add("");
                listView1.Items.Add(lvi1);

                // Правый список для отображения CF
                var lvi2 = new ListViewItem(name);
                lvi2.SubItems.Add("0.00");
                listView2.Items.Add(lvi2);
            }
        }

        #endregion

        #region Логика работы с CLIPS

        private void nextBtn_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(loadedFilePath))
            {
                MessageBox.Show("Загрузите файл .clp!");
                return;
            }

            try
            {
                outputBox.Clear();
                outputBox.AppendText("=== ЗАПУСК ЭКСПЕРТНОЙ СИСТЕМЫ ===" + "\r\n\r\n");

                clips.Clear();
                clips.Load(loadedFilePath);
                clips.Reset();

                // 1. Отправка фактов на основе выбранных пунктов
                foreach (ListViewItem item in listView1.Items)
                {
                    if (item.Checked)
                    {
                        clips.Eval($"(assert (input-question (name \"{item.Text}\") (certainty 1.0)))");
                    }
                }

                // 2. Запуск логического вывода
                long rulesCount = clips.Run();
                outputBox.AppendText("Правил сработало: " + rulesCount + "\r\n");
                outputBox.AppendText("------------------------------------------------" + "\r\n");

                // 3. Вывод сообщений из ioproxy (с отступами)
                ShowProxyLogs();

                // 4. Обновление таблицы результатов (без кракозябр)
                UpdateResultsTable();
            }
            catch (Exception ex)
            {
                outputBox.AppendText("ОШИБКА: " + ex.Message + "\r\n");
            }
        }

        private void ShowProxyLogs()
        {
            // Ищем факт прокси, где копятся сообщения
            string evalStr = "(find-fact ((?f ioproxy)) TRUE)";
            var matches = (MultifieldValue)clips.Eval(evalStr);

            if (matches.Count > 0)
            {
                FactAddressValue proxy = (FactAddressValue)matches[0];
                MultifieldValue msgs = (MultifieldValue)proxy["messages"];

                if (msgs.Count > 0)
                {
                    outputBox.AppendText("ОТЧЕТ О ПРИГОТОВЛЕНИИ:" + "\r\n");
                    for (int i = 0; i < msgs.Count; i++)
                    {
                        // Применяем декодирование и добавляем отступ в 5 пробелов
                        string cleanMsg = DecodeClipsString(msgs[i].ToString().Trim('"'));
                        outputBox.AppendText("     " + cleanMsg + "\r\n");
                    }
                }
            }
            else
            {
                outputBox.AppendText("Система не вернула текстовых уведомлений." + "\r\n");
            }
        }

        private void UpdateResultsTable()
        {
            listView2.Items.Clear();

            // Получаем все ингредиенты, у которых CF > 0
            var results = (MultifieldValue)clips.Eval("(find-all-facts ((?f ingredient)) (> ?f:certainty 0))");

            outputBox.AppendText("\r\n" + "ФИНАЛЬНЫЕ КОЭФФИЦИЕНТЫ:" + "\r\n");

            for (int i = 0; i < results.Count; i++)
            {
                FactAddressValue f = (FactAddressValue)results[i];

                string rawName = f["name"].ToString().Trim('"');
                string name = DecodeClipsString(rawName);

                double cf = double.Parse(f["certainty"].ToString(), CultureInfo.InvariantCulture);

                // Добавление в таблицу
                ListViewItem item = new ListViewItem(name);
                item.SubItems.Add(cf.ToString("F2"));

                // Зеленый фон для успешно приготовленных блюд (высокий CF)
                if (cf >= 0.7) item.BackColor = System.Drawing.Color.LightGreen;
                listView2.Items.Add(item);

                // Дублируем важные результаты в текстовое поле
                outputBox.AppendText("   -> " + name + " [CF = " + cf.ToString("F2") + "]\r\n");
            }

            outputBox.AppendText("\r\n" + "=== ОБРАБОТКА ЗАВЕРШЕНА ===" + "\r\n");
        }

        #endregion

        #region Интерфейсные события

        private void listView1_ItemCheck(object sender, ItemCheckEventArgs e)
        {
            // Обновление галочки во второй колонке через Invoke
            this.BeginInvoke(new MethodInvoker(() => {
                if (e.Index < listView1.Items.Count)
                    listView1.Items[e.Index].SubItems[1].Text = e.NewValue == CheckState.Checked ? "✓" : "";
            }));
        }

        private void resetBtn_Click(object sender, EventArgs e)
        {
            foreach (ListViewItem item in listView1.Items) item.Checked = false;
            listView2.Items.Clear();
            outputBox.Clear();
            outputBox.Text = "Система сброшена." + "\r\n";
        }

        private void saveAsButton_Click(object sender, EventArgs e)
        {
            if (clipsSaveFileDialog.ShowDialog() == DialogResult.OK)
            {
                File.WriteAllText(clipsSaveFileDialog.FileName, codeBox.Text, Encoding.UTF8);
            }
        }

        #endregion
    }
}