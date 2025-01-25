
# Guía para hacer un repack

## Introducción
Este repositorio contiene un ejemplo de configuración para un repack de un juego utilizando **Inno Setup**. Este script puede crear un instalador personalizado, ajustado a tus necesidades, de forma sencilla.

A continuación, tienes una guía paso a paso para crear un instalador y cómo modificar las variables necesarias para que funcione con tu propio juego.

Puedes usar el archivo example.iss, te sera mas facil y solo tienes que cambiar la ruta de tus archivos y el nombre del Juego/App del que quieres hacer el instalador.

---

## Pasos para configurar tu repack

### **1. Configura las variables principales**
Las primeras líneas del código contienen variables importantes que debes modificar según el nombre de tu juego y otros detalles.

```ini
#define MyAppName "Ejemplo"  ; Nombre del juego
#define MyAppVersion "1.4.11"      ; Versión del juego
#define MyAppExeName "ejemplo.exe" ; Nombre del archivo ejecutable
```

- **MyAppName:** El nombre del juego que aparecerá durante la instalación.  
- **MyAppVersion:** La versión del juego que quieres instalar.  
- **MyAppExeName:** El nombre del archivo ejecutable principal del juego.  

Ejemplo: Si el juego es "Need for Speed Underground 2", las variables serían:  

```ini
#define MyAppName "Need for Speed Underground 2"
#define MyAppVersion "1.2"
#define MyAppExeName "speed2.exe"
```

Asegúrate de reemplazar estos valores con los de tu propio juego.

---

### **2. Configura el [Setup]**
En esta sección se definen los parámetros del instalador. Aquí debes definir las rutas, los nombres del archivo de licencia y las imágenes del asistente.

```ini
[Setup]
AppId={{5626BECA-2A45-49C4-85F6-3E3C8B0D26F0}  ; Este ID debe ser único
AppName={#MyAppName}
AppVersion={#MyAppVersion}
DefaultDirName=C:\Games\{#MyAppName}
DefaultGroupName={#MyAppName}
LicenseFile=C:\ruta\a\tu\license.txt   ; Modifica la ruta de la licencia
WizardImageFile=C:\ruta\a\tu\imagen.bmp ; Modifica la ruta de la imagen
```

- **AppId:** Este ID debe ser único. Puedes generarlo usando cualquier herramienta online para crear GUIDs (por ejemplo, [guidgenerator.com](https://guidgenerator.com)).  
- **DefaultDirName:** Carpeta predeterminada donde se instalará el juego, en este caso, `C:\Games\{#MyAppName}`.  
- **LicenseFile:** Ruta al archivo de licencia que los usuarios deben leer.  
- **WizardImageFile:** Ruta a la imagen que aparecerá en el asistente de instalación.  

---

### **3. Archivos que se incluyen**
En la sección `[Files]` es donde se especifican los archivos que serán copiados al sistema del usuario durante la instalación.

```ini
[Files]
Source: "C:\ruta\a\tu\juego"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "C:\ruta\a\tu\juego\ejemplo.exe"; DestDir: "{app}"; Flags: ignoreversion
; Archivos adicionales como el instalador de DirectX y Visual C++ Redistributable
Source: "C:\ruta\a\tu\juego\_Redist\dxwebsetup.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall
Source: "C:\ruta\a\tu\juego\_Redist\vc_redistx64.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall
```

- **Source:** Ruta de los archivos en tu PC.  
- **DestDir:** `{app}` es el directorio de instalación en el sistema del usuario.  

Incluye todos los archivos necesarios y las subcarpetas.  

---

### **4. Accesos directos y menú de inicio**
En la sección `[Icons]` se crean accesos directos para el escritorio y el menú de inicio.

```ini
[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
```

- **{group}:** Nombre del grupo en el menú de inicio.  
- **{app}:** Directorio de instalación.  

---

### **5. Tareas post instalación**
Si tu juego requiere la instalación de otros programas, como DirectX o Visual C++ Redistributable, puedes añadirlos en la sección `[Run]`.

```ini
[Run]
; Ejecuta el instalador de DirectX
Filename: "{tmp}\dxwebsetup.exe"; Flags: PostInstall runascurrentuser; Description: "Instalar DirectX"
; Ejecuta el instalador de Visual C++ Redistributable
Filename: "{tmp}vc_redistx64.exe"; Flags: PostInstall runascurrentuser; Description: "Instalar Visual C++ Redistributable"
; Abre el juego tras instalar.
Filename: "{app}\{#MyAppExeName}"; Flags: nowait postinstall skipifsilent; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"
```

Si tu juego no requiere instalar programas adicionales, puedes omitir estas líneas.

---

### **6. Porcentaje de instalación (opcional)**
En la sección `[Code]` del script puedes incluir funcionalidades adicionales, como el control del porcentaje de instalación.

```ini
[Code]
function GetTickCount: DWORD;
  external 'GetTickCount@kernel32.dll stdcall';

procedure InitializeWizard;
begin
  PercentLabel := TNewStaticText.Create(WizardForm);
  PercentLabel.Parent := WizardForm.ProgressGauge.Parent;
  PercentLabel.Caption := "Progreso de la instalación: 0%";
end;

procedure CurInstallProgressChanged(CurProgress, MaxProgress: Integer);
begin
  PercentLabel.Caption := Format('Progreso: %.2f %%', [(CurProgress * 100.0) / MaxProgress]);
end;
```

---

### **Variables para modificar**
- **MyAppName:** Nombre de tu juego.  
- **MyAppVersion:** Versión del juego.  
- **MyAppExeName:** Nombre del archivo ejecutable.  
- **DefaultDirName:** Directorio de instalación.  
- **LicenseFile:** Ruta al archivo de licencia.  
- **WizardImageFile:** Imagen del asistente de instalación.  
- **Source:** Archivos que deseas incluir en el instalador.  

---

### **Información adicional**
Este código fue creado para generar un instalador de juegos utilizando **Inno Setup**. Si es tu primera vez, puedes descargar **Inno Setup** desde [aquí](https://jrsoftware.org/isdl.php) y usar este script para compilar el instalador de tu juego.

Hecho por hamzaa
