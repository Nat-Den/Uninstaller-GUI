# 🗑️ PowerShell App Uninstaller GUI

A modern WPF-based PowerShell tool for managing installed applications on Windows.  
Easily search, select, and uninstall apps through a clean and responsive graphical interface.

---

## ✨ Features

- 🔍 **Search bar** to filter installed applications
- ✅ **Multi-selection (simple)** – uninstall multiple apps in one click
- 📅 **Formatted install dates** (DD/MM/YYYY)
- 🧼 Sorts apps **alphabetically** by name
- 🔁 **Refresh button** to re-fetch installed apps
- 🖱️ Clean WPF layout with tabs and styling
- 🔒 (Optional) Admin-mode support for protected apps (commented out by default)

---

## 📸 Screenshots

*Coming soon – add screenshots of your GUI here!*

---

## 🚀 How to Use

1. **Download the script** or clone the repository:
    ```bash
    git clone https://github.com/Nat-Den/powershell-app-uninstaller.git
    ```

2. **Run the script** in PowerShell:
    ```powershell
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
    .\AppUninstallerGUI.ps1
    ```

3. **Search, select, and uninstall** apps with ease.

---

## 💡 Use Cases

- Clean up bloatware from newly deployed machines
- Give Help Desk teams a GUI for uninstalling user-installed apps
- Speed up environment prep for IT labs or test devices

---

## 🛠 Built With

- **PowerShell 5.1+**
- **WPF (XAML UI)** via `PresentationFramework`
- Runs natively on **Windows 10/11**

---

## ⚠️ Disclaimer

This tool does not distinguish between system-critical and user-installed apps.  
Always review selected applications before uninstalling.

---

## 📄 License

MIT Licens
