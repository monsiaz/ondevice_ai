import Foundation

struct SuggestedPrompt: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let prompt: String
}

struct PromptLibrary {
    static func getPrompts(for language: AppLanguage) -> [SuggestedPrompt] {
        switch language {
        case .french:
            return frenchPrompts
        case .spanish:
            return spanishPrompts
        case .german:
            return germanPrompts
        default:
            return englishPrompts
        }
    }

    // MARK: - English Prompts
    private static let englishPrompts: [SuggestedPrompt] = [
        SuggestedPrompt(
            title: "Summarize a text",
            subtitle: "Extract the key points from a long article.",
            prompt: """
            Summarize the following text in three key bullet points:

            "The rise of on-device AI represents a significant paradigm shift in how we interact with technology. By processing data directly on the user's device, it offers enhanced privacy, lower latency, and offline functionality. Unlike cloud-based AI, which sends data to remote servers, on-device models like Apple's Foundation Models or MLX-optimized variants can perform complex tasks such as language translation, image recognition, and text summarization without an internet connection. This not only makes AI more accessible but also reduces server costs and the carbon footprint associated with large data centers. The main challenges lie in optimizing model size and computational efficiency to fit within the memory and power constraints of mobile hardware, a field where frameworks like MLX are making remarkable progress."
            """
        ),
        SuggestedPrompt(
            title: "Draft a professional email",
            subtitle: "Write a follow-up email after a meeting.",
            prompt: "Draft a professional and concise follow-up email to a client after a project kick-off meeting. Mention that we are excited to start the collaboration and that we will send the detailed project plan by the end of the week."
        ),
        SuggestedPrompt(
            title: "Plan a trip",
            subtitle: "Create a 3-day itinerary for a city break.",
            prompt: "Create a 3-day itinerary for a trip to Paris, focusing on art museums, historical landmarks, and local cuisine. Include at least two restaurant recommendations for each day."
        ),
        SuggestedPrompt(
            title: "Get a recipe",
            subtitle: "Find a recipe based on ingredients you have.",
            prompt: "I have chicken breasts, tomatoes, basil, and pasta. Suggest a simple and quick recipe I can make for dinner tonight. List the ingredients and provide step-by-step instructions."
        ),
        SuggestedPrompt(
            title: "Explain a concept",
            subtitle: "Understand a complex topic in simple terms.",
            prompt: "Explain the concept of 'quantum computing' to me as if I were a high school student. Use an analogy to make it easier to understand."
        ),
        SuggestedPrompt(
            title: "Generate creative ideas",
            subtitle: "Brainstorm names for a new tech startup.",
            prompt: "Generate 5 creative and memorable names for a new tech startup that develops a productivity app focused on personal task management and mindfulness."
        ),
        SuggestedPrompt(
            title: "Translate text",
            subtitle: "Quickly translate a phrase into another language.",
            prompt: "Translate the following English phrase into Spanish: 'Where is the nearest train station, please?'"
        ),
        SuggestedPrompt(
            title: "Write a social media post",
            subtitle: "Create a catchy caption for an Instagram photo.",
            prompt: "Write a short and engaging Instagram caption for a photo of a beautiful sunset over the mountains. Include three relevant hashtags."
        ),
        SuggestedPrompt(
            title: "Explain code",
            subtitle: "Understand a block of code.",
            prompt: """
            Explain what this Python code does in simple terms:

            ```python
            def factorial(n):
                if n == 0:
                    return 1
                else:
                    return n * factorial(n-1)
            ```
            """
        ),
        SuggestedPrompt(
            title: "Correct grammar",
            subtitle: "Proofread and fix mistakes in a sentence.",
            prompt: "Correct the grammar and spelling in the following sentence: 'Their is many reasons why wee should to learn new things, its good for you.'"
        ),
        SuggestedPrompt(
            title: "Create a workout plan",
            subtitle: "Generate a simple weekly workout routine.",
            prompt: "Create a balanced 3-day per week workout plan for a beginner, targeting full-body strength. Include exercises for each day, with sets and reps."
        ),
        SuggestedPrompt(
            title: "Role-play a scenario",
            subtitle: "Practice for a job interview.",
            prompt: "Let's role-play a job interview. You are the interviewer for a Marketing Manager position. Start by asking me the first question."
        ),
        SuggestedPrompt(
            title: "Write a poem",
            subtitle: "Generate a short poem about a topic.",
            prompt: "Write a short, four-line poem about the feeling of rain in the city."
        ),
        SuggestedPrompt(
            title: "Find a fun fact",
            subtitle: "Learn something new and surprising.",
            prompt: "Tell me a fun and surprising fact about the ocean."
        ),
        SuggestedPrompt(
            title: "Classify an item",
            subtitle: "Categorize an item or piece of text.",
            prompt: "Classify the following movie description into a genre (e.g., Sci-Fi, Comedy, Drama): 'A young programmer is selected to participate in a groundbreaking experiment in artificial intelligence by evaluating the human qualities of a highly advanced humanoid A.I.'"
        )
    ]

