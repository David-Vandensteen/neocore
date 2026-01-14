function Write-Platform {
    New-Item -ItemType Directory -Force -Path out
    $content = "// Auto-generated, do not edit`n#ifndef PLATFORM_H`n#define PLATFORM_H`n`n#define PLATFORM_CD`n`n#endif`n"
    $content | Out-File -FilePath "out/platform.h" -Encoding ASCII -NoNewline
}