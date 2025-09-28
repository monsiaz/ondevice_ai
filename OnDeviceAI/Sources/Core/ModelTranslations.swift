import Foundation

struct ModelTranslations {
    static func getDescription(for modelName: String, language: AppLanguage) -> String {
        switch language {
        case .english: return englishDescriptions[modelName] ?? ""
        case .french: return frenchDescriptions[modelName] ?? englishDescriptions[modelName] ?? ""
        case .spanish: return spanishDescriptions[modelName] ?? englishDescriptions[modelName] ?? ""
        case .german: return germanDescriptions[modelName] ?? englishDescriptions[modelName] ?? ""
        }
    }
    
    static func getTags(for modelName: String, language: AppLanguage) -> [String] {
        switch language {
        case .english: return englishTags[modelName] ?? []
        case .french: return frenchTags[modelName] ?? englishTags[modelName] ?? []
        case .spanish: return spanishTags[modelName] ?? englishTags[modelName] ?? []
        case .german: return germanTags[modelName] ?? englishTags[modelName] ?? []
        }
    }
    
    // English descriptions
    private static let englishDescriptions: [String: String] = [
        "qwen2.5-0.5b-instruct": "Ultra-fast responses, ideal for quick questions, basic conversations, and simple tasks. Minimal resource usage with instant replies. Perfect for testing on-device AI.",
        "tinyllama-1.1b-chat": "Smallest Llama variant optimized for chat. Lightning-fast responses with good conversational abilities. Excellent for casual interactions and quick Q&A sessions.",
        "qwen2.5-1.5b-instruct": "Alibaba's compact model with excellent speed/quality balance. Strong multilingual support, good reasoning capabilities. Ideal for daily conversations and content creation.",
        "gemma-2-2b-instruct": "Google's efficient 2B model optimized for creative tasks. Excellent at writing, storytelling, and content generation. Balanced performance with creative flair.",
        "phi-3-mini-4k": "Microsoft's compact model with excellent reasoning capabilities. Strong logical thinking, problem-solving, and analytical tasks. Great for educational content.",
        "llama-3.2-3b-instruct": "Meta's latest 3B model, excellent for natural conversations and text analysis. Strong instruction-following with balanced performance across diverse tasks.",
        "mistral-nemo-12b": "Mistral's advanced model with sophisticated reasoning and multilingual capabilities. Excellent for complex analysis, research tasks, and international content.",
        "deepseek-coder-1.3b": "DeepSeek's specialized coding model. Excellent for programming assistance, code explanation, debugging, and technical documentation. Supports multiple languages.",
        "llama-3.1-8b-instruct": "Meta's flagship 8B model delivering high-quality responses. Excellent for complex reasoning, creative writing, detailed analysis, and professional content creation.",
        "gemma-2-9b-instruct": "Google's powerful 9B model for demanding applications. Superior creative writing, advanced reasoning, and nuanced conversations. Top-tier quality.",
        "qwen2.5-7b-instruct": "Alibaba's flagship 7B model with exceptional multilingual support. Advanced reasoning across languages, cultural awareness, and sophisticated text understanding.",
        "llava-1.6-mistral-7b": "Advanced vision-language model combining Mistral's text capabilities with image understanding. Analyze photos, describe scenes, extract text from images.",
        "moondream2": "Compact yet powerful vision model for image understanding. Fast image analysis, scene description, and visual Q&A. Optimized for mobile vision tasks.",
        "code-llama-7b-instruct": "Meta's specialized 7B coding assistant. Advanced programming help, code generation, debugging, algorithm explanation, and software architecture guidance.",
        "solar-10.7b-instruct": "Upstage's premium 10.7B model for complex reasoning and analysis. State-of-the-art performance for research, detailed explanations, and sophisticated tasks.",
        
        // Nouveaux modèles
        "OpenELM-450M-Instruct-4bit": "Apple's extremely efficient and lightweight instruction-following model.",
        "Qwen2-7B-Instruct-4bit": "A powerful model from Alibaba with strong multilingual capabilities."
    ]
    
