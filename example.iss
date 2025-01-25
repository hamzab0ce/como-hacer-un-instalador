#define MyAppName "ejemplo"
#define MyAppVersion "1.4.11"
#define MyAppExeName "ejemplo.exe"

[Setup]
AppId={{5626BECA-2A45-49C4-85F6-3E3C8B0D26F0}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
DefaultDirName=C:\Games\{#MyAppName}
DefaultGroupName={#MyAppName}
LicenseFile==C:\ruta\a\tu\license.txt
AllowNoIcons=no
OutputDir=C:\ruta\a\la\salida
OutputBaseFilename=setup
Compression=lzma2
SolidCompression=yes
DisableWelcomePage=False
SetupIconFile=C:\ruta\a\l\icono\zicon.ico
InternalCompressLevel=fast
CompressionThreads=2
PrivilegesRequired=none
DisableDirPage=no
AppComments=hola :D

[Languages]
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"

[Files]
Source: "C:\ruta\a\tu\juego\ejemplo.exe"; DestDir: "{app}"; Flags: external
Source: "C:\ruta\a\tu\juego\ejemplo\*"; DestDir: "{app}"; Flags: external recursesubdirs createallsubdirs
Source: "C:\ruta\a\tu\juego\ejemplo\_Redist\dxwebsetup.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall
Source: "C:\ruta\a\tu\juego\ejemplo\_Redist\vc_redistx64.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\_Redist\dxwebsetup.exe"; Flags: PostInstall hidewizard runascurrentuser; Description: "Instalar DirectX"
Filename: "{app}\_Redist\vc_redistx64.exe"; Flags: PostInstall hidewizard runascurrentuser; Description: "Instalar Visual C++ Redistributable"
Filename: "{app}\{#MyAppExeName}"; Flags: nowait postinstall skipifsilent; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Code]
function GetTickCount: DWORD;
  external 'GetTickCount@kernel32.dll stdcall';

var
  StartTick: DWORD;
  PercentLabel: TNewStaticText;
  ElapsedLabel: TNewStaticText;
  RemainingLabel: TNewStaticText;

function TicksToStr(Value: DWORD): string;
var
  I: DWORD;
  Hours, Minutes, Seconds: Integer;
begin
  I := Value div 1000;
  Seconds := I mod 60;
  I := I div 60;
  Minutes := I mod 60;
  I := I div 60;
  Hours := I mod 24;
  Result := Format('%.2d:%.2d:%.2d', [Hours, Minutes, Seconds]);
end;

procedure InitializeWizard;
begin
  PercentLabel := TNewStaticText.Create(WizardForm);
  PercentLabel.Parent := WizardForm.ProgressGauge.Parent;
  PercentLabel.Left := 0;
  PercentLabel.Top := WizardForm.ProgressGauge.Top +
    WizardForm.ProgressGauge.Height + 12;

  ElapsedLabel := TNewStaticText.Create(WizardForm);
  ElapsedLabel.Parent := WizardForm.ProgressGauge.Parent;
  ElapsedLabel.Left := 0;
  ElapsedLabel.Top := PercentLabel.Top + PercentLabel.Height + 4;

  RemainingLabel := TNewStaticText.Create(WizardForm);
  RemainingLabel.Parent := WizardForm.ProgressGauge.Parent;
  RemainingLabel.Left := 0;
  RemainingLabel.Top := ElapsedLabel.Top + ElapsedLabel.Height + 4;
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = wpInstalling then
    StartTick := GetTickCount;
end;

procedure CancelButtonClick(CurPageID: Integer; var Cancel, Confirm: Boolean);
begin
  if CurPageID = wpInstalling then
  begin
    Cancel := False;
    if ExitSetupMsgBox then
    begin
      Cancel := True;
      Confirm := False;
      PercentLabel.Visible := False;
      ElapsedLabel.Visible := False;
      RemainingLabel.Visible := False;
    end;
  end;
end;

procedure CurInstallProgressChanged(CurProgress, MaxProgress: Integer);
var
  CurTick: DWORD;
begin
  CurTick := GetTickCount;
  PercentLabel.Caption :=
    Format('Progreso: %.2f %%', [(CurProgress * 100.0) / MaxProgress]);
end;
