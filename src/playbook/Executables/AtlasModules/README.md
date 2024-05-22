# Sources
Some of the Playbook contains binary executables. This file provides some verification for those files, by listing the SHA256 hashes, sources, and when each was last verified/checked. Hashes were collected using `Get-FileHash` in PowerShell.

The root of the file paths listed here starts in `src\playbook\Executables`.

### Multi-Choice

-   Path: `\AtlasModules\Tools\multichoice.exe`
-   Source: https://github.com/Atlas-OS/Atlas-Utilities/releases/download/multichoice-v0.4/multichoice-compressed.exe
-   Repository: https://github.com/Atlas-OS/Atlas-Utilities
-   Version: v0.4
-   Renamed to `multichoice.exe`
-   License: [GNU General Public License v3.0](https://github.com/Atlas-OS/utilities/blob/main/LICENSE)
-   Last Verified: 8/9/2023 by Xyueta

## SetTimerResolution & MeasureSleep
- Path: `\AtlasModules\Tools\SetTimerResolution.exe`
    - SHA256 Hash: `FE3CDBE2E332E48921FFA2A9697A66F71472D878154BA331D12ADC7E7C767A2B`
    - Source: https://github.com/amitxv/TimerResolution/releases/download/SetTimerResolution-v0.1.3/SetTimerResolution.exe
    - Version: v0.1.3
- Path: `\AtlasDesktop\3. General Configuration\Power\Timer Resolution\MeasureSleep.exe`
    - SHA256 Hash: `055425A39CE8E766055EE2DE3F4CEE1714BCA31F274BF0C9F658009F551E9E73`
    - Source: https://github.com/amitxv/TimerResolution/releases/download/MeasureSleep-v0.1.6/MeasureSleep.exe
    - Version: v0.1.6
- Repository: https://github.com/amitxv/TimerResolution
- License: [GNU General Public License v3.0](https://github.com/amitxv/TimerResolution/blob/main/LICENSE)
- Last Verified: 8/12/2023 by he3als