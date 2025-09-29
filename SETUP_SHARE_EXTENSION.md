# Setup Share Extension - Guide Visuel

## 🎯 Objectif
Permettre à l'utilisateur de sélectionner du texte dans Safari/Mail et l'analyser directement avec OnDeviceAI via le Share Sheet.

## ⚡ Setup Rapide (5 minutes)

### Étape 1: Créer le Target
1. Ouvre `OnDeviceAI.xcodeproj` dans Xcode
2. Menu: **File > New > Target...**
3. Sélectionne: **iOS > Share Extension**
4. Clique **Next**

### Étape 2: Configurer le Target
Remplis les champs:
- **Product Name**: `OnDeviceAI Share`
- **Team**: (ton Apple Developer Team)
- **Organization Identifier**: `fr.simonazoulay`
- **Bundle Identifier**: `fr.simonazoulay.OnDeviceAI.Share` (auto-généré)
- **Language**: Swift
- **Project**: OnDeviceAI
- **Embed in Application**: OnDeviceAI

Clique **Finish**

⚠️ Si Xcode demande "Activate OnDeviceAI Share scheme?", clique **Cancel** (on utilise le scheme principal)

### Étape 3: Remplacer les Fichiers Générés
Dans le **Project Navigator** (panneau gauche):

1. Trouve le groupe **"OnDeviceAI Share"**
2. Sélectionne `ShareViewController.swift` → Clic droit → **Delete** → **Move to Trash**
3. Sélectionne `Info.plist` → Clic droit → **Delete** → **Move to Trash**

### Étape 4: Ajouter Nos Fichiers
1. Clic droit sur le groupe **"OnDeviceAI Share"**
2. **Add Files to "OnDeviceAI"...**
3. Navigate vers: `OnDeviceAI/Sources/ShareExtension/`
4. Sélectionne:
   - ✅ `ShareViewController.swift`
   - ✅ `ShareExtensionInfo.plist`
5. Options:
   - ☑️ **Copy items if needed**
   - ☑️ **Create groups**
   - Target membership: ☑️ **OnDeviceAI Share** SEULEMENT
6. Clique **Add**

### Étape 5: Configurer le Target

#### 5a. General Tab
1. Sélectionne le target **"OnDeviceAI Share"** (icône bleue dans la liste des targets)
2. Onglet **General**:
   - **Deployment Info**:
     - iOS Deployment Target: **26.0**
   - **Identity**:
     - Bundle Identifier: `fr.simonazoulay.OnDeviceAI.Share`
     - Version: `1.4`
     - Build: `1`

#### 5b. Build Settings Tab
1. Onglet **Build Settings**
2. Cherche (loupe): `Info.plist`
3. **Packaging > Info.plist File**:
   - Change vers: `OnDeviceAI/Sources/ShareExtension/ShareExtensionInfo.plist`

#### 5c. Signing & Capabilities
1. Onglet **Signing & Capabilities**
2. **Automatically manage signing**: ☑️ Coché
3. **Team**: (Sélectionne ton Apple Developer Team)

### Étape 6: Vérifier Build Phases
1. Onglet **Build Phases**
2. Ouvre **Compile Sources**
3. Vérifie que `ShareViewController.swift` est présent
4. Ouvre **Copy Bundle Resources**
5. Si `ShareExtensionInfo.plist` n'est PAS là, c'est normal (géré par Build Settings)

## ✅ Test de l'Extension

### Build Initial
1. Sélectionne le scheme **"OnDeviceAI"** (pas "OnDeviceAI Share")
2. Choose Device/Simulator
3. **Product > Build** (Cmd+B)
4. **Product > Run** (Cmd+R)

### Test dans Safari
1. Lance **Safari** sur ton iPhone/Simulator
2. Ouvre n'importe quel site web
3. Sélectionne du texte
4. Tape le bouton **Share** (carré avec flèche vers le haut)
5. Scroll → Trouve **"Analyze with OnDeviceAI"**
   - Si tu ne le vois pas, tape **"More"** et active-le
6. Tape l'icône → OnDeviceAI s'ouvre avec le texte

## 🐛 Troubleshooting

### "Extension doesn't appear in Share Sheet"
- Rebuild l'app (Clean Build Folder: Shift+Cmd+K, puis Cmd+B)
- Redémarre l'iPhone/Simulator
- Vérifie que Bundle ID est correct: `fr.simonazoulay.OnDeviceAI.Share`

### "Scheme activation popup keeps appearing"
- Clique **Cancel** et sélectionne manuellement le scheme **OnDeviceAI** principal

### "Build fails with 'Info.plist not found'"
- Vérifie Build Settings > Packaging > Info.plist File
- Path doit être: `OnDeviceAI/Sources/ShareExtension/ShareExtensionInfo.plist`

### "Extension crashes on launch"
- Vérifie que `ShareViewController.swift` est bien dans **Compile Sources**
- Vérifie que le target membership est correct

## 🎉 C'est Fait!

Maintenant tu peux:
- Sélectionner du texte dans **Safari, Mail, Notes, Messages**
- Taper **Share > Analyze with OnDeviceAI**
- L'app s'ouvre et analyse le texte automatiquement

## 📝 Notes Techniques

### URL Scheme
L'extension utilise le URL scheme `ondeviceai://analyze?text=...` enregistré dans `Info.plist`

### Permissions
Aucune permission supplémentaire nécessaire - l'extension hérite des permissions de l'app principale

### Distribution
Lors de la soumission App Store:
- Archive **OnDeviceAI** (pas l'extension séparément)
- L'extension sera automatiquement incluse dans le bundle
