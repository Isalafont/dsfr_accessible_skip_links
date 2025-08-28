# DsfrAccessibleSkipLinks

Une gem Ruby qui aide les projets à implémenter des liens d’évitement accessibles conformément au Système de design de l’État français (DSFR). Cette gem fournit des helpers et utilitaires pour créer des liens d’évitement de navigation qui améliorent l’accessibilité du web.

## Installation

Ajoutez cette ligne au Gemfile de votre application :

```ruby
gem 'dsfr_accessible_skip_links'
```

Puis installez la gem :

    $ bundle install

Lancez l’installateur pour configurer les liens d’évitement dans votre application Rails :

    $ bin/rails g dsfr_accessible_skip_links:install

Cela va :
- Copier le partial des liens d’évitement vers `app/views/shared/_skip_links.html.erb`
- Afficher des instructions pour l’ajouter à votre layout

**Étape suivante :** Ajoutez l’appel à `render` dans votre layout (généralement `app/views/layouts/application.html.erb`) :

```erb
<body>
  <%= render 'shared/skip_links' %>
  <!-- le reste de votre contenu -->
</body>
```

**Option d’installation rapide :** utilisez l’option `--inject-layout` pour ajouter automatiquement l’appel à `render` :

    $ bin/rails g dsfr_accessible_skip_links:install --inject-layout

Vous pouvez aussi installer directement la gem :

    $ gem install dsfr_accessible_skip_links

## Utilisation

### Éléments requis

Assurez‑vous que votre layout contient ces éléments avec les bons identifiants (ID) :

```erb
<header id="header">
  <!-- votre navigation -->
</header>

<main id="content">
  <%= yield %>
</main>

<footer id="footer">
  <!-- votre pied de page -->
</footer>
```

La gem s’intègre automatiquement à Rails via un Rails Engine. Les méthodes helper sont disponibles automatiquement dans tous les contrôleurs et vues.

### Liens d’évitement par défaut

Par défaut, la gem fournit trois liens d’évitement :
- **« Aller au contenu »** → `#content`
- **« Menu »** → `#header`  
- **« Pied de page »** → `#footer`

### Liens d’évitement personnalisés

Vous pouvez personnaliser les liens d’évitement page par page grâce à `content_for` de Rails :

```erb
<% content_for :skip_links do %>
  <%= skip_link('Aller au contenu principal', 'main-section') %>
  <%= skip_link('Aller à la navigation spéciale', 'special-nav') %>
  <%= skip_link('Aller aux résultats', 'results') %>
<% end %>
```

### Texte du lien vers le contenu

Vous pouvez personnaliser le texte du lien vers le contenu principal :

```erb
<% content_for :content_skip_link_text, 'Aller au contenu principal' %>
```

### Liens préfixés par « tab- »

Pour les liens nécessitant une interaction JavaScript, utilisez le préfixe `tab-` :

```erb
<%= skip_link('Navigation par onglet', 'tab-special-section') %>
```

Cela ajoutera un attribut `data-anchor` pour la gestion côté JavaScript.

### Méthodes helper

La gem fournit ces méthodes helper (disponibles automatiquement dans les contrôleurs et vues) :

- `skip_link(text, anchor)` - Crée un lien d’évitement
- `default_skip_links` - Renvoie l’ensemble par défaut de liens d’évitement
- `skip_links_content` - Renvoie les liens personnalisés ou, à défaut, les liens par défaut
- `content_skip_link_text` - Renvoie le texte du lien vers le contenu

### Classes CSS

La gem utilise les classes CSS officielles du DSFR :
- `.fr-skiplinks` - Conteneur principal
- `.fr-container` - Conteneur DSFR
- `.fr-skiplinks__list` - Liste des liens
- `.fr-link` - Style du lien individuel

### Structure HTML

Le HTML généré suit cette structure :

```html
<div class="fr-skiplinks">
  <nav class="fr-container" role="navigation" aria-label="Accès rapide">
    <ul class="fr-skiplinks__list">
      <li><a class="fr-link" href="#content">Aller au contenu</a></li>
      <li><a class="fr-link" href="#header">Menu</a></li>
      <li><a class="fr-link" href="#footer">Pied de page</a></li>
    </ul>
  </nav>
</div>
```

## Validation des liens d’évitement

La gem inclut un service de validation pour s’assurer que les liens d’évitement sont correctement implémentés dans votre application pendant les tests.

### SkipLinksImplementedChecker

Le service `SkipLinksImplementedChecker` vérifie automatiquement que les pages :
- ont des liens d’évitement personnalisés définis via `content_for(:skip_links)`, ou
- sont incluses dans votre configuration de routes en liste blanche (whitelist)