    // MARK: - French Prompts
    private static let frenchPrompts: [SuggestedPrompt] = [
        SuggestedPrompt(
            title: "Résumer un texte",
            subtitle: "Extraire les points clés d'un long article.",
            prompt: """
            Résumez le texte suivant en trois points clés :
            
            "L'essor de l'IA sur appareil représente un changement de paradigme significatif dans notre interaction avec la technologie. En traitant les données directement sur l'appareil de l'utilisateur, elle offre une confidentialité accrue, une latence plus faible et des fonctionnalités hors ligne. Contrairement à l'IA basée sur le cloud, qui envoie des données à des serveurs distants, les modèles sur appareil comme les Foundation Models d'Apple ou les variantes optimisées pour MLX peuvent effectuer des tâches complexes telles que la traduction, la reconnaissance d'images et le résumé de texte sans connexion Internet. Cela rend non seulement l'IA plus accessible, mais réduit également les coûts de serveur et l'empreinte carbone associée aux grands centres de données. Les principaux défis résident dans l'optimisation de la taille du modèle et de l'efficacité de calcul pour s'adapter aux contraintes de mémoire et de puissance du matériel mobile, un domaine où des frameworks comme MLX font des progrès remarquables."
            """
        ),
        SuggestedPrompt(
            title: "Rédiger un e-mail professionnel",
            subtitle: "Écrire un e-mail de suivi après une réunion.",
            prompt: "Rédigez un e-mail de suivi professionnel et concis à un client après une réunion de lancement de projet. Mentionnez que nous sommes ravis de commencer la collaboration et que nous enverrons le plan de projet détaillé d'ici la fin de la semaine."
        ),
        SuggestedPrompt(
            title: "Planifier un voyage",
            subtitle: "Créer un itinéraire de 3 jours pour un city-break.",
            prompt: "Créez un itinéraire de 3 jours pour un voyage à Rome, axé sur les musées d'art, les monuments historiques et la cuisine locale. Incluez au moins deux recommandations de restaurants pour chaque jour."
        ),
        SuggestedPrompt(
            title: "Obtenir une recette",
            subtitle: "Trouver une recette à partir des ingrédients que vous avez.",
            prompt: "J'ai des poitrines de poulet, des tomates, du basilic et des pâtes. Suggérez une recette simple et rapide que je peux faire pour le dîner ce soir. Listez les ingrédients et fournissez des instructions étape par étape."
        ),
        SuggestedPrompt(
            title: "Expliquer un concept",
            subtitle: "Comprendre un sujet complexe en termes simples.",
            prompt: "Expliquez-moi le concept de 'l'informatique quantique' comme si j'étais un lycéen. Utilisez une analogie pour faciliter la compréhension."
        ),
        SuggestedPrompt(
            title: "Générer des idées créatives",
            subtitle: "Trouver des noms pour une nouvelle startup technologique.",
            prompt: "Générez 5 noms créatifs et mémorables pour une nouvelle startup technologique qui développe une application de productivité axée sur la gestion des tâches personnelles et la pleine conscience."
        ),
        SuggestedPrompt(
            title: "Traduire du texte",
            subtitle: "Traduire rapidement une phrase dans une autre langue.",
            prompt: "Traduisez la phrase anglaise suivante en allemand : 'Where is the nearest train station, please?'"
        ),
        SuggestedPrompt(
            title: "Écrire un post pour les réseaux sociaux",
            subtitle: "Créer une légende accrocheuse pour une photo Instagram.",
            prompt: "Écrivez une légende Instagram courte et engageante pour une photo d'un magnifique coucher de soleil sur les montagnes. Incluez trois hashtags pertinents."
        ),
        SuggestedPrompt(
            title: "Expliquer du code",
            subtitle: "Comprendre un bloc de code.",
            prompt: """
            Expliquez ce que fait ce code Python en termes simples :

            ```python
            def factorial(n):
                if n == 0:
                    return 1
                else:
                    return n * factorial(n-1)
            ```
            """
        ),
        SuggestedPrompt(
            title: "Corriger la grammaire",
            subtitle: "Relire et corriger les erreurs dans une phrase.",
            prompt: "Corrigez la grammaire et l'orthographe dans la phrase suivante : 'Il y a beaucoup raisons pourquoi nous devrions apprendre des nouvelles choses, c'est bon pour toi.'"
        ),
        SuggestedPrompt(
            title: "Créer un plan d'entraînement",
            subtitle: "Générer un programme d'entraînement hebdomadaire simple.",
            prompt: "Créez un plan d'entraînement équilibré de 3 jours par semaine pour un débutant, ciblant la force du corps entier. Incluez des exercices pour chaque jour, avec des séries et des répétitions."
        ),
        SuggestedPrompt(
            title: "Simuler un scénario",
            subtitle: "S'entraîner pour un entretien d'embauche.",
            prompt: "Simulons un entretien d'embauche. Vous êtes l'intervieweur pour un poste de Chef de Produit. Commencez par me poser la première question."
        ),
        SuggestedPrompt(
            title: "Écrire un poème",
            subtitle: "Générer un court poème sur un sujet.",
            prompt: "Écrivez un court poème de quatre lignes sur le sentiment de la pluie en ville."
        ),
        SuggestedPrompt(
            title: "Trouver un fait amusant",
            subtitle: "Apprendre quelque chose de nouveau et de surprenant.",
            prompt: "Donnez-moi un fait amusant et surprenant sur les étoiles."
        ),
        SuggestedPrompt(
            title: "Classifier un élément",
            subtitle: "Catégoriser un élément ou un morceau de texte.",
            prompt: "Classez la description de film suivante dans un genre (par ex., Sci-Fi, Comédie, Drame) : 'Un jeune programmeur est sélectionné pour participer à une expérience révolutionnaire en intelligence artificielle en évaluant les qualités humaines d'une I.A. humanoïde très avancée.'"
        )
    ]
    
