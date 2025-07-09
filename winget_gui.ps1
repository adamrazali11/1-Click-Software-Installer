Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# =============================
# Auto Install Winget (Fix)
# =============================
function Install-Winget {
    $msg = [System.Windows.Forms.MessageBox]::Show("Winget is not installed. Do you want to install it now?", "Winget Required", "YesNo", "Warning")
    if ($msg -eq "Yes") {
        Start-Process powershell -Verb RunAs -ArgumentList "-Command `\"Invoke-WebRequest https://raw.githubusercontent.com/asheroto/winget-installer/master/winget-install.ps1 -UseBasicParsing | iex`\""
        
        Start-Sleep -Seconds 10
        $retries = 0
        while (-not (Get-Command winget -ErrorAction SilentlyContinue) -and $retries -lt 10) {
            Start-Sleep -Seconds 3
            $retries++
        }

        if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
            [System.Windows.Forms.MessageBox]::Show("Winget installation failed. Please try again manually.", "Error", "OK", "Error")
            exit
        } else {
            [System.Windows.Forms.MessageBox]::Show("Winget installed successfully. You may now continue.", "Done", "OK", "Information")
        }
    } else {
        exit
    }
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Install-Winget
}

# =============================
# GUI Start
# =============================

$form = New-Object System.Windows.Forms.Form
$form.Text = "1-Click Software Installer"
$form.Size = New-Object System.Drawing.Size(720, 660)
$form.StartPosition = "CenterScreen"

$searchBox = New-Object System.Windows.Forms.TextBox
$searchBox.Size = New-Object System.Drawing.Size(400, 20)
$searchBox.Location = New-Object System.Drawing.Point(10, 10)
$form.Controls.Add($searchBox)

$searchButton = New-Object System.Windows.Forms.Button
$searchButton.Text = "Search"
$searchButton.Location = New-Object System.Drawing.Point(420, 8)
$searchButton.Size = New-Object System.Drawing.Size(100, 24)
$form.Controls.Add($searchButton)

$resetButton = New-Object System.Windows.Forms.Button
$resetButton.Text = "Reset"
$resetButton.Location = New-Object System.Drawing.Point(530, 8)
$resetButton.Size = New-Object System.Drawing.Size(80, 24)
$form.Controls.Add($resetButton)

$listButton = New-Object System.Windows.Forms.Button
$listButton.Text = "Installed"
$listButton.Location = New-Object System.Drawing.Point(620, 8)
$listButton.Size = New-Object System.Drawing.Size(80, 24)
$form.Controls.Add($listButton)

$listBox = New-Object System.Windows.Forms.CheckedListBox
$listBox.Font = New-Object System.Drawing.Font("Consolas", 9)
$listBox.DrawMode = [System.Windows.Forms.DrawMode]::OwnerDrawFixed
$listBox.ItemHeight = 24

$listBox.add_DrawItem({
    param($sender, $e)

    if ($e.Index -ge 0) {
        $e.DrawBackground()
        $text = $listBox.Items[$e.Index]
        $font = $listBox.Font
        $brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::Black)

        $e.Graphics.DrawString($text, $font, $brush, $e.Bounds.Left + 20, $e.Bounds.Top + 4)

        $e.DrawFocusRectangle()
    }
})


$listBox.CheckOnClick = $true
$listBox.ItemHeight = 24

$listBox.Size = New-Object System.Drawing.Size(680, 380)
$listBox.Location = New-Object System.Drawing.Point(10, 40)
$form.Controls.Add($listBox)

$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(10, 430)
$progressBar.Size = New-Object System.Drawing.Size(400, 20)
$progressBar.Style = "Marquee"
$progressBar.MarqueeAnimationSpeed = 30
$progressBar.Visible = $false
$form.Controls.Add($progressBar)

$loadingLabel = New-Object System.Windows.Forms.Label
$loadingLabel.Text = "Searching, please wait..."
$loadingLabel.Location = New-Object System.Drawing.Point(420, 430)
$loadingLabel.Size = New-Object System.Drawing.Size(200, 20)
$loadingLabel.Visible = $false
$form.Controls.Add($loadingLabel)