Cette validation s’exécute automatiquement en environnement de test lorsque les liens d’évitement sont rendus.

### Configuration

Configurez les routes qui doivent être exemptées de la validation des liens d’évitement :

```ruby
# config/initializers/dsfr_accessible_skip_links.rb
DsfrAccessibleSkipLinks.configure do |config|
  config.whitelisted_routes = [
    'pages#home',
    'pages#about',
    'admin/dashboard#index',
    'users#show',
    'posts#index'
  ]
end
```

### Désactiver la validation

Si votre projet dispose déjà de son propre système de validation des liens d’évitement, vous pouvez désactiver la validation intégrée de la gem :

```ruby
# config/initializers/dsfr_accessible_skip_links.rb
DsfrAccessibleSkipLinks.configure do |config|
  config.disable_validation = true
end
```

Lorsque `disable_validation` est défini à `true` :
- `SkipLinksImplementedChecker` ne s’exécute pas automatiquement dans les tests
- Vous pouvez toujours utiliser les helpers de la gem pour générer les liens d’évitement
- Aucune erreur de validation n’est levée, vous gardez la main sur les contrôles d’accessibilité

### Utilisation manuelle

Vous pouvez aussi utiliser le vérificateur manuellement dans vos tests ou votre application :

```ruby
# Dans un contrôleur ou un test
checker = DsfrAccessibleSkipLinks::SkipLinksImplementedChecker.new(
  controller_name: 'posts',
  action_name: 'show',
  has_skip_links: content_for?(:skip_links)
)

begin
  checker.perform!
  # Les liens d’évitement sont correctement configurés
rescue DsfrAccessibleSkipLinks::SkipLinksImplementedChecker::SkipLinksNotDefinedError => e
  # Gérer l’absence de liens d’évitement
  puts e.message
end
```

### Intégration dans les tests Rails

La validation s’exécute automatiquement pendant les tests. Si une page n’a pas de liens d’évitement et n’est pas en liste blanche, vous verrez :

```
DsfrAccessibleSkipLinks::SkipLinksImplementedChecker::SkipLinksNotDefinedError: 
No skip links defined for this page (posts#show). Use content_for(:skip_links) 
to define skip links or define them in a view-specific helper.
```

Pour corriger cela, soit :
1. Ajoutez la route à votre configuration de liste blanche
2. Définissez des liens d’évitement personnalisés dans votre vue :

```erb
<% content_for :skip_links do %>
  <%= skip_link('Aller au contenu', 'main-content') %>
  <%= skip_link('Aller aux commentaires', 'comments') %>
<% end %>
```

## Fonctionnalités d’accessibilité

