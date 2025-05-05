# Liga Contra el Cáncer 📱💙
Una app iOS para gestión de citas médicas en la fundación “Liga Contra el Cáncer”.

---

## Tabla de contenidos

- [Resumen](#resumen)
- [Tecnologías y requisitos](#tecnologías-y-requisitos)
- [Instalación](#instalación)
- [Estructura del proyecto](#estructura-del-proyecto)
- [Documentación](#documentación)
- [Contactar](#contactar)

---

## Resumen

Este proyecto propone la creación de un sistema de gestión de citas para la Liga Contra el Cáncer, con el objetivo de optimizar la atención al paciente y mejorar la eficiencia de la organización. El sistema permitirá a los pacientes agendar citas de forma rápida y sencilla, mientras que la Liga podrá gestionar las citas de manera eficiente, reduciendo tiempos de espera y mejorando la organización de sus recursos.

---

## Tecnologías y requisitos

- **Lenguaje:** Swift 5+
- **Plataforma:** iOS 18.0+
- **IDE:** Xcode 15+
- **Gestión de dependencias:** Swift Package Manager (SPM)
- **Frameworks externos:**
    - Firebase (autenticación y guardado de datos)

---

## Instalación

1. **Clonar el repositorio**

   ```bash
   git clone https://github.com/elAsksito/liga-contra-el-cancer.git
   ```

2. **Abrir en Xcode**

    * Navega hasta la carpeta `liga-contra-el-cancer/ligacontraelcancer.xcodeproj`
    * Abre el archivo `.xcodeproj` con Xcode.

3. **Instalar dependencias**

    * Desde Xcode: `File > Swift Packages > Resolve Package Versions`
    * O en terminal:

      ```bash
      cd liga-contra-el-cancer
      swift package resolve
      ```

4. **Construir y ejecutar**

    * Selecciona el esquema `LigaContraElCancer`
    * Presiona **Run** (⌘R) en tu dispositivo o simulador.

---


## Estructura del proyecto

```
liga-contra-el-cancer/
├── ligacontraelcancer.xcodeproj     # Proyecto Xcode
├── ligacontraelcancer/              # Código fuente principal
│   ├── Assets.xcassets              # Recursos gráficos
│   ├── Base.lproj                   # Archivos Main y LaunchScreen
│   ├── database                     # Capa de datos de la App
│   │   ├── models                   # Modelos de entidades
│   │   ├── service                  # Servicios de Firebase
│   ├── extensions                   # Métodos adicionales para modularizar el código
│   ├── ui                           # ViewControllers de la App
│   ├── utils                        # Funciones y utilidades generales
│   ├── viewmodel                    # Lógica de presentación (MVVM)
│   ├── AppDelegate.swift            # Configuración inicial de la App
│   ├── SceneDelegate.swift          # Gestión de escenas
│   ├── IntroViewController.swift    # Pantalla de introducción
└── README.md                        # Este archivo
```

## Documentación

Puedes revisar la documentación completa del proyecto en Notion:

🔗 [Ver documentación en Notion](https://www.notion.so/1d98e97e466080dabd28e7f89e0db74d?v=1d98e97e4660809daccb000c357e8071&pvs=4)

## Contactar

* **Autor:** Allan Sagastegui. ([@elAsksito](https://github.com/elAsksito))
* **Repositorio:** [https://github.com/elAsksito/liga-contra-el-cancer](https://github.com/elAsksito/liga-contra-el-cancer)
* **Email:** [allxn.sxh@gmail.com](mailto:allxn.sxh@gmail.com)
* **Instagram:** [@_ask.dev](https://www.instagram.com/_ask.dev/)
* **Discord:** [𝔸𝕊𝕂](https://discord.gg/r5xgVvqS3B)

---