    // French descriptions
    private static let frenchDescriptions: [String: String] = [
        "qwen2.5-0.5b-instruct": "Réponses ultra-rapides, idéal pour questions rapides, conversations basiques et tâches simples. Usage minimal des ressources avec réponses instantanées.",
        "tinyllama-1.1b-chat": "Plus petite variante Llama optimisée pour le chat. Réponses ultra-rapides avec bonnes capacités conversationnelles. Excellent pour interactions décontractées.",
        "qwen2.5-1.5b-instruct": "Modèle compact d'Alibaba avec excellent équilibre vitesse/qualité. Support multilingue fort, bonnes capacités de raisonnement. Idéal pour conversations quotidiennes.",
        "gemma-2-2b-instruct": "Modèle efficace 2B de Google optimisé pour tâches créatives. Excellent en écriture, narration et génération de contenu. Performance équilibrée avec flair créatif.",
        "phi-3-mini-4k": "Modèle compact de Microsoft avec excellentes capacités de raisonnement. Pensée logique forte, résolution de problèmes et tâches analytiques.",
        "llama-3.2-3b-instruct": "Dernier modèle 3B de Meta, excellent pour conversations naturelles et analyse de texte. Bon suivi d'instructions avec performance équilibrée.",
        "mistral-nemo-12b": "Modèle avancé de Mistral avec raisonnement sophistiqué et capacités multilingues. Excellent pour analyses complexes et contenu international.",
        "deepseek-coder-1.3b": "Modèle de codage spécialisé DeepSeek. Excellent pour assistance programmation, explication de code, débogage et documentation technique.",
        "llama-3.1-8b-instruct": "Modèle phare 8B de Meta délivrant réponses haute qualité. Excellent pour raisonnement complexe, écriture créative et création de contenu professionnel.",
        "gemma-2-9b-instruct": "Modèle puissant 9B de Google pour applications exigeantes. Écriture créative supérieure, raisonnement avancé et conversations nuancées.",
        "qwen2.5-7b-instruct": "Modèle phare 7B d'Alibaba avec support multilingue exceptionnel. Raisonnement avancé entre langues, conscience culturelle et compréhension sophistiquée.",
        "llava-1.6-mistral-7b": "Modèle vision-langage avancé combinant capacités texte Mistral avec compréhension d'images. Analyse photos, décrit scènes, extrait texte.",
        "moondream2": "Modèle vision compact mais puissant pour compréhension d'images. Analyse rapide, description de scènes et Q&R visuelles.",
        "code-llama-7b-instruct": "Assistant de codage spécialisé 7B de Meta. Aide programmation avancée, génération de code, débogage et guidance architecture logicielle.",
        "solar-10.7b-instruct": "Modèle premium 10.7B d'Upstage pour raisonnement et analyse complexes. Performance de pointe pour recherche et tâches sophistiquées.",

        // Nouveaux modèles
        "OpenELM-450M-Instruct-4bit": "Modèle d'Apple extrêmement efficace et léger pour le suivi d'instructions.",
        "Qwen2-7B-Instruct-4bit": "Un modèle puissant d'Alibaba avec de fortes capacités multilingues."
    ]
    