    // MARK: - Spanish Prompts
    private static let spanishPrompts: [SuggestedPrompt] = [
        SuggestedPrompt(
            title: "Resumir un texto",
            subtitle: "Extraer los puntos clave de un artículo largo.",
            prompt: """
            Resume el siguiente texto en tres puntos clave:

            "El auge de la IA en el dispositivo representa un cambio de paradigma significativo en cómo interactuamos con la tecnología. Al procesar datos directamente en el dispositivo del usuario, ofrece mayor privacidad, menor latencia y funcionalidad sin conexión. A diferencia de la IA basada en la nube, que envía datos a servidores remotos, los modelos en el dispositivo como los Foundation Models de Apple o las variantes optimizadas para MLX pueden realizar tareas complejas como traducción, reconocimiento de imágenes y resumen de texto sin conexión a Internet. Esto no solo hace que la IA sea más accesible, sino que también reduce los costos de servidor y la huella de carbono asociada con los grandes centros de datos. Los principales desafíos radican en optimizar el tamaño del modelo y la eficiencia computacional para ajustarse a las limitaciones de memoria y energía del hardware móvil, un campo en el que frameworks como MLX están logrando un progreso notable."
            """
        ),
        SuggestedPrompt(
            title: "Redactar un correo profesional",
            subtitle: "Escribir un correo de seguimiento después de una reunión.",
            prompt: "Redacta un correo electrónico de seguimiento profesional y conciso a un cliente después de una reunión de inicio de proyecto. Menciona que estamos entusiasmados por comenzar la colaboración y que enviaremos el plan detallado del proyecto para el final de la semana."
        ),
        SuggestedPrompt(
            title: "Planificar un viaje",
            subtitle: "Crear un itinerario de 3 días para una escapada urbana.",
            prompt: "Crea un itinerario de 3 días para un viaje a Lisboa, centrado en museos de arte, monumentos históricos y gastronomía local. Incluye al menos dos recomendaciones de restaurantes para cada día."
        ),
        SuggestedPrompt(
            title: "Obtener una receta",
            subtitle: "Encontrar una receta basada en los ingredientes que tienes.",
            prompt: "Tengo pechugas de pollo, tomates, albahaca y pasta. Sugiéreme una receta simple y rápida que pueda hacer para la cena de esta noche. Enumera los ingredientes y proporciona instrucciones paso a paso."
        ),
        SuggestedPrompt(
            title: "Explicar un concepto",
            subtitle: "Entender un tema complejo en términos sencillos.",
            prompt: "Explícame el concepto de 'computación cuántica' como si yo fuera un estudiante de secundaria. Usa una analogía para que sea más fácil de entender."
        ),
        SuggestedPrompt(
            title: "Generar ideas creativas",
            subtitle: "Pensar en nombres para una nueva startup tecnológica.",
            prompt: "Genera 5 nombres creativos y memorables para una nueva startup tecnológica que desarrolla una aplicación de productividad centrada en la gestión de tareas personales y el mindfulness."
        ),
        SuggestedPrompt(
            title: "Traducir texto",
            subtitle: "Traducir rápidamente una frase a otro idioma.",
            prompt: "Traduce la siguiente frase en inglés al francés: 'Where is the nearest train station, please?'"
        ),
        SuggestedPrompt(
            title: "Escribir una publicación para redes sociales",
            subtitle: "Crear un pie de foto atractivo para una foto de Instagram.",
            prompt: "Escribe un pie de foto corto y atractivo para una foto de una hermosa puesta de sol sobre el mar. Incluye tres hashtags relevantes."
        ),
        SuggestedPrompt(
            title: "Explicar código",
            subtitle: "Entender un bloque de código.",
            prompt: """
            Explica qué hace este código de Python en términos sencillos:

            ```python
            def factorial(n):
                if n == 0:
                    return 1
                else:
                    return n * factorial(n-1)
            ```
            """
        ),
        SuggestedPrompt(
            title: "Corregir gramática",
            subtitle: "Revisar y corregir errores en una oración.",
            prompt: "Corrige la gramática y la ortografía en la siguiente oración: 'Hay muchas razones por las que nosotros deberíamos aprender cosas nuevas, es bueno para ti.'"
        ),
        SuggestedPrompt(
            title: "Crear un plan de entrenamiento",
            subtitle: "Generar una rutina de ejercicios semanal simple.",
            prompt: "Crea un plan de entrenamiento equilibrado de 3 días a la semana para un principiante, enfocado en la fuerza de todo el cuerpo. Incluye ejercicios para cada día, con series y repeticiones."
        ),
        SuggestedPrompt(
            title: "Interpretar un escenario",
            subtitle: "Practicar para una entrevista de trabajo.",
            prompt: "Vamos a simular una entrevista de trabajo. Tú eres el entrevistador para un puesto de Gerente de Proyectos. Comienza haciéndome la primera pregunta."
        ),
        SuggestedPrompt(
            title: "Escribir un poema",
            subtitle: "Generar un poema corto sobre un tema.",
            prompt: "Escribe un poema corto de cuatro versos sobre la sensación de la nieve en las montañas."
        ),
        SuggestedPrompt(
            title: "Encontrar un dato curioso",
            subtitle: "Aprender algo nuevo y sorprendente.",
            prompt: "Dime un dato curioso y sorprendente sobre el cerebro humano."
        ),
        SuggestedPrompt(
            title: "Clasificar un elemento",
            subtitle: "Categorizar un elemento o un fragmento de texto.",
            prompt: "Clasifica la siguiente descripción de película en un género (p. ej., Ciencia Ficción, Comedia, Drama): 'Un joven programador es seleccionado para participar en un experimento innovador en inteligencia artificial evaluando las cualidades humanas de una I.A. humanoide muy avanzada.'"
        )
    ]

