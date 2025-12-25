using CLIPSNET;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Windows.Forms;

namespace ClipsFormsExample
{
    public partial class ClipsFormsExample : Form
    {
        private CLIPSNET.Environment clips = new CLIPSNET.Environment();
        private List<string> loadedFilePaths = new List<string>();
        private Dictionary<string, double> ingredientCFValues = new Dictionary<string, double>();
        private bool isEditing = false;
        private CultureInfo invariantCulture = CultureInfo.InvariantCulture;
        private CultureInfo uiCulture = CultureInfo.CurrentUICulture; // Для отображения в UI

        public ClipsFormsExample()
        {
            InitializeComponent();
            SetupListViews();
        }

        private void SetupListViews()
        {
            listView1.View = View.Details;
            listView1.CheckBoxes = true;
            listView1.FullRowSelect = true;
            listView1.Columns.Clear();
            listView1.Columns.Add("Ингредиент", 90);
            listView1.Columns.Add("Уверенность (-1...1)", 120);

            listView2.View = View.Details;
            listView2.FullRowSelect = true;
            listView2.Columns.Clear();
            listView2.Columns.Add("Блюдо / Продукт", 90);
            listView2.Columns.Add("Уверенность (CF)", 110);
        }

        #region Вспомогательные методы

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

        private string CleanTextContent(string text)
        {
            if (string.IsNullOrEmpty(text)) return text;
            if (text.StartsWith("\ufeff")) text = text.Substring(1);
            return Regex.Replace(text, @"[\u0000-\u0008\u000B\u000C\u000E-\u001F]", "");
        }

        // Корректное преобразование числа в строку для CLIPS (всегда с точкой)
        private string ToClipsNumberString(double value)
        {
            return value.ToString("F6", invariantCulture);
        }

        // Корректное преобразование числа для отображения в UI
        private string ToDisplayNumberString(double value)
        {
            return value.ToString("F2", uiCulture);
        }

        // Корректное преобразование строки в число с учетом разных форматов
        private double ParseNumberString(string text)
        {
            if (string.IsNullOrWhiteSpace(text))
                return 1.0;

            // Пробуем разные форматы
            text = text.Trim().Replace(',', '.'); // Заменяем запятые на точки

            if (double.TryParse(text, NumberStyles.Any, invariantCulture, out double result))
            {
                return Math.Max(-1.0, Math.Min(1.0, result));
            }

            return 1.0; // Значение по умолчанию при ошибке
        }

        #endregion

        #region Обработка файлов

        private void openFile_Click(object sender, EventArgs e)
        {
            clipsOpenFileDialog.Multiselect = true; // Разрешаем выбор нескольких файлов
            if (clipsOpenFileDialog.ShowDialog() == DialogResult.OK)
            {
                try
                {
                    // Очищаем предыдущие данные при новой загрузке группы файлов
                    loadedFilePaths.Clear();
                    loadedFilePaths.AddRange(clipsOpenFileDialog.FileNames);

                    codeBox.Clear();
                    StringBuilder combinedContent = new StringBuilder();

                    foreach (string filePath in loadedFilePaths)
                    {
                        string content = File.ReadAllText(filePath, Encoding.UTF8);
                        combinedContent.AppendLine($";; --- ФАЙЛ: {Path.GetFileName(filePath)} ---");
                        combinedContent.AppendLine(CleanTextContent(content));
                        combinedContent.AppendLine();
                    }

                    codeBox.Text = combinedContent.ToString();
                    ParseClipsFile(codeBox.Text); // Парсим объединенный текст для поиска ингредиентов

                    outputBox.Text = $"Загружено файлов: {loadedFilePaths.Count}\r\n";
                    foreach (var path in loadedFilePaths)
                        outputBox.AppendText($"- {Path.GetFileName(path)}\r\n");

                    outputBox.AppendText("\r\nВыберите ингредиенты и нажмите 'Дальше'.\r\n");
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Ошибка при чтении файлов: " + ex.Message);
                }
            }
        }

        private void ParseClipsFile(string text)
        {
            listView1.Items.Clear();
            listView2.Items.Clear();
            ingredientCFValues.Clear();

            var matches = Regex.Matches(text, @"\(ingredient\s+\(name\s+""([^""]+)""\)", RegexOptions.IgnoreCase);
            var uniqueNames = new HashSet<string>();

            foreach (Match match in matches)
            {
                uniqueNames.Add(match.Groups[1].Value);
            }

            foreach (var name in uniqueNames)
            {
                ingredientCFValues[name] = 1.0;

                var lvi1 = new ListViewItem(name);
                lvi1.SubItems.Add("");
                listView1.Items.Add(lvi1);

                var lvi2 = new ListViewItem(name);
                lvi2.SubItems.Add("0.00");
                listView2.Items.Add(lvi2);
            }
        }

