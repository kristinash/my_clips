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
        private CultureInfo uiCulture = CultureInfo.CurrentUICulture;

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
            listView1.Columns.Add("Ингредиент", 100);
            listView1.Columns.Add("Уверенность (-1...1)", 120);
            listView2.View = View.Details;
            listView2.FullRowSelect = true;
            listView2.Columns.Clear();
            listView2.Columns.Add("Блюдо / Продукт", 100);
            listView2.Columns.Add("Уверенность (CF)", 110);
        }

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

            // Удаляем только невидимый символ BOM, если он есть в начале
            // \uFEFF — это Byte Order Mark
            text = text.TrimStart('\uFEFF');

            // Очищаем только специфические "мусорные" символы, 
            // не трогая пробелы, табуляцию и переносы строк
            return Regex.Replace(text, @"[\u0000-\u0008\u000B\u000C\u000E-\u001F]", "");
        }
        private string ToClipsNumberString(double value)
        {
            return value.ToString("F6", invariantCulture);
        }

        private string ToDisplayNumberString(double value)
        {
            return value.ToString("F2", uiCulture);
        }

        private double ParseNumberString(string text)
        {
            if (string.IsNullOrWhiteSpace(text)) return 1.0;
            text = text.Trim().Replace(',', '.');
            if (double.TryParse(text, NumberStyles.Any, invariantCulture, out double result))
            {
                return Math.Max(-1.0, Math.Min(1.0, result));
            }
            return 1.0;
        }

        private void openFile_Click(object sender, EventArgs e)
        {
            clipsOpenFileDialog.Multiselect = true;
            if (clipsOpenFileDialog.ShowDialog() == DialogResult.OK)
            {
                try
                {
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
                    ParseClipsFile(codeBox.Text);
                    outputBox.Text = $"Загружено файлов: {loadedFilePaths.Count}\r\n";
                    foreach (var path in loadedFilePaths)
                        outputBox.AppendText($"- {Path.GetFileName(path)}\r\n");
                    outputBox.AppendText("\r\nВыберите ингредиенты и настройте CF (двойной клик на число).\r\n");
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
                string name = match.Groups[1].Value;
                uniqueNames.Add(name);

                // Устанавливаем CF = 1.0 в словаре
                ingredientCFValues[name] = 1.0;

                // Добавляем в ListView
                var lvi1 = new ListViewItem(name);
                lvi1.SubItems.Add("");
                listView1.Items.Add(lvi1);
            }
        }
        private void nextBtn_Click(object sender, EventArgs e)
        {
            if (loadedFilePaths.Count == 0)
            {
                MessageBox.Show("Загрузите хотя бы один файл .clp!");
                return;
            }
            try
            {
                clips.Clear();

                // 1. Сортируем файлы так, чтобы basic.clp был первым, а facts.clp вторым
                var sortedFiles = loadedFilePaths.OrderBy(path => {
                    string fileName = Path.GetFileName(path).ToLower();
                    if (fileName == "basic.clp") return 1;
                    if (fileName == "facts.clp") return 2;
                    return 3; // Остальные (rules.clp и т.д.)
                }).ToList();

                // 2. Загружаем файлы в правильном порядке
                foreach (string filePath in sortedFiles)
                {
                    clips.Load(filePath);
                }

                clips.Reset();

                // 3. Передаем данные из UI
                foreach (ListViewItem item in listView1.Items)
                {
                    if (item.Checked)
                    {
                        string name = item.Text;
                        double cf = ingredientCFValues.ContainsKey(name) ? ingredientCFValues[name] : 1.0;
                        clips.AssertString($"(input-question (name \"{name}\") (certainty {ToClipsNumberString(cf)}))");
                    }
                }

                ExecuteEngine();
            }
            catch (Exception ex)
            {
                MessageBox.Show("ОШИБКА ПРИ ЗАГРУЗКЕ: " + ex.Message);
            }
        }

        private void ShowProxyLogs()
        {
            outputBox.Clear();
            outputBox.AppendText("=== ЛОГ ВЫПОЛНЕНИЯ СИСТЕМЫ ===\r\n\r\n");
            var matches = (MultifieldValue)clips.Eval("(find-all-facts ((?f ioproxy)) TRUE)");
            if (matches.Count > 0)
            {
                FactAddressValue proxy = (FactAddressValue)matches[0];
                MultifieldValue msgs = (MultifieldValue)proxy["messages"];
                List<string> allMessages = new List<string>();
                for (int i = 0; i < msgs.Count; i++)
                {
                    allMessages.Add(DecodeClipsString(msgs[i].ToString().Trim('"')));
                }
                var processLogs = allMessages.Where(m => m.Contains("ПРОЦЕСС") || m.Contains("ЦИКЛ") || m.Contains("ДЕЙСТВИЕ")).ToList();
                var headerLogs = allMessages.Where(m => m.Contains("---") || m.Contains("ОТЧЕТ")).ToList();
                var finalResults = allMessages.Where(m => m.StartsWith("ИТОГО")).ToList();
                foreach (var log in processLogs) outputBox.AppendText("  [Действие] " + log + "\r\n");
                foreach (var log in headerLogs) outputBox.AppendText(log + "\r\n");
                foreach (var log in finalResults) outputBox.AppendText("  [Результат] " + log + "\r\n");
                UpdateResultsTable(finalResults);
                outputBox.SelectionStart = outputBox.Text.Length;
                outputBox.ScrollToCaret();
            }
        }

        private void UpdateResultsTable(List<string> finalLogs)
        {
            listView2.Items.Clear();
            foreach (string msgText in finalLogs)
            {
                var match = Regex.Match(msgText, @"ИТОГО:\s*(.+)\s*\(CF=(.+)\)");
                if (match.Success)
                {
                    string name = match.Groups[1].Value.Trim();
                    string cfString = match.Groups[2].Value.Trim();
                    double.TryParse(cfString.Replace(',', '.'), NumberStyles.Any, CultureInfo.InvariantCulture, out double cfValue);
                    ListViewItem item = new ListViewItem(name);
                    item.SubItems.Add(cfValue.ToString("F2", uiCulture));
                    if (cfValue >= 0.8) item.BackColor = Color.LightGreen;
                    else if (cfValue >= 0.5) item.BackColor = Color.LightYellow;
                    else if (cfValue < 0.2) item.ForeColor = Color.Gray;
                    listView2.Items.Add(item);
                }
            }
        }

        private void listView1_ItemCheck(object sender, ItemCheckEventArgs e)
        {
            this.BeginInvoke(new MethodInvoker(() => {
                if (e.Index < listView1.Items.Count)
                {
                    ListViewItem item = listView1.Items[e.Index];
                    if (e.NewValue == CheckState.Checked)
                    {
                        double cf = ingredientCFValues.ContainsKey(item.Text) ? ingredientCFValues[item.Text] : 1.0;
                        item.SubItems[1].Text = ToDisplayNumberString(cf);
                    }
                    else
                    {
                        item.SubItems[1].Text = "";
                    }
                }
            }));
        }

        private void ExecuteEngine()
        {
            clips.Run();
            var matches = (MultifieldValue)clips.Eval("(find-all-facts ((?f ioproxy)) TRUE)");
            if (matches.Count > 0)
            {
                FactAddressValue proxy = (FactAddressValue)matches[0];
                if (proxy.GetSlotValue("mode").ToString() == "1")
                {
                    string askKey = proxy.GetSlotValue("current-ask").ToString().Trim('"');
                    MultifieldValue msgs = (MultifieldValue)proxy.GetSlotValue("messages");
                    string message = DecodeClipsString(msgs[msgs.Count - 1].ToString().Trim('"'));
                    MultifieldValue ansOptions = (MultifieldValue)proxy.GetSlotValue("answers");
                    double cf = 0.0;
                    if (askKey == "MOOD_QUESTION")
                    {
                        string prompt = $"{message}\n\nДа — {DecodeClipsString(ansOptions[0].ToString().Trim('"'))} (+0.1)\nНет — {DecodeClipsString(ansOptions[1].ToString().Trim('"'))} (0.0)";
                        DialogResult res = MessageBox.Show(prompt, "Ваше настроение", MessageBoxButtons.YesNo);
                        cf = (res == DialogResult.Yes) ? 1.0 : 0.0;
                    }
                    else
                    {
                        DialogResult res = MessageBox.Show(message, "Вопрос системы", MessageBoxButtons.YesNoCancel);
                        if (res == DialogResult.Yes) cf = 1.0;
                        else if (res == DialogResult.No) cf = -1.0;
                        else cf = 0.0;
                        UpdateListViewFromAnswer(askKey, cf);
                    }
                    clips.AssertString($"(input-question (name \"{askKey}\") (certainty {ToClipsNumberString(cf)}))");
                    clips.Eval($"(modify {proxy.FactIndex} (mode 0))");
                    ExecuteEngine();
                }
                else
                {
                    ShowProxyLogs();
                }
            }
            else
            {
                ShowProxyLogs();
            }
        }

        private void UpdateListViewFromAnswer(string name, double cf)
        {
            foreach (ListViewItem item in listView1.Items)
            {
                if (item.Text == name)
                {
                    item.Checked = (cf > 0);
                    item.SubItems[1].Text = ToDisplayNumberString(cf);
                    break;
                }
            }
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
                editBox.KeyPress += (s, args) => {
                    if (!char.IsControl(args.KeyChar) && !char.IsDigit(args.KeyChar) &&
                        args.KeyChar != '.' && args.KeyChar != ',' && args.KeyChar != '-')
                    {
                        args.Handled = true;
                    }
                };
                listView1.Controls.Add(editBox);
                editBox.BringToFront();
                editBox.Focus();
                editBox.SelectAll();
                editBox.LostFocus += (s, args) => { FinalizeEdit(editBox, hit.Item); };
                editBox.KeyDown += (s, args) => {
                    if (args.KeyCode == Keys.Enter) FinalizeEdit(editBox, hit.Item);
                    if (args.KeyCode == Keys.Escape) { AbortEdit(editBox); }
                };
            }
        }

        private void FinalizeEdit(TextBox tb, ListViewItem item)
        {
            if (!listView1.Controls.Contains(tb)) return;
            double val = ParseNumberString(tb.Text);
            ingredientCFValues[item.Text] = val;
            item.SubItems[1].Text = ToDisplayNumberString(val);
            AbortEdit(tb);
        }

        private void AbortEdit(TextBox tb)
        {
            listView1.Controls.Remove(tb);
            tb.Dispose();
            isEditing = false;
        }

        private void resetBtn_Click(object sender, EventArgs e)
        {
            foreach (ListViewItem item in listView1.Items)
            {
                item.Checked = false;
                item.SubItems[1].Text = "";
                ingredientCFValues[item.Text] = 1.0;
            }
            listView2.Items.Clear();
            outputBox.Clear();
        }

        private void saveAsButton_Click(object sender, EventArgs e)
        {
            if (clipsSaveFileDialog.ShowDialog() == DialogResult.OK)
            {
                File.WriteAllText(clipsSaveFileDialog.FileName, codeBox.Text, Encoding.UTF8);
            }
        }
    }
}