    // MARK: - German Prompts
    private static let germanPrompts: [SuggestedPrompt] = [
        SuggestedPrompt(
            title: "Text zusammenfassen",
            subtitle: "Die wichtigsten Punkte aus einem langen Artikel extrahieren.",
            prompt: """
            Fassen Sie den folgenden Text in drei zentralen Punkten zusammen:

            "Der Aufstieg der On-Device-KI stellt einen bedeutenden Paradigmenwechsel in unserer Interaktion mit Technologie dar. Durch die Verarbeitung von Daten direkt auf dem Gerät des Benutzers bietet sie verbesserten Datenschutz, geringere Latenz und Offline-Funktionalität. Im Gegensatz zur Cloud-basierten KI, die Daten an entfernte Server sendet, können On-Device-Modelle wie Apples Foundation Models oder MLX-optimierte Varianten komplexe Aufgaben wie Sprachübersetzung, Bilderkennung und Textzusammenfassung ohne Internetverbindung durchführen. Dies macht KI nicht nur zugänglicher, sondern reduziert auch Serverkosten und den CO2-Fußabdruck großer Rechenzentren. Die größten Herausforderungen liegen in der Optimierung der Modellgröße und der Recheneffizienz, um den Speicher- und Leistungsbeschränkungen mobiler Hardware gerecht zu werden – ein Bereich, in dem Frameworks wie MLX bemerkenswerte Fortschritte machen."
            """
        ),
        SuggestedPrompt(
            title: "Professionelle E-Mail entwerfen",
            subtitle: "Eine Follow-up-E-Mail nach einem Meeting schreiben.",
            prompt: "Entwerfen Sie eine professionelle und prägnante Follow-up-E-Mail an einen Kunden nach einem Projekt-Kick-off-Meeting. Erwähnen Sie, dass wir uns auf die Zusammenarbeit freuen und den detaillierten Projektplan bis Ende der Woche senden werden."
        ),
        SuggestedPrompt(
            title: "Eine Reise planen",
            subtitle: "Einen 3-tägigen Reiseplan für einen Städtetrip erstellen.",
            prompt: "Erstellen Sie einen 3-tägigen Reiseplan für eine Reise nach Berlin, der sich auf Kunstmuseen, historische Sehenswürdigkeiten und lokale Küche konzentriert. Fügen Sie für jeden Tag mindestens zwei Restaurantempfehlungen hinzu."
        ),
        SuggestedPrompt(
            title: "Ein Rezept erhalten",
            subtitle: "Ein Rezept basierend auf vorhandenen Zutaten finden.",
            prompt: "Ich habe Hähnchenbrust, Tomaten, Basilikum und Nudeln. Schlagen Sie ein einfaches und schnelles Rezept vor, das ich heute Abend zubereiten kann. Listen Sie die Zutaten auf und geben Sie eine schrittweise Anleitung."
        ),
        SuggestedPrompt(
            title: "Ein Konzept erklären",
            subtitle: "Ein komplexes Thema in einfachen Worten verstehen.",
            prompt: "Erklären Sie mir das Konzept des 'Quantencomputings', als wäre ich ein Gymnasiast. Verwenden Sie eine Analogie, um es verständlicher zu machen."
        ),
        SuggestedPrompt(
            title: "Kreative Ideen generieren",
            subtitle: "Namen für ein neues Technologie-Startup brainstormen.",
            prompt: "Generieren Sie 5 kreative und einprägsame Namen für ein neues Technologie-Startup, das eine Produktivitäts-App mit Fokus auf persönliches Aufgabenmanagement und Achtsamkeit entwickelt."
        ),
        SuggestedPrompt(
            title: "Text übersetzen",
            subtitle: "Einen Satz schnell in eine andere Sprache übersetzen.",
            prompt: "Übersetzen Sie den folgenden englischen Satz ins Deutsche: 'Where is the nearest train station, please?'"
        ),
        SuggestedPrompt(
            title: "Einen Social-Media-Beitrag schreiben",
            subtitle: "Eine eingängige Bildunterschrift für ein Instagram-Foto erstellen.",
            prompt: "Schreiben Sie eine kurze und ansprechende Instagram-Bildunterschrift für ein Foto eines wunderschönen Sonnenuntergangs über den Bergen. Fügen Sie drei relevante Hashtags hinzu."
        ),
        SuggestedPrompt(
            title: "Code erklären",
            subtitle: "Einen Codeblock verstehen.",
            prompt: """
            Erklären Sie in einfachen Worten, was dieser Python-Code bewirkt:

            ```python
            def factorial(n):
                if n == 0:
                    return 1
                else:
                    return n * factorial(n-1)
            ```
            """
        ),
        SuggestedPrompt(
            title: "Grammatik korrigieren",
            subtitle: "Einen Satz Korrektur lesen und Fehler beheben.",
            prompt: "Korrigieren Sie die Grammatik und Rechtschreibung im folgenden Satz: 'Es gibt viele Gründe, warum wir sollten neue Dinge lernen, es ist gut für dich.'"
        ),
        SuggestedPrompt(
            title: "Einen Trainingsplan erstellen",
            subtitle: "Eine einfache wöchentliche Trainingsroutine erstellen.",
            prompt: "Erstellen Sie einen ausgewogenen 3-Tage-pro-Woche-Trainingsplan für einen Anfänger, der auf Ganzkörperkraft abzielt. Fügen Sie Übungen für jeden Tag mit Sätzen und Wiederholungen hinzu."
        ),
        SuggestedPrompt(
            title: "Ein Szenario durchspielen",
            subtitle: "Für ein Vorstellungsgespräch üben.",
            prompt: "Lassen Sie uns ein Vorstellungsgespräch im Rollenspiel durchgehen. Sie sind der Interviewer für eine Position als Marketingleiter. Beginnen Sie, indem Sie mir die erste Frage stellen."
        ),
        SuggestedPrompt(
            title: "Ein Gedicht schreiben",
            subtitle: "Ein kurzes Gedicht zu einem Thema generieren.",
            prompt: "Schreiben Sie ein kurzes, vierzeiliges Gedicht über das Gefühl von Regen in der Stadt."
        ),
        SuggestedPrompt(
            title: "Eine lustige Tatsache finden",
            subtitle: "Etwas Neues und Überraschendes lernen.",
            prompt: "Erzählen Sie mir eine lustige und überraschende Tatsache über das Universum."
        ),
        SuggestedPrompt(
            title: "Einen Gegenstand klassifizieren",
            subtitle: "Einen Gegenstand oder Text kategorisieren.",
            prompt: "Klassifizieren Sie die folgende Filmbeschreibung in ein Genre (z. B. Sci-Fi, Komödie, Drama): 'Ein junger Programmierer wird ausgewählt, an einem bahnbrechenden Experiment zur künstlichen Intelligenz teilzunehmen, indem er die menschlichen Qualitäten einer hochentwickelten humanoiden KI bewertet.'"
        )
    ]
}
