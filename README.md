# 📚 MagaDex

MagaDex es una aplicación desarrollada en **SwiftUI** que permite gestionar y explorar una colección de mangas.  
El proyecto sigue una arquitectura **MVVM (Model-View-ViewModel)** utilizando el nuevo macro **@Observable** para la gestión de estados reactivos.

---

## 🚀 Tecnologías utilizadas

- **SwiftUI** → Framework declarativo para construir interfaces de usuario en iOS.
- **MVVM** → Patrón de arquitectura que separa la lógica de negocio (Model), la lógica de presentación (ViewModel) y la interfaz gráfica (View).
- **@Observable** → Macro moderna que simplifica la gestión de estados y la reactividad en SwiftUI, reemplazando a `ObservableObject` y `@Published`.
- **Xcode** → Entorno de desarrollo utilizado.

---

## 🏗️ Arquitectura MVVM

La aplicación se organiza de la siguiente forma:

- **Model**  
  Contiene las estructuras de datos principales, en este caso los mangas (título, autor, portada, capítulos, etc.).

- **View**  
  Se implementa con SwiftUI y es totalmente declarativa.  
  Solo muestra lo que el ViewModel expone.

- **ViewModel**  
  Implementa la lógica de negocio y utiliza `@Observable` para notificar automáticamente a las vistas cuando hay cambios en los datos.

---

## 📂 Estructura del proyecto

```
MagaDex/
│
├── Models/
│   └── MangaModel.swift
│
├── ViewModels/
│   └── MangasViewModel.swift
│
├── Views/
│   ├── ContentView.swift
│   ├── MangaListView.swift
│   └── MangaDetailView.swift
│
└── Assets/
    └── AppIcon (light/dark mode)
```

---

## ⚙️ Estado Reactivo con @Observable

Ejemplo básico de ViewModel con el macro `@Observable`:

```swift
import SwiftUI

@Observable
class MangaViewModel {
    var mangas: [Manga] = []

    func loadMangas() {
        // Aquí iría la lógica para cargar los datos
        mangas = [
            Manga(title: "Naruto", author: "Masashi Kishimoto"),
            Manga(title: "One Piece", author: "Eiichiro Oda")
        ]
    }
}
```

Y en la vista:

```swift
struct MangaListView: View {
    @State private var viewModel = MangaViewModel()

    var body: some View {
        List(viewModel.mangas) { manga in
            Text(manga.title)
        }
        .onAppear {
            viewModel.loadMangas()
        }
    }
}
```

---

## 🎨 Icono de la App

El proyecto incluye un icono adaptado para **Light Mode** y **Dark Mode**, representando un libro abierto con un círculo rojo inspirado en la bandera de Japón.

---

## 📌 Objetivos

- Practicar el uso de **SwiftUI** y **MVVM**.  
- Aplicar la reactividad con **@Observable**.  
- Implementar una UI simple, clara y mantenible.  

---
👨‍💻 Proyecto de Fin de Máster