Cette gem implémente des liens d’évitement conformément aux [WCAG 2.2](https://www.w3.org/WAI/WCAG22/quickref/) et aux spécifications du [DSFR (Système de design de l’État français)](https://www.systeme-de-design.gouv.fr/).

### Conformité aux standards
- **WCAG 2.2 niveau AA** : conforme aux standards internationaux d’accessibilité
- **Recommandations DSFR** : suit les exigences d’accessibilité du système de design de l’État
- **RGAA 4.1** : compatible avec le Référentiel Général d’Amélioration de l’Accessibilité

### Caractéristiques techniques
- **HTML sémantique** : structure adéquate avec l’élément `<nav>` et `role="navigation"`
- **Compatibilité lecteurs d’écran** : `aria-label="Accès rapide"` descriptif pour les aides techniques
- **Navigation au clavier** : accessibilité complète avec gestion correcte du focus
- **Aller au contenu** : navigation directe vers les zones principales (#content, #header, #footer)
- **Design visuel** : compatible avec les classes CSS officielles du DSFR pour un style cohérent

### Assurance qualité
- **Validation automatisée** : un vérificateur intégré évite d’oublier les liens d’évitement
- **Intégration aux tests** : vérifie la présence des liens pendant les exécutions de test
- **Validation configurable** : liste blanche des routes ne nécessitant pas de liens d’évitement
- **Retour développeur** : messages d’erreur clairs pour guider l’implémentation

### Intégration DSFR
Cette gem implémente le composant officiel [liens d’évitement DSFR](https://www.systeme-de-design.gouv.fr/elements-d-interface/composants/liens-d-evitement) en respectant :
- Les classes CSS officielles (`.fr-skiplinks`, `.fr-container`, `.fr-skiplinks__list`, `.fr-link`)
- La structure HTML recommandée et les attributs ARIA
- Les libellés en français par défaut pour les sites publics
- La compatibilité responsive

### Bénéfices en accessibilité
- **Navigation plus rapide** : les utilisateurs de lecteurs d’écran et au clavier peuvent aller directement au contenu
- **Charge cognitive réduite** : une structure claire améliore l’expérience utilisateur
- **Conformité réglementaire** : aide à satisfaire les exigences françaises pour le secteur public
- **Conception universelle** : profite à tous, notamment aux personnes avec déficiences motrices ou visuelles

Pour en savoir plus sur les exigences d’accessibilité web en France :
- [Documentation officielle DSFR](https://www.systeme-de-design.gouv.fr/)
- [RGAA](https://www.numerique.gouv.fr/publications/rgaa-accessibilite/)
- [WCAG 2.2](https://www.w3.org/WAI/WCAG22/quickref/)

## Comment tester cette gem

Il y a deux façons principales de tester cette gem :

1) Exécuter la suite de tests localement (rapide, pas besoin d’une app Rails)
- Installer les dépendances :
  ```bash
  bundle install
  ```
- Lancer RSpec :
  ```bash
  bundle exec rake spec
  ```
- Lancer RuboCop :
  ```bash
  bundle exec rake rubocop
  ```
- Lancer les deux (tâche par défaut) :
  ```bash
  bundle exec rake
  ```

2) L’essayer dans une vraie application Rails (pour tester le générateur et l’intégration)
- Créer une nouvelle application Rails (ou utiliser une existante) :
  ```bash
  rails new demo_app --skip-javascript --skip-hotwire --skip-action-mailbox --skip-action-text --skip-active-storage --skip-active-job --skip-system-test
  cd demo_app
  ```
- Pointer l’app vers votre copie locale de cette gem. Dans demo_app/Gemfile, ajoutez :
  ```ruby
  gem 'dsfr_accessible_skip_links', path: '../path/to/your/dsfr_accessible_skip_links'
  ```
  Puis exécutez :
  ```bash
  bundle install
  ```
- Lancer l’installateur :
  ```bash
  bin/rails g dsfr_accessible_skip_links:install
  ```
- Vérifier que le partial existe : `app/views/shared/_skip_links.html.erb`
- Ajouter l’appel au partial dans votre layout et vérifier la présence des éléments HTML requis (voir section Utilisation ci‑dessus)
- Démarrer le serveur et vérifier les liens d’évitement en haut de la page :
  ```bash
  bin/rails s
  ```
  Rendez‑vous sur http://localhost:3000 et repérez le balisage des liens d’évitement
  (« Aller au contenu », « Menu », « Pied de page »).

**Notes :**
- Le générateur est idempotent : il n’insérera pas la ligne `render` deux fois si elle existe déjà.

### Mettre en place la validation des liens d’évitement

Après avoir installé la gem, créez un initializer pour configurer les routes en liste blanche :

```bash
# Créer le fichier d’initialisation
touch config/initializers/dsfr_accessible_skip_links.rb
```

Ajoutez votre configuration :

```ruby
# config/initializers/dsfr_accessible_skip_links.rb
DsfrAccessibleSkipLinks.configure do |config|
  config.whitelisted_routes = [
    # Pages d’atterrissage utilisant les liens d’évitement par défaut
    'pages#home',
    'pages#about',
    'pages#contact',
    
    # Pages d’admin avec layout standard
    'admin/dashboard#index',
    'admin/users#index',
    
    # Endpoints d’API ou pages sans layout standard
    'api/health#check',
    'errors#not_found'
  ]
end
```

Cette configuration garantit que :
- Les routes listées ne déclencheront pas d’erreurs de validation dans les tests
- Les pages hors liste blanche doivent définir des liens d’évitement personnalisés
- Vous maintenez la conformité d’accessibilité dans toute votre application

## Développement

Après avoir cloné le dépôt, exécutez `bundle install` pour installer les dépendances.

Lancer la suite de tests :
```bash
bundle exec rake spec
```

Lancer RuboCop pour les contrôles de qualité de code :
```bash
bundle exec rake rubocop
```

Lancer à la fois les tests et RuboCop :
```bash
bundle exec rake
```

Pour installer cette gem sur votre machine locale, exécutez `bundle exec rake install`.

## Contribuer

Les rapports de bug et les pull requests sont les bienvenus sur GitHub : https://github.com/Isalafont/dsfr_accessible_skip_links.

## Licence

Cette gem est disponible en open source selon les termes de la [licence MIT](https://opensource.org/licenses/MIT).