    // Spanish descriptions
    private static let spanishDescriptions: [String: String] = [
        "qwen2.5-0.5b-instruct": "Respuestas ultra-rápidas, ideal para preguntas rápidas, conversaciones básicas y tareas simples. Uso mínimo de recursos con respuestas instantáneas.",
        "tinyllama-1.1b-chat": "Variante más pequeña de Llama optimizada para chat. Respuestas ultra-rápidas con buenas habilidades conversacionales. Excelente para interacciones casuales.",
        "qwen2.5-1.5b-instruct": "Modelo compacto de Alibaba con excelente equilibrio velocidad/calidad. Fuerte soporte multilingüe, buenas capacidades de razonamiento.",
        "gemma-2-2b-instruct": "Modelo eficiente 2B de Google optimizado para tareas creativas. Excelente en escritura, narración y generación de contenido.",
        "phi-3-mini-4k": "Modelo compacto de Microsoft con excelentes capacidades de razonamiento. Pensamiento lógico fuerte, resolución de problemas y tareas analíticas.",
        "llama-3.2-3b-instruct": "Último modelo 3B de Meta, excelente para conversaciones naturales y análisis de texto. Buen seguimiento de instrucciones.",
        "mistral-nemo-12b": "Modelo avanzado de Mistral con razonamiento sofisticado y capacidades multilingües. Excelente para análisis complejos.",
        "deepseek-coder-1.3b": "Modelo de codificación especializado DeepSeek. Excelente para asistencia de programación, explicación de código y documentación técnica.",
        "llama-3.1-8b-instruct": "Modelo insignia 8B de Meta que entrega respuestas de alta calidad. Excelente para razonamiento complejo y escritura creativa.",
        "gemma-2-9b-instruct": "Modelo potente 9B de Google para aplicaciones exigentes. Escritura creativa superior, razonamiento avanzado y conversaciones matizadas.",
        "qwen2.5-7b-instruct": "Modelo insignia 7B de Alibaba con soporte multilingüe excepcional. Razonamiento avanzado entre idiomas y comprensión sofisticada.",
        "llava-1.6-mistral-7b": "Modelo avanzado visión-lenguaje que combina capacidades de texto Mistral con comprensión de imágenes. Analiza fotos y describe escenas.",
        "moondream2": "Modelo de visión compacto pero potente para comprensión de imágenes. Análisis rápido de imágenes y descripción de escenas.",
        "code-llama-7b-instruct": "Asistente de codificación especializado 7B de Meta. Ayuda avanzada de programación, generación de código y orientación de arquitectura.",
        "solar-10.7b-instruct": "Modelo premium 10.7B de Upstage para razonamiento y análisis complejos. Rendimiento de vanguardia para investigación y tareas sofisticadas.",

        // Nouveaux modèles
        "OpenELM-450M-Instruct-4bit": "Modelo de Apple extremadamente eficiente y ligero para seguir instrucciones.",
        "Qwen2-7B-Instruct-4bit": "Un potente modelo de Alibaba con fuertes capacidades multilingües."
    ]
    
    // German descriptions
    private static let germanDescriptions: [String: String] = [
        "qwen2.5-0.5b-instruct": "Ultra-schnelle Antworten, ideal für schnelle Fragen, grundlegende Gespräche und einfache Aufgaben. Minimaler Ressourcenverbrauch mit sofortigen Antworten.",
        "tinyllama-1.1b-chat": "Kleinste Llama-Variante optimiert für Chat. Blitzschnelle Antworten mit guten Gesprächsfähigkeiten. Ausgezeichnet für lockere Interaktionen.",
        "qwen2.5-1.5b-instruct": "Alibabas kompaktes Modell mit exzellentem Geschwindigkeit/Qualität-Verhältnis. Starke mehrsprachige Unterstützung, gute Denkfähigkeiten.",
        "gemma-2-2b-instruct": "Googles effizientes 2B-Modell optimiert für kreative Aufgaben. Ausgezeichnet beim Schreiben, Geschichtenerzählen und Inhaltsgenerierung.",
        "phi-3-mini-4k": "Microsofts kompaktes Modell mit ausgezeichneten Denkfähigkeiten. Starkes logisches Denken, Problemlösung und analytische Aufgaben.",
        "llama-3.2-3b-instruct": "Metas neuestes 3B-Modell, ausgezeichnet für natürliche Gespräche und Textanalyse. Gute Anweisungsbefolgung mit ausgewogener Leistung.",
        "mistral-nemo-12b": "Mistrals fortgeschrittenes Modell mit sophistiziertem Denken und mehrsprachigen Fähigkeiten. Ausgezeichnet für komplexe Analysen.",
        "deepseek-coder-1.3b": "DeepSeeks spezialisiertes Codierungsmodell. Ausgezeichnet für Programmierunterstützung, Codeerklärung, Debugging und technische Dokumentation.",
        "llama-3.1-8b-instruct": "Metas Flaggschiff 8B-Modell mit hochwertigen Antworten. Ausgezeichnet für komplexes Denken, kreatives Schreiben und professionelle Inhaltserstellung.",
        "gemma-2-9b-instruct": "Googles mächtiges 9B-Modell für anspruchsvolle Anwendungen. Überlegenes kreatives Schreiben, fortgeschrittenes Denken und nuancierte Gespräche.",
        "qwen2.5-7b-instruct": "Alibabas Flaggschiff 7B-Modell mit außergewöhnlicher mehrsprachiger Unterstützung. Fortgeschrittenes Denken zwischen Sprachen.",
        "llava-1.6-mistral-7b": "Fortgeschrittenes Vision-Sprache-Modell, das Mistrals Textfähigkeiten mit Bildverständnis kombiniert. Analysiert Fotos und beschreibt Szenen.",
        "moondream2": "Kompaktes aber mächtiges Vision-Modell für Bildverständnis. Schnelle Bildanalyse, Szenenbeschreibung und visuelle Q&A.",
        "code-llama-7b-instruct": "Metas spezialisierter 7B-Codierassistent. Fortgeschrittene Programmierhilfe, Codegenerierung, Debugging und Software-Architektur-Anleitung.",
        "solar-10.7b-instruct": "Upstages Premium 10.7B-Modell für komplexes Denken und Analyse. Modernste Leistung für Forschung und anspruchsvolle Aufgaben.",
        
        // Nouveaux modèles
        "OpenELM-450M-Instruct-4bit": "Apples extrem effizientes und leichtes Modell zur Befolgung von Anweisungen.",
        "Qwen2-7B-Instruct-4bit": "Ein leistungsstarkes Modell von Alibaba mit starken mehrsprachigen Fähigkeiten."
    ]
    
