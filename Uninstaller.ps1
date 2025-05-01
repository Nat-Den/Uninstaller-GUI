# Requires -Version 5.1
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

[xml]$XAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="Installed Apps Manager" Height="600" Width="800" Background="#f0f0f0">
    <Grid Margin="10">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <GroupBox Header="Search" FontWeight="Bold" FontSize="14" Margin="0,0,0,10">
            <TextBox Name="SearchBox" Height="25" FontSize="14" Margin="10"/>
        </GroupBox>

        <GroupBox Header="Applications" Grid.Row="1" FontWeight="Bold" FontSize="14" Margin="0,0,0,10">
            <ListBox Name="AppList" SelectionMode="Multiple" Margin="10" FontFamily="Segoe UI" FontSize="13" Background="White"/>
        </GroupBox>

        <GroupBox Header="Actions" Grid.Row="2" FontWeight="Bold" FontSize="14">
            <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" Margin="10">
                <Button Name="UninstallBtn" Content="Uninstall Selected" Width="150" Margin="0,0,10,0" Background="#e06666" Foreground="White" FontWeight="Bold"/>
                <Button Name="RefreshBtn" Content="Refresh" Width="100" Background="#6fa8dc" Foreground="White" FontWeight="Bold"/>
            </StackPanel>
        </GroupBox>
    </Grid>
</Window>
"@

$reader = New-Object System.Xml.XmlNodeReader $XAML
$Window = [Windows.Markup.XamlReader]::Load($reader)

$SearchBox    = $Window.FindName("SearchBox")
$AppList      = $Window.FindName("AppList")
$UninstallBtn = $Window.FindName("UninstallBtn")
$RefreshBtn   = $Window.FindName("RefreshBtn")

function Get-InstalledApps {
    $registryPaths = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )
    $apps = foreach ($path in $registryPaths) {
        Get-ItemProperty -Path $path -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName } | ForEach-Object {
            [PSCustomObject]@{
                Name = $_.DisplayName
                UninstallString = $_.UninstallString
            }
        }
    }
    $apps | Sort-Object Name -Unique
}

function Refresh-AppList {
    $AppList.Items.Clear()
    $script:Apps = Get-InstalledApps
    foreach ($app in $script:Apps) {
        $AppList.Items.Add($app.Name) | Out-Null
    }
}

function Filter-Apps($query) {
    $AppList.Items.Clear()
    $filtered = $script:Apps | Where-Object { $_.Name -like "*$query*" }
    foreach ($app in $filtered) {
        $AppList.Items.Add($app.Name) | Out-Null
    }
}

$SearchBox.Add_TextChanged({
    Filter-Apps -query $SearchBox.Text
})

$RefreshBtn.Add_Click({
    Refresh-AppList
})

$UninstallBtn.Add_Click({
    $selectedItems = $AppList.SelectedItems
    foreach ($item in $selectedItems) {
        $match = $script:Apps | Where-Object { $_.Name -eq $item }
        if ($match.UninstallString) {
            Start-Process "cmd.exe" "/c $($match.UninstallString)" -WindowStyle Hidden
        }
    }
})

Refresh-AppList
$Window.ShowDialog() | Out-Null