$installBtn = New-Object System.Windows.Forms.Button
$installBtn.Text = "Install Selected"
$installBtn.Size = New-Object System.Drawing.Size(150, 30)
$installBtn.Location = New-Object System.Drawing.Point(540, 450)
$form.Controls.Add($installBtn)

$closeBtn = New-Object System.Windows.Forms.Button
$closeBtn.Text = "Close"
$closeBtn.Size = New-Object System.Drawing.Size(100, 30)
$closeBtn.Location = New-Object System.Drawing.Point(420, 450)
$closeBtn.Add_Click({ $form.Close() })
$form.Controls.Add($closeBtn)

$footer = New-Object System.Windows.Forms.LinkLabel
$footer.Text = "Made by @adamrazali11"
$footer.Location = New-Object System.Drawing.Point(10, 460)
$footer.Size = New-Object System.Drawing.Size(300, 20)
$footer.LinkColor = "Blue"
$footer.Add_Click({ Start-Process "https://github.com/adamrazali11" })
$form.Controls.Add($footer)

$defaultApps = @(
    @{ Name = "Google Chrome"; Id = "Google.Chrome"; Category = "Browser" },
    @{ Name = "Mozilla Firefox"; Id = "Mozilla.Firefox"; Category = "Browser" },
    @{ Name = "Brave Browser"; Id = "Brave.Brave"; Category = "Browser" },

    @{ Name = "AnyDesk"; Id = "AnyDeskSoftware.AnyDesk"; Category = "Remote Access" },
    @{ Name = "Ultraviewer"; Id = "UltraviewerCompany.Ultraviewer"; Category = "Remote Access" },
    @{ Name = "RustDesk"; Id = "RustDesk.RustDesk"; Category = "Remote Access" },

    @{ Name = "Telegram"; Id = "Telegram.TelegramDesktop"; Category = "Messaging" },
    @{ Name = "WhatsApp"; Id = "WhatsApp.WhatsApp"; Category = "Messaging" },

    @{ Name = "WPS Office"; Id = "Kingsoft.WPSOffice"; Category = "Office" },
    @{ Name = "LibreOffice"; Id = "TheDocumentFoundation.LibreOffice"; Category = "Office" },
    @{ Name = "Foxit Reader"; Id = "Foxit.FoxitReader"; Category = "Office" },

    @{ Name = "Adobe Reader"; Id = "Adobe.Acrobat.Reader.64-bit"; Category = "PDF" },

    @{ Name = "Avast Antivirus"; Id = "AVAST.Antivirus"; Category = "Antivirus" },
    @{ Name = "Malwarebytes"; Id = "Malwarebytes.Malwarebytes"; Category = "Antivirus" },
    @{ Name = "Bitdefender"; Id = "Bitdefender.BitdefenderAntivirusFree"; Category = "Antivirus" },

    @{ Name = "VLC Media Player"; Id = "VideoLAN.VLC"; Category = "Media" },
    @{ Name = "Spotify"; Id = "Spotify.Spotify"; Category = "Media" },

    @{ Name = "CPU-Z"; Id = "CPUID.CPU-Z"; Category = "Utility" },
    @{ Name = "HWMonitor"; Id = "CPUID.HWMonitor"; Category = "Utility" },
    @{ Name = "Speccy"; Id = "Piriform.Speccy"; Category = "Utility" },
    @{ Name = "CCleaner"; Id = "Piriform.CCleaner"; Category = "Utility" },
    @{ Name = "Revo Uninstaller"; Id = "VS.RevoUninstaller"; Category = "Utility" },
    @{ Name = "Everything Search"; Id = "voidtools.Everything"; Category = "Utility" },
    @{ Name = "ShareX"; Id = "ShareX.ShareX"; Category = "Utility" },
    @{ Name = "Notepad++"; Id = "Notepad++.Notepad++"; Category = "Utility" },

    @{ Name = "7-Zip"; Id = "7zip.7zip"; Category = "Compression" },
    @{ Name = "WinRAR"; Id = "RARLab.WinRAR"; Category = "Compression" }
)

function Load-DefaultApps {
    $listBox.Items.Clear()

    $categories = $defaultApps.Category | Sort-Object -Unique
    foreach ($cat in $categories) {
        $listBox.Items.Add("=== $cat ===") | Out-Null
        foreach ($app in $defaultApps | Where-Object { $_.Category -eq $cat }) {
            $appLine = "  $($app.Name) | $($app.Id)"
            $listBox.Items.Add($appLine) | Out-Null
        }
    }
}
Load-DefaultApps