    // English tags
    private static let englishTags: [String: [String]] = [
        "qwen2.5-0.5b-instruct": ["Ultra Fast", "Basic", "Recommended"],
        "tinyllama-1.1b-chat": ["Ultra Fast", "Chat", "Tiny"],
        "qwen2.5-1.5b-instruct": ["Fast", "Balanced", "Multilingual"],
        "gemma-2-2b-instruct": ["Fast", "Creative", "Google"],
        "phi-3-mini-4k": ["Fast", "Reasoning", "Microsoft"],
        "llama-3.2-3b-instruct": ["Balanced", "Conversations", "Meta"],
        "mistral-nemo-12b": ["Advanced", "Multilingual", "Reasoning"],
        "deepseek-coder-1.3b": ["Fast", "Coding", "Technical"],
        "llama-3.1-8b-instruct": ["High Quality", "Complex Tasks", "Meta"],
        "gemma-2-9b-instruct": ["High Quality", "Creative", "Google"],
        "qwen2.5-7b-instruct": ["High Quality", "Multilingual", "Flagship"],
        "llava-1.6-mistral-7b": ["Vision", "Image Analysis", "Multimodal"],
        "moondream2": ["Vision", "Compact", "Fast"],
        "code-llama-7b-instruct": ["Coding", "Programming", "Meta"],
        "solar-10.7b-instruct": ["Premium", "Reasoning", "Advanced"],
        
        // Nouveaux modèles
        "OpenELM-450M-Instruct-4bit": ["Apple", "Efficient", "Tiny"],
        "Qwen2-7B-Instruct-4bit": ["Multilingual", "Flagship", "Qwen"]
    ]
    
    // French tags
    private static let frenchTags: [String: [String]] = [
        "qwen2.5-0.5b-instruct": ["Ultra Rapide", "Basique", "Recommandé"],
        "tinyllama-1.1b-chat": ["Ultra Rapide", "Chat", "Petit"],
        "qwen2.5-1.5b-instruct": ["Rapide", "Équilibré", "Multilingue"],
        "gemma-2-2b-instruct": ["Rapide", "Créatif", "Google"],
        "phi-3-mini-4k": ["Rapide", "Raisonnement", "Microsoft"],
        "llama-3.2-3b-instruct": ["Équilibré", "Conversations", "Meta"],
        "mistral-nemo-12b": ["Avancé", "Multilingue", "Raisonnement"],
        "deepseek-coder-1.3b": ["Rapide", "Codage", "Technique"],
        "llama-3.1-8b-instruct": ["Haute Qualité", "Tâches Complexes", "Meta"],
        "gemma-2-9b-instruct": ["Haute Qualité", "Créatif", "Google"],
        "qwen2.5-7b-instruct": ["Haute Qualité", "Multilingue", "Phare"],
        "llava-1.6-mistral-7b": ["Vision", "Analyse Image", "Multimodal"],
        "moondream2": ["Vision", "Compact", "Rapide"],
        "code-llama-7b-instruct": ["Codage", "Programmation", "Meta"],
        "solar-10.7b-instruct": ["Premium", "Raisonnement", "Avancé"],

        // Nouveaux modèles
        "OpenELM-450M-Instruct-4bit": ["Apple", "Efficace", "Minuscule"],
        "Qwen2-7B-Instruct-4bit": ["Multilingue", "Phare", "Qwen"]
    ]
    