        #endregion

        #region Логика работы с CLIPS

        private void nextBtn_Click(object sender, EventArgs e)
        {
            if (loadedFilePaths.Count == 0)
            {
                MessageBox.Show("Загрузите хотя бы один файл .clp!");
                return;
            }

            try
            {
                outputBox.Clear();
                outputBox.AppendText("=== ЗАПУСК ЭКСПЕРТНОЙ СИСТЕМЫ ===" + "\r\n\r\n");

                clips.Clear();

                // ПОСЛЕДОВАТЕЛЬНАЯ ЗАГРУЗКА
                foreach (string filePath in loadedFilePaths)
                {
                    clips.Load(filePath);
                }

                clips.Reset();

                // Далее ваш неизменный код отправки фактов...
                outputBox.AppendText("ПОЛУЧЕНЫ ИНГРЕДИЕНТЫ:\r\n");
                foreach (ListViewItem item in listView1.Items)
                {
                    if (item.Checked)
                    {
                        string ingredientName = item.Text;
                        double cf = ingredientCFValues.ContainsKey(ingredientName) ? ingredientCFValues[ingredientName] : 1.0;
                        string cfString = ToClipsNumberString(cf);
                        clips.Eval($"(assert (input-question (name \"{ingredientName}\") (certainty {cfString})))");
                        outputBox.AppendText($"   - {ingredientName} (коэффициент: {ToDisplayNumberString(cf)})\r\n");
                    }
                }

                outputBox.AppendText("------------------------------------------------\r\n");
                long rulesCount = clips.Run();
                outputBox.AppendText("Правил сработало: " + rulesCount + "\r\n");
                outputBox.AppendText("------------------------------------------------\r\n");

                ShowProxyLogs();
                UpdateResultsTable();
            }
            catch (Exception ex)
            {
                outputBox.AppendText("ОШИБКА: " + ex.Message + "\r\n");
            }
        }

        private void ShowProxyLogs()
        {
            string evalStr = "(find-fact ((?f ioproxy)) TRUE)";
            var matches = (MultifieldValue)clips.Eval(evalStr);

            if (matches.Count > 0)
            {
                FactAddressValue proxy = (FactAddressValue)matches[0];
                MultifieldValue msgs = (MultifieldValue)proxy["messages"];

                if (msgs.Count > 0)
                {
                    outputBox.AppendText("ОТЧЕТ О ПРИГОТОВЛЕНИИ:\r\n");
                    for (int i = 0; i < msgs.Count; i++)
                    {
                        string cleanMsg = DecodeClipsString(msgs[i].ToString().Trim('"'));
                        outputBox.AppendText("     " + cleanMsg + "\r\n");
                    }
                }
            }
            else
            {
                outputBox.AppendText("Система не вернула текстовых уведомлений.\r\n");
            }
        }

        private void UpdateResultsTable()
        {
            listView2.Items.Clear();

            var proxyFact = (MultifieldValue)clips.Eval("(find-all-facts ((?f ioproxy)) TRUE)");
            if (proxyFact.Count > 0)
            {
                FactAddressValue proxy = (FactAddressValue)proxyFact[0];
                MultifieldValue messages = (MultifieldValue)proxy["messages"];

                // Убрали строку: outputBox.AppendText("\r\n--- РЕЗУЛЬТАТЫ ВЫВОДА ---\r\n");

                for (int i = 0; i < messages.Count; i++)
                {
                    string msgText = DecodeClipsString(messages[i].ToString().Trim('"'));

                    // Убрали строку: outputBox.AppendText(msgText + "\r\n");

                    // Пытаемся разделить строку на Название и CF с помощью Regex
                    var match = System.Text.RegularExpressions.Regex.Match(msgText, @"(.+)\(CF=(.+)\)");

                    if (match.Success)
                    {
                        string name = match.Groups[1].Value.Trim();
                        string cfString = match.Groups[2].Value.Trim();

                        double.TryParse(cfString.Replace(',', '.'),
                                        System.Globalization.NumberStyles.Any,
                                        System.Globalization.CultureInfo.InvariantCulture,
                                        out double cfValue);

                        ListViewItem item = new ListViewItem(name);
                        item.SubItems.Add(cfValue.ToString("F2"));

                        if (cfValue > 0.6)
                        {
                            item.BackColor = Color.LightGreen;
                        }

                        listView2.Items.Add(item);
                    }
                    else
                    {
                        listView2.Items.Add(new ListViewItem(msgText));
                    }
                }
            }
        }
        #endregion