$searchButton.Add_Click({
    $query = $searchBox.Text
    if ($query -ne "") {
        $progressBar.Visible = $true
        $loadingLabel.Visible = $true
        $form.Refresh()  # force redraw

        $results = winget search --name $query | Select-String '^\S+\s+\S+\s+.+'
        $listBox.Items.Clear()
        foreach ($line in $results) {
            $parts = ($line.ToString() -split "\s{2,}")
            if ($parts.Count -ge 2) {
                $name = $parts[0].Trim()
                $id = $parts[1].Trim()
                $listBox.Items.Add("$name | $id")
            }
        }

        $progressBar.Visible = $false
        $loadingLabel.Visible = $false
    }
})



$resetButton.Add_Click({
    Load-DefaultApps
})

$listButton.Add_Click({

    $listForm = New-Object System.Windows.Forms.Form
    $listForm.Text = "Installed Applications"
    $listForm.Size = New-Object System.Drawing.Size(700, 500)
    $listForm.StartPosition = "CenterScreen"

    $listView = New-Object System.Windows.Forms.ListView
    $listView.Size = New-Object System.Drawing.Size(660, 400)
    $listView.Location = New-Object System.Drawing.Point(10,10)
    $listView.View = 'Details'
    $listView.FullRowSelect = $true
    $listView.GridLines = $true

    $listView.Columns.Add("Name", 250) | Out-Null
    $listView.Columns.Add("ID", 200) | Out-Null
    $listView.Columns.Add("Version", 100) | Out-Null

    $installedApps = winget list | Select-String '^\S+\s+\S+\s+.+'

    foreach ($line in $installedApps) {
        $parts = ($line.ToString() -split '\s{2,}')
        if ($parts.Count -ge 3) {
            $item = New-Object System.Windows.Forms.ListViewItem ($parts[0].Trim())
            $item.SubItems.Add($parts[1].Trim()) | Out-Null
            $item.SubItems.Add($parts[2].Trim()) | Out-Null
            $listView.Items.Add($item) | Out-Null
        }
    }

    $listForm.Controls.Add($listView)

    $closeBtn = New-Object System.Windows.Forms.Button
    $closeBtn.Text = "Close"
    $closeBtn.Size = New-Object System.Drawing.Size(100, 30)
    $closeBtn.Location = New-Object System.Drawing.Point(570, 420)
    $closeBtn.Add_Click({ $listForm.Close() })
    $listForm.Controls.Add($closeBtn)

    $listForm.Topmost = $true
    $listForm.Add_Shown({ $listForm.Activate() })
    [void]$listForm.ShowDialog()
})


$installBtn.Add_Click({
    if ($listBox.CheckedItems.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Please select at least one software.", "Warning", "OK", "Warning")
        return
    }

    foreach ($item in $listBox.CheckedItems) {
        $name = ($item -split '\|')[0].Trim()
        $id = ($item -split '\|')[1].Trim()

        # run installer
        Start-Process powershell -Verb runAs -ArgumentList "winget install --id `"$id`" --silent --accept-package-agreements --accept-source-agreements"

        Start-Sleep -Seconds 5  # allow time for install (adjust if needed)

        # try to find executable path via Start Menu
        $programsPath = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs"
        $foundShortcut = Get-ChildItem -Path $programsPath -Filter "*.lnk" -Recurse | Where-Object { $_.Name -like "*$name*" } | Select-Object -First 1

        if ($foundShortcut) {
            $desktop = [Environment]::GetFolderPath("Desktop")
            $shell = New-Object -ComObject WScript.Shell
            $desktopShortcut = Join-Path $desktop $foundShortcut.Name
            $shell.CreateShortcut($desktopShortcut).TargetPath = $foundShortcut.FullName
        }
    }

    [System.Windows.Forms.MessageBox]::Show("✔ All install commands sent! You can find the apps by searching the Start Menu. Shortcut added to Desktop if found.", "Done", "OK", "Information")
})


$form.Topmost = $true
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()