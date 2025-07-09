# 📦 1-Click Software Installer (PowerShell GUI EXE)

A lightweight GUI tool to install essential Windows software in just one click — ideal for technicians, IT support, or system setup tasks.  
Powered by **Winget** and built with **PowerShell**.  
Packaged as a standalone `.exe` — no need to open PowerShell manually.

---

## ✅ Features

- Auto-checks and installs Winget if missing
- Search and install apps from Winget repository
- Predefined app list (Chrome, VLC, 7-Zip, etc.) sorted by category
- Clean Windows Forms GUI with checkboxes
- Desktop shortcuts created automatically (if app found)
- View installed apps with version and ID
- Modern, compact layout with consistent design

---

## 🧰 Tech Stack

- PowerShell
- Windows Forms (`System.Windows.Forms`)
- Packaged as `.exe` using PS2EXE or similar
- Winget CLI

---

## 📌 Usage

1. Download and run the `1click-installer.exe` as **Administrator**
2. Tick the apps you want
3. Click **Install Selected**
4. Done — installs will run silently, and shortcuts appear on Desktop (if available)

---

## 📎 Notes

- Designed for PC setup, deployment, or IT support tasks