        #region Интерфейсные события

        private void listView1_ItemCheck(object sender, ItemCheckEventArgs e)
        {
            this.BeginInvoke(new MethodInvoker(() => {
                if (e.Index < listView1.Items.Count)
                {
                    ListViewItem item = listView1.Items[e.Index];
                    bool isChecked = e.NewValue == CheckState.Checked;

                    if (isChecked)
                    {
                        string ingredientName = item.Text;
                        double cf = ingredientCFValues.ContainsKey(ingredientName) ?
                                  ingredientCFValues[ingredientName] : 1.0;
                        item.SubItems[1].Text = ToDisplayNumberString(cf);
                    }
                    else
                    {
                        item.SubItems[1].Text = "";
                    }
                }
            }));
        }

        private void listView1_MouseDoubleClick(object sender, MouseEventArgs e)
        {
            ListViewHitTestInfo hit = listView1.HitTest(e.Location);
            if (hit.Item != null && hit.Item.Checked && hit.SubItem == hit.Item.SubItems[1])
            {
                if (isEditing) return;
                isEditing = true;

                Rectangle rect = hit.SubItem.Bounds;
                TextBox editBox = new TextBox();
                editBox.Bounds = new Rectangle(rect.Left, rect.Top, rect.Width, rect.Height);
                editBox.Text = hit.SubItem.Text;
                editBox.BorderStyle = BorderStyle.FixedSingle;
                editBox.Font = listView1.Font;

                editBox.KeyPress += (s, args) => {
                    char c = args.KeyChar;
                    bool isDigit = char.IsDigit(c);
                    bool isControl = char.IsControl(c);
                    bool isDecimalSeparator = c == '.' || c == ',';

                    if (!isControl && !isDigit && !isDecimalSeparator && c != '-')
                    {
                        args.Handled = true;
                    }
                };

                listView1.Controls.Add(editBox);
                editBox.BringToFront();
                editBox.Focus();
                editBox.SelectAll();

                editBox.LostFocus += (s, args) => {
                    SaveCFValue(editBox, hit.Item);
                };

                editBox.KeyDown += (s, args) => {
                    if (args.KeyCode == Keys.Enter)
                    {
                        SaveCFValue(editBox, hit.Item);
                    }
                    else if (args.KeyCode == Keys.Escape)
                    {
                        listView1.Controls.Remove(editBox);
                        editBox.Dispose();
                        isEditing = false;
                    }
                };
            }
        }

        private void SaveCFValue(TextBox editBox, ListViewItem item)
        {
            string ingredientName = item.Text;
            double cf = ParseNumberString(editBox.Text);

            ingredientCFValues[ingredientName] = cf;
            item.SubItems[1].Text = ToDisplayNumberString(cf);

            listView1.Controls.Remove(editBox);
            editBox.Dispose();
            isEditing = false;
        }

        private void resetBtn_Click(object sender, EventArgs e)
        {
            foreach (ListViewItem item in listView1.Items)
            {
                item.Checked = false;
                item.SubItems[1].Text = "";

                if (ingredientCFValues.ContainsKey(item.Text))
                {
                    ingredientCFValues[item.Text] = 1.0;
                }
            }

            listView2.Items.Clear();
            outputBox.Clear();
            outputBox.Text = "Система сброшена.\r\n";
        }

        private void saveAsButton_Click(object sender, EventArgs e)
        {
            if (clipsSaveFileDialog.ShowDialog() == DialogResult.OK)
            {
                File.WriteAllText(clipsSaveFileDialog.FileName, codeBox.Text, Encoding.UTF8);
            }
        }

        private void listView1_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.F2 && listView1.SelectedItems.Count > 0)
            {
                var item = listView1.SelectedItems[0];
                if (item.Checked)
                {
                    var bounds = item.SubItems[1].Bounds;
                    listView1_MouseDoubleClick(sender,
                        new MouseEventArgs(MouseButtons.Left, 2, bounds.Left + 5, bounds.Top + 5, 0));
                }
            }
        }

        #endregion
    }
}