    // Spanish tags
    private static let spanishTags: [String: [String]] = [
        "qwen2.5-0.5b-instruct": ["Ultra Rápido", "Básico", "Recomendado"],
        "tinyllama-1.1b-chat": ["Ultra Rápido", "Chat", "Pequeño"],
        "qwen2.5-1.5b-instruct": ["Rápido", "Equilibrado", "Multilingüe"],
        "gemma-2-2b-instruct": ["Rápido", "Creativo", "Google"],
        "phi-3-mini-4k": ["Rápido", "Razonamiento", "Microsoft"],
        "llama-3.2-3b-instruct": ["Equilibrado", "Conversaciones", "Meta"],
        "mistral-nemo-12b": ["Avanzado", "Multilingüe", "Razonamiento"],
        "deepseek-coder-1.3b": ["Rápido", "Codificación", "Técnico"],
        "llama-3.1-8b-instruct": ["Alta Calidad", "Tareas Complejas", "Meta"],
        "gemma-2-9b-instruct": ["Alta Calidad", "Creativo", "Google"],
        "qwen2.5-7b-instruct": ["Alta Calidad", "Multilingüe", "Insignia"],
        "llava-1.6-mistral-7b": ["Visión", "Análisis Imagen", "Multimodal"],
        "moondream2": ["Visión", "Compacto", "Rápido"],
        "code-llama-7b-instruct": ["Codificación", "Programación", "Meta"],
        "solar-10.7b-instruct": ["Premium", "Razonamiento", "Avanzado"],
        
        // Nouveaux modèles
        "OpenELM-450M-Instruct-4bit": ["Apple", "Eficiente", "Diminuto"],
        "Qwen2-7B-Instruct-4bit": ["Multilingüe", "Insignia", "Qwen"]
    ]
    
    // German tags
    private static let germanTags: [String: [String]] = [
        "qwen2.5-0.5b-instruct": ["Ultra Schnell", "Grundlegend", "Empfohlen"],
        "tinyllama-1.1b-chat": ["Ultra Schnell", "Chat", "Klein"],
        "qwen2.5-1.5b-instruct": ["Schnell", "Ausgewogen", "Mehrsprachig"],
        "gemma-2-2b-instruct": ["Schnell", "Kreativ", "Google"],
        "phi-3-mini-4k": ["Schnell", "Denken", "Microsoft"],
        "llama-3.2-3b-instruct": ["Ausgewogen", "Gespräche", "Meta"],
        "mistral-nemo-12b": ["Fortgeschritten", "Mehrsprachig", "Denken"],
        "deepseek-coder-1.3b": ["Schnell", "Codierung", "Technisch"],
        "llama-3.1-8b-instruct": ["Hohe Qualität", "Komplexe Aufgaben", "Meta"],
        "gemma-2-9b-instruct": ["Hohe Qualität", "Kreativ", "Google"],
        "qwen2.5-7b-instruct": ["Hohe Qualität", "Mehrsprachig", "Flaggschiff"],
        "llava-1.6-mistral-7b": ["Vision", "Bildanalyse", "Multimodal"],
        "moondream2": ["Vision", "Kompakt", "Schnell"],
        "code-llama-7b-instruct": ["Codierung", "Programmierung", "Meta"],
        "solar-10.7b-instruct": ["Premium", "Denken", "Fortgeschritten"],
        
        // Nouveaux modèles
        "OpenELM-450M-Instruct-4bit": ["Apple", "Effizient", "Winzig"],
        "Qwen2-7B-Instruct-4bit": ["Mehrsprachig", "Flaggschiff", "Qwen"]
    ]
}
